module bytied.buffer.indexbuffer;

import bindbc.opengl;
import bytied.buffer.glbuffer;

class IndexBuffer : GlBuffer {
    private:
        GLuint _bufferPointer;

    public:
        this(void* data, int indicesSize, ubyte elementSize) {
            glGenBuffers(1, &_bufferPointer);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _bufferPointer);

            glBufferData(GL_ELEMENT_ARRAY_BUFFER, indicesSize * elementSize, data, GL_STATIC_DRAW);

            unbind();
        }

        ~this() {
            glDeleteBuffers(1, &_bufferPointer);
        }

        override void bind() {
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _bufferPointer);
        }

        override void unbind() {
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        }
}