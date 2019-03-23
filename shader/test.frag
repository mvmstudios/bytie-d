
#version 330 core

layout (location = 0) out vec4 fragment_color;

in vec4 vertex_color;

void main() {
    fragment_color = vertex_color;
}

