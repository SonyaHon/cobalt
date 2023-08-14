#version 330 core

in vec2 uvs;

out vec4 FragColor;

uniform sampler2D main_texture;

void main() {
    FragColor = texture(main_texture, uvs);
}