package lib

import "core:fmt"
import "core:os"
import "core:runtime"
import glm "core:math/linalg/glsl"

import "vendor:glfw"
import open_gl "vendor:OpenGL"

glfw_error_callback :: proc "c" (code: i32, description: cstring) {
	context = runtime.default_context()
	fmt.printf("GLFW Exception [%d]:\n%s", code, description)
}

RESIZE_CALLBACK : proc() = nil

glfw_resize_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	context = runtime.default_context()
	SCREEN_HEIGHT = height
	SCREEN_WIDTH = width

	open_gl.Viewport(0, 0, width, height)
	PROJECTION_MATRIX = glm.mat4Ortho3d(0, f32(SCREEN_WIDTH), 0, f32(SCREEN_HEIGHT), 0.1, 10.0)

	if RESIZE_CALLBACK != nil {
		RESIZE_CALLBACK()
	}
}

OPENG_GL_MAJOR :: 4
OPENG_GL_MINOR :: 1
GLFW_TRUE :: 1

CLEAR_COLOR := [3]f32{0, 0, 0}

SCREEN_WIDTH: i32 = 800
SCREEN_HEIGHT: i32 = 600

create_window :: proc(name: cstring, width: i32, height: i32) -> glfw.WindowHandle {
	if glfw.Init() == 0 {
		fmt.eprintf("Error during intialization of GLFW")
		os.exit(1)
	}

	glfw.SetErrorCallback(glfw_error_callback)

	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, OPENG_GL_MAJOR)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, OPENG_GL_MINOR)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, GLFW_TRUE)
	glfw.WindowHint(glfw.RESIZABLE, GLFW_TRUE)

	window := glfw.CreateWindow(width, height, name, nil, nil)
	SCREEN_WIDTH = width
	SCREEN_HEIGHT = height

	if window == nil {
		fmt.eprintf("Error during window initialization")
		glfw.Terminate()
		os.exit(1)
	}

	glfw.SetFramebufferSizeCallback(window, glfw_resize_callback)

	glfw.MakeContextCurrent(window)
	open_gl.load_up_to(OPENG_GL_MAJOR, OPENG_GL_MINOR, glfw.gl_set_proc_address)
	open_gl.Enable(open_gl.BLEND)
	open_gl.BlendFunc(open_gl.SRC_ALPHA, open_gl.ONE_MINUS_SRC_ALPHA)

	return window
}

should_close :: proc(window: glfw.WindowHandle) -> bool {
	return bool(glfw.WindowShouldClose(window))
}

set_cls_color :: proc(r: f32, g: f32, b: f32) {
	CLEAR_COLOR[0] = r
	CLEAR_COLOR[1] = g
	CLEAR_COLOR[2] = b
}

cls :: proc() {
	open_gl.ClearColor(CLEAR_COLOR[0], CLEAR_COLOR[1], CLEAR_COLOR[2], 1.0)
	open_gl.Clear(open_gl.COLOR_BUFFER_BIT | open_gl.DEPTH_BUFFER_BIT)
}

ups :: proc(window: glfw.WindowHandle) {
	glfw.SwapBuffers(window)
	glfw.PollEvents()

	if open_gl.GetError() != 0 {
		fmt.eprintf("Error: %d", open_gl.GetError())
	}
}

terminate :: proc(window: glfw.WindowHandle) {
	glfw.DestroyWindow(window)
	glfw.Terminate()
}

get_time :: proc() -> f64 {
	return glfw.GetTime()
}