// start
GameState gs;
int i;
int GAME_ENDED = 0;
int GAME_START = 1;

void setup() {
    size(400, 800);
    
    gs = new GameState();
    println(gs.get_state());
    gs.start();
    println(gs.get_state());
    gs.end();
    println(gs.get_state());
    
}

class GameState {
    int state = 0;
    
    GameState() {
        state = GAME_ENDED;
    }
    
    voidstart() {
        state = GAME_START;
    }
    
    void end() {
        state = GAME_ENDED;
    }
    
    int get_state() {
        return state;
    }
}