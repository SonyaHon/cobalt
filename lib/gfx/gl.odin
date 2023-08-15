package lib

import glm "core:math/linalg/glsl"

import gl "vendor:OpenGL"
import stb "vendor:stb/image"

TexturesStruct :: struct {
    PlayerIdle: Texture,
}

Textures := TexturesStruct{}

VERTICES := [?]f32 {
    0.5,  0.5, 0,  // top right
    0.5, -0.5, 0,  // bottom right
    -0.5, -0.5, 0,  // bottom left
    -0.5,  0.5, 0   // top left
}

UVS := [?]f32 {
    1.0, 0.0,
    1.0, 1.0,
    0.0, 1.0,
    0.0, 0.0,
}

INDICES := [?]u32 {
    0, 1, 3,
    1, 2, 3
}

NULL_VAO :: 0

SpriteMesh :: struct {
    vao: u32,
    vertices_vbo: u32,
    uvs_vbo: u32,
    indices_vbo: u32,
}

Texture :: struct {
    id: u32,
    total_frames: u32,
    frames_horizontal: u32,
    frames_vertical: u32,
    frame_width: f32,
    frame_height: f32,
    uv_scale: glm.vec2,
}

calculate_offset_for_frame :: proc(texture: ^Texture, frame: u32) -> glm.vec2 {
    frame := frame % texture.total_frames

    x := frame %  texture.frames_horizontal
    y := frame / texture.frames_horizontal

    return glm.vec2{ f32(x) * texture.frame_width ,  f32(y) * texture.frame_height }
}

make_texture :: proc(path: cstring, frames_horizontal: u32 = 1, frames_vertical: u32 = 1) -> Texture {
    texture := Texture{ 
        frames_horizontal = frames_horizontal,
        frames_vertical = frames_vertical,
        total_frames = frames_horizontal * frames_vertical,
    }

    width, height, channgels: i32
    img_data := stb.load(path, &width, &height, &channgels, 0)
    defer stb.image_free(img_data)

    gl.GenTextures(1, &texture.id)
    gl.ActiveTexture(gl.TEXTURE0)
    gl.BindTexture(gl.TEXTURE_2D, texture.id)
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.MIRRORED_REPEAT)
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.MIRRORED_REPEAT)
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST)
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST)
    gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, img_data)
    gl.GenerateMipmap(gl.TEXTURE_2D)

    texture.frame_width = 1.0 / f32(frames_horizontal)
    texture.frame_height = 1.0 / f32(frames_vertical)
    texture.uv_scale = glm.vec2{texture.frame_width, texture.frame_height}

    return texture
}

bind_texture :: proc(texture: ^Texture, texture_slot: u32 = gl.TEXTURE0) {
    gl.ActiveTexture(texture_slot)
    gl.BindTexture(gl.TEXTURE_2D, texture.id)
}

make_sprite_mesh :: proc() -> SpriteMesh {
    sprite := SpriteMesh{}
    gl.GenVertexArrays(1, &sprite.vao)
    gl.BindVertexArray(sprite.vao)

    gl.GenBuffers(1, &sprite.indices_vbo)
    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, sprite.indices_vbo)
    gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, size_of(INDICES), &INDICES, gl.STATIC_DRAW)


    gl.GenBuffers(1, &sprite.vertices_vbo)
    gl.BindBuffer(gl.ARRAY_BUFFER, sprite.vertices_vbo)
    gl.BufferData(gl.ARRAY_BUFFER, size_of(VERTICES), &VERTICES, gl.STATIC_DRAW)
    gl.VertexAttribPointer(0, 3, gl.FLOAT, false, 3 * size_of(f32), 0)
    gl.EnableVertexAttribArray(0)

    gl.GenBuffers(1, &sprite.uvs_vbo)
    gl.BindBuffer(gl.ARRAY_BUFFER, sprite.uvs_vbo)
    gl.BufferData(gl.ARRAY_BUFFER, size_of(UVS), &UVS, gl.STATIC_DRAW)
    gl.VertexAttribPointer(1, 2, gl.FLOAT, false, 2 * size_of(f32), 0)
    gl.EnableVertexAttribArray(1)

    gl.BindVertexArray(NULL_VAO)

    return sprite
}

bind_sprite_mesh :: proc(sprite: ^SpriteMesh) {
    gl.BindVertexArray(sprite.vao)
}

unbind_sprite_mesh :: proc() {
    gl.BindVertexArray(NULL_VAO)
}

draw_sprite_mesh :: proc() {
    gl.DrawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, nil)
}

destroy_sprite :: proc(sprite: ^SpriteMesh) {
    gl.DeleteBuffers(1, &sprite.vertices_vbo)
    gl.DeleteBuffers(1, &sprite.uvs_vbo)
    gl.DeleteBuffers(1, &sprite.indices_vbo)
    gl.DeleteVertexArrays(1, &sprite.vao)
}

load_textures :: proc() {
    Textures.PlayerIdle = make_texture("assets/textures/idle.png", 10, 1)
}