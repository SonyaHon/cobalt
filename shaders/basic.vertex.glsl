#version 330 core

layout(location = 0) in vec3 aPosition;
layout(location = 1) in vec2 aUV;

out vec2 inUV;

void main() {
    inUV = aUV;
    gl_Position = vec4(aPosition.x, aPosition.y, aPosition.z, 1.0);
}