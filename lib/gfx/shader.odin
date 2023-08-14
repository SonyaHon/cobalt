package lib

import "core:os"
import "core:fmt"
import "core:strings"

import glm "core:math/linalg/glsl"
import gl "vendor:OpenGL"


SHADER_BASIC: u32 = 0

Shader :: struct {
	id:                      u32,
	projection_location:     i32,
	view_location:           i32,
	transformation_location: i32,
	uv_scale_location:       i32,
	frame_offset_location:   i32,
}

make_shader :: proc(vertex_path: string, fragment_path: string) -> Shader {
	shader := Shader{}
	link_program(&shader.id, vertex_path, fragment_path)
	shader.projection_location = get_projection_matrix_location(shader.id)
	shader.view_location = get_view_matrix_location(shader.id)
	shader.transformation_location = get_transformation_matrix_location(shader.id)
	shader.uv_scale_location = get_uv_scale_location(shader.id)
	shader.frame_offset_location = get_frame_offset_location(shader.id)

	return shader
}

compile_shader :: proc(shader_type: u32, source_path: string) -> u32 {
	file, ok := os.read_entire_file_from_filename(source_path)
	if !ok {
		fmt.eprintf("Error opening file %s", source_path)
		os.exit(1)
	}
	defer delete(file)


	shader_source: cstring = strings.clone_to_cstring(string(file))
	shader := gl.CreateShader(shader_type)
	gl.ShaderSource(shader, 1, &shader_source, nil)
	gl.CompileShader(shader)

	success: i32 = 0
	gl.GetShaderiv(shader, gl.COMPILE_STATUS, &success)
	if success == 0 {
		info_log: [512]u8 = {}
		gl.GetShaderInfoLog(shader, 512, nil, ([^]u8)(&info_log))
		fmt.eprintf("Error compiling %s:\n%s", source_path, info_log)
		os.exit(1)
	}
	return shader
}

link_program :: proc(target: ^u32, vertex_path: string, fragment_path: string) {
	program := gl.CreateProgram()
	vertex := compile_shader(gl.VERTEX_SHADER, vertex_path)
	fragment := compile_shader(gl.FRAGMENT_SHADER, fragment_path)
	gl.AttachShader(program, vertex)
	gl.AttachShader(program, fragment)
	gl.LinkProgram(program)
	success: i32 = 0
	gl.GetProgramiv(program, gl.LINK_STATUS, &success)
	if success == 0 {
		info_log: [512]u8 = {}
		gl.GetProgramInfoLog(program, 512, nil, ([^]u8)(&info_log))
		fmt.eprintf("Error building shader program: %s", info_log)
		os.exit(1)
	} else {
		target^ = program
	}
}

load_shaders :: proc() {
	link_program(&SHADER_BASIC, "shaders/basic.vertex.glsl", "shaders/basic.fragment.glsl")
}

get_transformation_matrix_location :: proc(shader: u32) -> i32 {
	return gl.GetUniformLocation(shader, "transformation_matrix")
}

get_projection_matrix_location :: proc(shader: u32) -> i32 {
	return gl.GetUniformLocation(shader, "projection_matrix")
}

get_view_matrix_location :: proc(shader: u32) -> i32 {
	return gl.GetUniformLocation(shader, "view_matrix")
}

get_uv_scale_location :: proc(shader: u32) -> i32 {
	return gl.GetUniformLocation(shader, "uv_scale")
}

get_frame_offset_location :: proc(shader: u32) -> i32 {
	return gl.GetUniformLocation(shader, "frame_offset")
}

set_uniform_matrix4f :: proc(location: i32, mat: glm.mat4x4) {
	matrix_data := matrix_flatten(mat)
	gl.UniformMatrix4fv(location, 1, false, ([^]f32)(&matrix_data))
}

set_uniform_vec2f :: proc(location: i32, vec: glm.vec2) {
	gl.Uniform2f(location, vec.x, vec.y)
}

set_uniform :: proc {
	set_uniform_matrix4f,
	set_uniform_vec2f,
}

use_shader :: proc(shader: u32) {
	gl.UseProgram(shader)
}
