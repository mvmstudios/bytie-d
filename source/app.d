import std.stdio;

import bindbc.sdl;
import bindbc.opengl;

import bytied.types.vertex;
import bytied.buffer.vertexbuffer;
import bytied.buffer.indexbuffer;

//void function(GLenum,GLenum,GLuint,GLenum,GLsizei,const(GLchar)*,GLvoid*)
extern (C) void dglDebugMessageCallback(GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const GLchar* message, const void* userParams) {
	import std.string : fromStringz;
	writefln("OpenGL Debug: %s", message.fromStringz);
}

//uint, uint, uint, uint, int, const(char)*, void*) nothrow, const(void)*
// uint source, uint type, uint pointer, uint serverity, int length, const(char*) message, const(void*) paramenters)

/*
@TODO: Error handling 
*/
void main() {
	loadSDL();

	SDL_GL_SetSwapInterval(1);

	SDL_Window* window = SDL_CreateWindow("Bytie-D", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 600, SDL_WINDOW_RESIZABLE | SDL_WINDOW_OPENGL);
	SDL_GL_CreateContext(window);

	GLSupport ret = loadOpenGL();
	if (ret == GLSupport.gl41) {
		writeln("OpenGL 4.1 ready");
	} else if (ret == GLSupport.gl33) {
		writeln("OpenGL 3.3 ready");
	} else {
		writefln("Error loading OpenGL %s", ret);
	}

	glEnable(GL_DEBUG_OUTPUT);
    glEnable(GL_DEBUG_OUTPUT_SYNCHRONOUS);
    glDebugMessageCallback(cast(GLDEBUGPROC) &dglDebugMessageCallback, null);

	Vertex[] vertices = [
        Vertex(-0.5, -0.5, 0.0,
        1.0, 0.0, 0.0, 1.0),
        Vertex( 0.0, 0.5, 0.0,
        0.0, 1.0, 0.0, 1.0 ),
        Vertex( 0.5, -0.5, 0.0,
        0.0, 0.0, 1.0, 1.0 )
	];

	GLuint[] indices = [ 0, 1, 2 ]; 
	
	IndexBuffer indexBuffer = new IndexBuffer(cast(void*) indices, cast(int) indices.length, uint.sizeof);

	VertexBuffer vertexBuffer = new VertexBuffer(cast(void*) vertices, cast(int) vertices.length);

	bool closeRequested = false;
	while (!closeRequested) {
		SDL_Event event;
		while (SDL_PollEvent(&event)) {
			switch (event.type) {
				case SDL_QUIT:
					closeRequested = true;
					break;
				default: break;
			}
		}

		glClearColor(0, 0, 0, 1);
		glClear(GL_COLOR_BUFFER_BIT);

		vertexBuffer.bind();
		indexBuffer.bind();

		//GLenum,GLsizei,GLenum,const(GLvoid)*
		// ERROR
		glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_INT, null);

		vertexBuffer.unbind();
		indexBuffer.unbind();

		SDL_GL_SwapWindow(window);

	}

}