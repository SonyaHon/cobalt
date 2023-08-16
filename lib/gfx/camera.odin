package lib

import glm "core:math/linalg/glsl"

PROJECTION_MATRIX := glm.mat4Ortho3d(0, 800, 0, 600, 0.1, 10.0)
MainCamera := make_camera()

Camera :: struct {
	position: glm.vec3,
}

make_camera :: proc() -> Camera {
    return Camera {
        position = glm.vec3{0, 0, -1.0}
    } 
}

transform_camera :: proc(camera: ^Camera, transformation: glm.vec3) {
    camera.position -= transformation
}

bind_camera :: proc(camera: ^Camera, shader: ^Shader) {
   set_uniform(shader.projection_location, PROJECTION_MATRIX) 
   set_uniform(shader.view_location, 
    glm.identity(glm.mat4x4) * glm.mat4Translate(camera.position)
   )
}
