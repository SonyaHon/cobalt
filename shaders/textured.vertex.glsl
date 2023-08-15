#version 330 core

layout(location = 0) in vec3 a_position;
layout(location = 1) in vec2 a_uvs;

out vec2 uvs;

uniform mat4 transformation_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

void main() {
    uvs = a_uvs;
    gl_Position = projection_matrix * view_matrix * transformation_matrix * vec4(a_position, 1.0);
}