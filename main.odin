package main

import "core:fmt"
import glm "core:math/linalg/glsl"

import "lib/gfx"

main :: proc() {
	window := gfx.create_window("Carbon", 800, 600)
	defer gfx.terminate(window)

	// gfx.load_shaders()
	// gfx.use_shader(gfx.SHADER_BASIC)

	gfx.set_cls_color(0, 0, 0)

	// sprite := gfx.make_sprite_mesh()
	// gfx.bind_sprite_mesh(&sprite)

	// texture := gfx.make_texture("assets/textures/idle.png")
	// gfx.bind_texture(&texture)

	// t_loc := gfx.get_transformation_matrix_location(gfx.SHADER_BASIC)
	// p_loc := gfx.get_projection_matrix_location(gfx.SHADER_BASIC)
	// v_loc := gfx.get_view_matrix_location(gfx.SHADER_BASIC)

	// gfx.set_uniform(
	// 	t_loc,
	// 	glm.identity(glm.mat4x4) * glm.mat4Rotate(glm.vec3{0.0, 0.0, 1.0}, glm.radians_f32(90)),
	// )
	// gfx.set_uniform(p_loc, glm.mat4Perspective(
	// 	glm.radians_f32(45),
	// 	8 / 6,
	// 	0.1, 
	// 	100.0
	// ))
	// gfx.set_uniform(v_loc, glm.identity(glm.mat4x4) * glm.mat4Translate(glm.vec3{0.0, 0.0, -10.0}))

	camera := gfx.make_camera()

	sprite := gfx.Sprite {
		mesh = gfx.make_sprite_mesh(),
		texture = gfx.make_texture("assets/textures/idle.png", 10, 1),
		shader = gfx.make_shader("shaders/basic.vertex.glsl", "shaders/basic.fragment.glsl"),
		position = glm.vec2{0, 0},
		rotation = 0,
		scale = glm.vec2{1, 1}
	}

	frame: u32 = 0
	tick := 0

	for !gfx.should_close(window) {
		gfx.cls()

		// Update 
		// gfx.rotate_sprite(&sprite, 1)
		// gfx.transform_camera(&camera, glm.vec3{0, 0, 0.02})
		if tick >= 5 {
			frame += 1
			tick = 0
		}
		tick += 1

		// Render
		gfx.render_sprite(&sprite, &camera, frame)

		gfx.ups(window)
	}
}
