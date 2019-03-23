import std.stdio;

import bindbc.sdl;
import bindbc.opengl;

import gl3n.math;
import gl3n.linalg;

import bytied.types.vertex;
import bytied.buffer.vertexbuffer;
import bytied.buffer.indexbuffer;
import bytied.shader.glshader;

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
	if (ret == GLSupport.noLibrary) {
		writeln("Error loading OpenGL no library!");
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
	GlShader shader = new GlShader("shader/test.vert", "shader/test.frag");
	shader.bind();


	//mat4 modelMatrix = mat4(1.0f);
	//modelMatrix.scale(1.2, 1.2, 1.2);

	//mat4 projectionMatrix = orthograpic(-4, 4, -3, 3, -10, 100);
	mat4 modelMatrix = mat4.identity.scale(1.2, 1.2, 1.2);

	//mat4 projectionMatrix = mat4.orthographic(-4.0f, 4.0f, -3.0f, 3.0f, -10.0f, 100.0f);
	//mt width, mt height, mt fov, mt near, mt far
	mat4 projectionMatrix = mat4.perspective(4, 3, 45.0, 0.1, 100);
	//mat4f.perspective(radians(45.0), 4/3, 0.1, 100);

	mat4 viewMatrix = mat4.identity.translate(vec3(0, 0, -5));

	mat4 modelViewProjectionMatrix = projectionMatrix * viewMatrix * modelMatrix;

	GLint modelViewProjectionMatrixUniformLocation 
		= glGetUniformLocation(shader.programPointer, "uniform_model_view_projection_matrix");

	ulong performanceCounterFrequency = SDL_GetPerformanceFrequency();
	ulong lastPerformanceFrequency = performanceCounterFrequency; 

	float deltaTime = 0.0;
	float globalTime = 0.0;

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

		globalTime += deltaTime;

		modelMatrix.rotate(1 * deltaTime, vec3(0, 1, 0));
		modelViewProjectionMatrix = projectionMatrix * viewMatrix * modelMatrix;

		vertexBuffer.bind();
		indexBuffer.bind();

		glUniformMatrix4fv(modelViewProjectionMatrixUniformLocation, 1, GL_FALSE,  modelViewProjectionMatrix.value_ptr);
		
		glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_INT, null);

		vertexBuffer.unbind();
		indexBuffer.unbind();

		SDL_GL_SwapWindow(window);

		long endPerformanceCount = SDL_GetPerformanceCounter();
		long timeElapsed = endPerformanceCount - lastPerformanceFrequency;

		deltaTime = (cast(float) timeElapsed) / cast(float) performanceCounterFrequency;
		uint framesPerSecond = cast(uint) (cast(float) performanceCounterFrequency / cast(float) timeElapsed);

		lastPerformanceFrequency = endPerformanceCount;
	}

}