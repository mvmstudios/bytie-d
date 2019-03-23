module bytied.shader.glshader;

import std.stdio;
import std.string;
import std.file;

import bindbc.opengl;

class GlShader {
    private:
        GLuint _programPointer;
        
        static GLuint compileShader(string shaderSource, GLenum shaderType) {
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

    public:
        this(string vertexShaderFilename, string fragmentShaderFilename) {
            string vertexShaderSource = readText(vertexShaderFilename);
            string fragmentShaderSource = readText(fragmentShaderFilename);

            _programPointer = glCreateProgram();

            GLuint vertexShaderPointer = compileShader(vertexShaderSource, GL_VERTEX_SHADER);
            GLuint fragmentShaderPointer = compileShader(fragmentShaderSource, GL_FRAGMENT_SHADER);

            glAttachShader(_programPointer, vertexShaderPointer);
            glAttachShader(_programPointer, fragmentShaderPointer);

            glLinkProgram(_programPointer);

            GLint status;
            glGetProgramiv(_programPointer, GL_LINK_STATUS, &status);
            writeln(status);
            if (status != GL_TRUE) {
                GLsizei logLength = 0;
                GLchar[] logMessage;

                glGetProgramiv(_programPointer, GL_INFO_LOG_LENGTH, &logLength);
                logMessage.length = logLength;

                glGetProgramInfoLog(_programPointer, logLength, &logLength, &logMessage[0]);

                writeln(logMessage);
            }

            glDetachShader(_programPointer, vertexShaderPointer);
            glDetachShader(_programPointer, fragmentShaderPointer);

            glDeleteShader(vertexShaderPointer);
            glDeleteShader(fragmentShaderPointer);
        }

        ~this() {
            glDeleteProgram(_programPointer);
        }

        void bind() {
            glUseProgram(_programPointer);
        }

        void unbind() {
            glUseProgram(0);
        }

        GLuint programPointer() {
            return _programPointer;
        }
}