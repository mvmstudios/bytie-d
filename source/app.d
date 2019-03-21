import std.stdio;

import bindbc.sdl;
import bindbc.opengl;

import bytied.types.vertex;
import bytied.buffer.vertexbuffer;

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

	Vertex[] vertices = [
        { -0.5, -0.5, 0.0,
        1.0, 0.0, 0.0, 1.0 },
        { 0.0, 0.5, 0.0,
        0.0, 1.0, 0.0, 1.0 },
        { 0.5, -0.5, 0.0,
        0.0, 0.0, 1.0, 1.0 }
	];
    int verticesSize = 3;

	VertexBuffer vertexBuffer = new VertexBuffer(cast(void*) vertices, verticesSize);

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

		glDrawArrays(GL_TRIANGLES, 0, verticesSize);

		vertexBuffer.unbind();

		SDL_GL_SwapWindow(window);

	}

}