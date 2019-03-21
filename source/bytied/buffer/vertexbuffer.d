module bytied.buffer.vertexbuffer;

import bindbc.opengl;
import bytied.types.vertex;
import bytied.buffer.glbuffer;

class VertexBuffer : GlBuffer {

    private:
        GLuint _vertexArrayObjectPointer;
        GLuint _bufferPointer;

    public:
        this(void* data, int verticesSize) {
            glGenVertexArrays(1, &_vertexArrayObjectPointer);
            glBindVertexArray(_vertexArrayObjectPointer);

            glGenBuffers(1, &_bufferPointer);
            glBindBuffer(GL_ARRAY_BUFFER, _bufferPointer);

            glBufferData(GL_ARRAY_BUFFER, verticesSize * Vertex.sizeof, data, GL_STATIC_DRAW);

            glEnableVertexAttribArray(0);
            glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*) Vertex.x.offsetof);

            glEnableVertexAttribArray(1);
            glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*) Vertex.r.offsetof);

            unbind();
        }

        ~this() {
            glDeleteBuffers(1, &_bufferPointer);
        }

        override void bind() {
            glBindVertexArray(_vertexArrayObjectPointer);
        }

        override void unbind() {
            glBindVertexArray(0);
        }

}