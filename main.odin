package main

import "core:fmt"
import "core:os"
import glm "core:math/linalg/glsl"

import tt "vendor:stb/truetype"
import fs "vendor:fontstash"
import gl "vendor:OpenGL"

import "lib/gfx"


player: gfx.Sprite
player_idle_animation: gfx.Animation

init :: proc() {
	gfx.initialize_text_rendering()
}

terminate :: proc() {
	gfx.terminate_text_rendering()
}

update :: proc(time_elapsed: f64) {
	gfx.update_animation(&player_idle_animation, time_elapsed)
}

render :: proc() {
	gfx.render_animated_sprite(&player, &gfx.MainCamera, &player_idle_animation)
	gfx.render_text(100, 100, "Hello, Cobalt!")
}

main :: proc() {
	window := gfx.create_window("Carbon", 800, 600)
	defer gfx.terminate(window)

	gfx.RESIZE_CALLBACK = proc() {
		render()
	}


	gfx.load_shaders()
	gfx.load_textures()
	gfx.set_cls_color(0, 0, 0)

	player_idle_animation = gfx.make_animation(true, 600, 10)
	player = gfx.make_sprite(gfx.Textures.PlayerIdle, gfx.Shaders.Textured)
	gfx.scale_sprite(&player, 48 * 2)
	gfx.set_sprite_position(&player, glm.vec2{400, 300})

	time_elapsed: f64 = 0

	// file, ok := os.read_entire_file("assets/fonts/REMOFA.otf")
	// font_info := tt.fontinfo{}

	// tt.InitFont(&font_info, ([^]byte)(&file), 0)
	// ascent, descent, line_gap: i32

	// tt.GetFontVMetrics(&font_info, &ascent, &descent, &line_gap)

	init()
	for !gfx.should_close(window) {
		start := gfx.get_time()
		gfx.cls()

		// Update
		update(time_elapsed)

		// Render
		render()

		gfx.ups(window)
		time_elapsed = (gfx.get_time() - start) * 1000
	}
	terminate()
}
