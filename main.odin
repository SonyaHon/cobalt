package main

import "core:fmt"
import glm "core:math/linalg/glsl"

import "lib/gfx"

player_update :: proc(player: ^gfx.Sprite) {
	if player.position.y >= -0.015 {
		player.position.y -= 0.05
		fmt.printf("Player falling\n")
	}
}

main :: proc() {
	window := gfx.create_window("Carbon", 800, 600)
	defer gfx.terminate(window)

	gfx.load_shaders()
	gfx.load_textures()
	gfx.set_cls_color(0, 0, 0)

	player := gfx.make_sprite(gfx.Textures.PlayerIdle, gfx.Shaders.Textured)
	gfx.set_sprite_position(&player, glm.vec2{0.0, 0.3})
	gfx.scale_sprite(&player, 0.2)

	ground := gfx.make_sprite(glm.vec3{0.933,0.769,0.529}, gfx.Shaders.Colored)
	gfx.set_sprite_position(&ground, glm.vec2{0.0, -0.4})
	gfx.scale_sprite(&ground, glm.vec2{1, 0.5})

	frame: u32 = 0
	tick := 0

	for !gfx.should_close(window) {
		gfx.cls()

		// Update
		player_update(&player)

		// Render
		gfx.render_sprite(&ground, &gfx.MainCamera)
		gfx.render_sprite(&player, &gfx.MainCamera, frame)

		gfx.ups(window)
	}
}
