#version 330 core

in vec2 uvs;

out vec4 FragColor;

uniform vec2 uv_scale;
uniform vec2 frame_offset;
uniform sampler2D main_texture;

void main() {
    FragColor = texture(main_texture, vec2(uvs.x * uv_scale.x, uvs.y * uv_scale.y) + frame_offset);
}