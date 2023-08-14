package lib

import glm "core:math/linalg/glsl"

Sprite :: struct {
	mesh:     SpriteMesh,
	texture:  Texture,
	shader:   Shader,
	position: glm.vec2,
	rotation: f32,
	scale:   glm.vec2,
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

render_sprite :: proc(sprite: ^Sprite, camera: ^Camera) {
    use_shader(sprite.shader.id)

    bind_texture(&sprite.texture)
    bind_sprite_mesh(&sprite.mesh)
    bind_camera(camera, &sprite.shader)

    set_uniform(
        sprite.shader.transformation_location,
        glm.identity(glm.mat4x4) * 
        glm.mat4Translate(glm.vec3{sprite.position.x, sprite.position.y, 0.0}) * 
        glm.mat4Rotate(glm.vec3{0.0, 0.0, -1.0}, sprite.rotation) *
        glm.mat4Scale(glm.vec3{sprite.scale.x, sprite.scale.y, 1.0})
    )

    draw_sprite_mesh()
}
