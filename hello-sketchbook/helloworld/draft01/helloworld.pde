// Declare and construct two objects (h1, h2) from the class HLine 
int GAME_START = 0;
int GAME_ENDED = 1;

GameState gs = new GameState(GAME_ENDED); 

void setup() 
{
    size(400, 800);
    frameRate(30);
    
    println("start");
    println(gs.getState());
    gs.start_game();
    println(gs.getState());
    gs.reset_game();
    println(gs.getState());
    
}

void draw() { 
    
} 

class Puzzle {
    PImage[] pzzles;
    
    
}

class Display {
    
}

class GameState {
    //tiny state machine 
    int state;
    GameState(int init_state) {  
        state = init_state;
    }
    
    int getState() {
        return state;
    }
    
    void start_game() {
        state = GAME_START;
    }
    
    void reset_game() {
        state = GAME_ENDED;
    }
}