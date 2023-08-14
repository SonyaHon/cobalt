package main

import "core:fmt"

import "lib/gfx"

main :: proc() {
	window := gfx.create_window("Carbon", 800, 600)
	defer gfx.terminate(window)

    gfx.load_shaders()
    gfx.use_shader(gfx.SHADER_BASIC)

	gfx.set_cls_color(0, 0, 0)

	sprite := gfx.make_sprite_mesh()
	gfx.bind_sprite_mesh(&sprite)

	texture := gfx.make_texture("assets/textures/idle.png")
	gfx.bind_texture(&texture)

	for !gfx.should_close(window) {
		gfx.cls()

		// Update 

		// Render
		gfx.draw_sprite_mesh()

		gfx.ups(window)
	}
}
