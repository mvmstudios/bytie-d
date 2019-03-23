
#version 330 core

layout (location = 0) in vec3 attribute_position;
layout (location = 1) in vec4 attribute_color;

out vec4 vertex_color;

void main() {
    gl_Position = vec4(attribute_position, 1.0);
    vertex_color = attribute_color;
}


