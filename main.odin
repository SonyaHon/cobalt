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

	sprite := gfx.make_sprite(gfx.Textures.PlayerIdle, gfx.Shaders.Basic)

	frame: u32 = 0
	tick := 0

	for !gfx.should_close(window) {
		gfx.cls()

		if tick >= 8 {
			frame += 1
			tick = 0
		}
		tick += 1

		// Render
		gfx.render_sprite(&sprite, &gfx.MainCamera, frame)

		gfx.ups(window)
	}
}
