package main

import "core:fmt"
import glm "core:math/linalg/glsl"

import "lib/gfx"

main :: proc() {
	window := gfx.create_window("Carbon", 800, 600)
	defer gfx.terminate(window)

	gfx.load_shaders()
	gfx.load_textures()
	gfx.set_cls_color(0, 0, 0)

	player := gfx.make_sprite(gfx.Textures.PlayerIdle, gfx.Shaders.Textured)
	gfx.scale_sprite(&player, 48 * 2)
	gfx.set_sprite_position(&player, glm.vec2{400, 300})

	ruler := gfx.make_sprite(glm.vec3{0, 0.5, 1.0}, gfx.Shaders.Colored)
	gfx.scale_sprite(&ruler, glm.vec2{100, 100})
	gfx.set_sprite_position(&ruler, glm.vec2{400, 300})

	for !gfx.should_close(window) {
		gfx.cls()

		// Update

		// Render
		gfx.render_sprite(&ruler, &gfx.MainCamera)
		gfx.render_sprite(&player, &gfx.MainCamera)

		gfx.ups(window)
	}
}
