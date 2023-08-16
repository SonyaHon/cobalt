package lib

Animation :: struct {
	loop:    bool,
	time_per_frame:    f64,
    time_since_last_change: f64,
    total_frames: u32,
    current_frame: u32,
    ended: bool,
}

make_animation :: proc(should_loop: bool, animation_time: f64, frames_count: u32, starting_frame: u32 = 0) -> Animation {
    return Animation {
        loop = should_loop,
        time_per_frame = animation_time / f64(frames_count),
        time_since_last_change = 0,
        total_frames = frames_count,
        current_frame = starting_frame,
        ended = false,
    }
}

reset_animation :: proc(animation: ^Animation) {
    animation.ended = false
    animation.time_since_last_change = 0
    animation.current_frame = 0
}

update_animation :: proc(animation: ^Animation, time_elapsed: f64) {
    if animation.ended  {
        return
    }

    if animation.time_since_last_change + time_elapsed >= animation.time_per_frame {
        animation.current_frame += 1
        animation.time_since_last_change = 0
    } else {
        animation.time_since_last_change += time_elapsed
    }

    if animation.current_frame >= animation.total_frames {
        if animation.loop {
            animation.current_frame = 0
        } else {
            animation.ended = true
            animation.current_frame = animation.total_frames - 1
        }
    }
}