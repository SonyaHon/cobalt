package lib

import "core:fmt"

import glm "core:math/linalg/glsl"

Sprite :: struct {
	mesh:     SpriteMesh,
	texture:  Texture,
	shader:   Shader,
	position: glm.vec2,
	rotation: f32,
	scale:   glm.vec2,
}

make_sprite_default :: proc(texture: Texture, shader: Shader,) -> Sprite {
    return Sprite {
        mesh = make_sprite_mesh(),
        texture = texture,
        shader = shader,
        position = glm.vec2{0, 0},
        rotation = 0,
        scale = glm.vec2{1, 1}
    }
}

make_sprite_with_position :: proc(texture: Texture, shader: Shader, position: glm.vec2) -> Sprite {
    return Sprite {
        mesh = make_sprite_mesh(),
        texture = texture,
        shader = shader,
        position = position,
        rotation = 0,
        scale = glm.vec2{1, 1}
    }
}

make_sprite_setting_all :: proc(texture: Texture, shader: Shader, position: glm.vec2, rotation: f32, scale: glm.vec2) -> Sprite {
    return Sprite {
        mesh = make_sprite_mesh(),
        texture = texture,
        shader = shader,
        position = position,
        rotation = rotation,
        scale = scale
    }
}

make_sprite :: proc {
    make_sprite_default,
    make_sprite_setting_all,
    make_sprite_with_position,
}

set_sprite_position :: proc(sprite: ^Sprite, position: glm.vec2) {
    sprite.position = position
}

translate_sprite :: proc(sprite: ^Sprite, translation: glm.vec2) {
    sprite.position += translation
}

set_sprite_rotation :: proc(sprite: ^Sprite, rotation_deg: f32) {
    sprite.rotation = glm.radians(rotation_deg)
}

rotate_sprite :: proc(sprite: ^Sprite, rotation_deg: f32) {
    sprite.rotation += glm.radians(rotation_deg)
}

scale_sprite_uniform :: proc(sprite: ^Sprite, scale_factor: f32) {
    sprite.scale = glm.vec2{scale_factor, scale_factor}
}
scale_sprite_axis :: proc(sprite: ^Sprite, scale_factor: glm.vec2) {
    sprite.scale = scale_factor
}

scale_sprite :: proc{
    scale_sprite_axis,
    scale_sprite_uniform
}

render_sprite :: proc(sprite: ^Sprite, camera: ^Camera, frame: u32 = 0) {
    use_shader(sprite.shader.id)

    bind_texture(&sprite.texture)
    bind_sprite_mesh(&sprite.mesh)
    bind_camera(camera, &sprite.shader)

    set_uniform(
        sprite.shader.uv_scale_location,
        sprite.texture.uv_scale
    )

    offset := calculate_offset_for_frame(&sprite.texture, frame)
    set_uniform(
        sprite.shader.frame_offset_location,
        offset
    )

    set_uniform(
        sprite.shader.transformation_location,
        glm.identity(glm.mat4x4) * 
        glm.mat4Translate(glm.vec3{sprite.position.x, sprite.position.y, 0.0}) * 
        glm.mat4Rotate(glm.vec3{0.0, 0.0, -1.0}, sprite.rotation) *
        glm.mat4Scale(glm.vec3{sprite.scale.x, sprite.scale.y, 1.0})
    )

    draw_sprite_mesh()
}
