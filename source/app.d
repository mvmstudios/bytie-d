import bindbc.sdl;

void main() {
	// ERROR HANDLING
	loadSDL();

	SDL_Window* window = SDL_CreateWindow("Bytie-D", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 600, SDL_WINDOW_RESIZABLE);
}