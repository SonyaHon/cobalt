package lib

import "core:os"
import "core:fmt"
import "core:strings"

import gl "vendor:OpenGL"


SHADER_BASIC: u32 = 0

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

use_shader :: proc(shader: u32) {
	gl.UseProgram(shader)
}
