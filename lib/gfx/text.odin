package lib

import gl "vendor:OpenGL"

__text_vao, __text_vbo: u32

initialize_text_rendering :: proc() {
	gl.GenVertexArrays(1, &__text_vao)
	gl.GenBuffers(1, &__text_vbo)
	gl.BindVertexArray(__text_vao)
	gl.BindBuffer(gl.ARRAY_BUFFER, __text_vbo)
	gl.BufferData(gl.ARRAY_BUFFER, size_of(f32) * 6 * 4, nil, gl.DYNAMIC_DRAW)
	gl.EnableVertexAttribArray(0)
	gl.VertexAttribPointer(0, 4, gl.FLOAT, gl.FALSE, 4 * size_of(f32), 0)
	gl.BindBuffer(gl.ARRAY_BUFFER, 0)
	gl.BindVertexArray(0)
}

terminate_text_rendering :: proc() {
	gl.DeleteBuffers(1, &__text_vbo)
	gl.DeleteVertexArrays(1, &__text_vao)
}

render_text :: proc(x: f32, y: f32, data: string) {
    
}
