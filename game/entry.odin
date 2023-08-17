package game

import "../lib/gfx"
import glm "core:math/linalg/glsl"

sprite: gfx.Sprite

initialize :: proc() {
	sprite = gfx.make_sprite(glm.vec3{0.0, 0.5, 1.0}, gfx.Shaders.Colored)
	gfx.scale_sprite(&sprite, 100)
}

teardown :: proc() {
	gfx.destroy_sprite(&sprite)
}


update :: proc(time_elapsed: f64) {

}

render :: proc() {
	gfx.set_sprite_position(&sprite, gfx.SPRITE_POSITION_CENTER())
	gfx.render_sprite(&sprite, &gfx.MainCamera)
}
