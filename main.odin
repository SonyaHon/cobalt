package main

import "core:fmt"
import "core:os"
import glm "core:math/linalg/glsl"

import tt "vendor:stb/truetype"
import fs "vendor:fontstash"
import gl "vendor:OpenGL"

import "lib/gfx"
import "game"

init :: proc() {
	gfx.load_shaders()
	gfx.load_textures()
	// gfx.initialize_text_rendering()
	gfx.set_cls_color(0, 0, 0)
	game.initialize()
}

terminate :: proc() {
	game.teardown()
	gfx.terminate_text_rendering()
}

update :: proc(time_elapsed: f64) {
	game.update(time_elapsed)
}

render :: proc() {
	game.render()
}

main :: proc() {
	window := gfx.create_window("Carbon", 800, 600)
	defer gfx.terminate(window)
	init()
	time_elapsed: f64 = 0
	for !gfx.should_close(window) {
		start := gfx.get_time()
		gfx.cls()
		update(time_elapsed)
		render()
		gfx.ups(window)
		time_elapsed = (gfx.get_time() - start) * 1000
	}
	terminate()
}
