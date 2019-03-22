module bytied.shader.shader;

import std.file;
import std.string;

import bindbc.opengl;

class GlShader {
    private:
        GLuint programPointer;

    public:
        this(string vertexShaderFilename, string fragmentShaderFilename) {
            
        }

    private:
        static GLuint compilerShader(string shaderSource, GLenum shaderType) {
            GLuint shaderPointer = glCreateShader(shaderType);

            const GLchar* sourcePointer = &shaderSource.dup[0];
            glShaderSource(shaderPointer, 1, &sourcePointer, null);

            glCompileShader(shaderPointer);

            GLint result;
            glGetShaderiv(shaderPointer, GL_COMPILE_STATUS, &result);

            if (result != GL_TRUE) {
                GLint errLength;
                glGetShaderiv(shaderPointer, GL_INFO_LOG_LENGTH, &errLength);

                GLchar[] errorMessage;
                scope (exit)
                    errorMessage.destroy;

                errorMessage.length = errLength;

                glGetShaderInfoLog(shaderPointer, errLength, &errLength, &errorMessage[0]);
            }

            return shaderPointer;
        }
}