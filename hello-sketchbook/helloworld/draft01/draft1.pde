int key_pressed = 0;

int canvas_width;
int canvas_height;

// constants
int GAME_START = 0;
int GAME_ENDED = 1;

int PUZZLE_READY = 0;
int PUZZLE_FALLING = 1;
int PUZZLE_LANDED = 2;
int PUZZLE_IGNORE = 3;

int SHOW_PUZZLE = 0;
int HIDE_PUZZLE = 1;

int FALLING_SPEED = 10;

GameState gs;


void setup() 
{
    size(800, 900);
    canvas_width = 800;
    canvas_height = 900;

    frameRate(30);
    
    gs = new GameState(GAME_ENDED);    
    gs.start_game();
}

void draw() { 
    background(204);
    // gs.puzzles.puzzle_array[0].redraw();
    gs.puzzles.redraw();

} 


class GameState {
    Puzzles puzzles;
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
        this.puzzles = new Puzzles("./test_400_600.jpg");
    }
    
    void reset_game() {
        state = GAME_ENDED;
    }

    void redraw(){
        println("game state draw ?");
    }
}

int convert_to_canvas_y(int bottom_zero_coord){
    int temp;
    temp = canvas_height - bottom_zero_coord;
    return temp;
}

class Puzzle {
    PImage p_img;
    
    int current_x;
    int current_y;
    int current_lane;
    int pos_y; 
    int lane_puzzle_count;

    int state;
    int show;
    Puzzles parent_puzzles;
    
    Puzzle(Puzzles puzzles, PImage puzzle_img, int init_pos_x, int init_pos_y) {
        this.current_x = 99;
        this.current_y = 99;
        this.p_img = puzzle_img;
        this.current_lane = 1;
        this.state = PUZZLE_READY;
        this.pos_y = 0;
        this.lane_puzzle_count = 0;
        this.parent_puzzles = puzzles;
        this.show = HIDE_PUZZLE;
    }

    int get_puzzle_lane_bottom(int lane_puzzle_count){
        return canvas_height-(150 * (lane_puzzle_count + 1));
    }

    void update_lane_puzzle_count(int lane_puzzle_count){
        this.lane_puzzle_count = lane_puzzle_count;
    }

    void redraw(){
        if (this.state== PUZZLE_FALLING){
            this.show = SHOW_PUZZLE;

            if (this.pos_y < (get_puzzle_lane_bottom( this.parent_puzzles.lane_puzzle_count[this.current_lane] ))){
                this.pos_y = this.pos_y + FALLING_SPEED;
            }else{
                this.state = PUZZLE_LANDED;
            }
        }else if (this.state == PUZZLE_LANDED){
            // this.parent_puzzles.helloworld();
            this.parent_puzzles.puzzle_landed(this.current_lane);
            // this.parent_puzzles.inc_lane_puzzle_count(this.current_lane);
            this.state = PUZZLE_IGNORE;
        }
        else if (this.state == PUZZLE_IGNORE){
            // lock puzzle
            
        }else{
            // spare
            // println("bugs ?");
        }

        if (this.show == SHOW_PUZZLE){
            image(this.p_img, 100 * this.current_lane, this.pos_y);
        }
    }

    void helloworld(){
        // image(this.p_img,1,1);
        println("helloworld");
    }
    
}

class Puzzles {
    PImage img;  // Declare a variable to store the image
    PImage[] sliced_img = new PImage[16];
    
    Puzzle[] puzzle_array = new Puzzle[16];

    int[] puzzle_state = new int[16];
    int[][] puzzle_pos_x_y = new int[16][2];

    int puzzle_idx = 0;
    int x_div = 400 / 4;
    int y_div = 600 / 4;
    int lane_puzzle_count[] = new int[]{0,0,0,0};
    int current_puzzle = 0;

    IntList fallen_puzzles;
    
    void load_image(String jpg_file_path) {
        this.img = loadImage(jpg_file_path);
        this.slice();
    }
    
    void slice() {
        puzzle_idx = 0;
        int puzzle_order[] = new int[]{12,13,14,15,8,9,10,11,4,5,6,7,0,1,2,3};
        int i = 0;

        int x_ruler[] = new int[]{0,x_div, 2 * x_div, 3 * x_div};
        int y_ruler[] = new int[]{0,y_div, 2 * y_div, 3 * y_div};
        
        for (int y = 0; y < 4; y++) {
            for (int x = 0; x < 4; x++)  {
                puzzle_idx = puzzle_order[i];
                println(puzzle_idx);
                i = i + 1;

                this.sliced_img[puzzle_idx] = this.img.get(x_ruler[x], y_ruler[y], x_div, y_div);
                puzzle_idx = puzzle_idx + 1;
            }
        }
    }
    
    Puzzles(String jpg_file_path) {
        this.load_image(jpg_file_path);
        this.slice();
        for (int i = 0; i<16;i++){
            this.puzzle_array[i] = new Puzzle(this, sliced_img[i], 1, 1);
        }
        this.current_puzzle = 0;

        this.fallen_puzzles = new IntList();

    }


    void move_left(){
        if (this.get_active_puzzle().state == PUZZLE_FALLING){
            if (this.get_active_puzzle().current_lane > 0) {
                this.get_active_puzzle().current_lane = this.get_active_puzzle().current_lane - 1;
                this.get_active_puzzle().update_lane_puzzle_count(1);
            }
        }else{
            println("move ignored");
        }
    }

    void move_right(){
        if (this.get_active_puzzle().state == PUZZLE_FALLING ){
            if (this.get_active_puzzle().current_lane < 3) {
                this.get_active_puzzle().current_lane = this.get_active_puzzle().current_lane + 1;
                this.get_active_puzzle().update_lane_puzzle_count(1);
            }
        }else{
            println("move ignored");
        }
    }

    void fall_next_puzzle(){
        println(this.current_puzzle);
        println(puzzle_array.length);
        if (this.current_puzzle < (puzzle_array.length -1)) {
            this.current_puzzle = this.current_puzzle + 1;
            println(this.current_puzzle);
            gs.puzzles.get_active_puzzle().state = PUZZLE_FALLING;  
        }else{
            println("all puzzle fallen");
        }
        
    }

    void inc_lane_puzzle_count(int lane){
        this.lane_puzzle_count[lane] = this.lane_puzzle_count[lane] +1;
    }

    void puzzle_landed(int lane){
        this.inc_lane_puzzle_count(lane);
        this.fallen_puzzles.append(this.current_puzzle);

        println("puzzle landed");

        if (current_puzzle < 16){
            gs.puzzles.fall_next_puzzle();
        }else{
            println("puzzle falled");
        }
    }

    Puzzle get_active_puzzle(){
        return this.puzzle_array[this.current_puzzle];
    }

    void redraw(){
        for(int i=0; i<this.fallen_puzzles.size();i++){
            this.puzzle_array[this.fallen_puzzles.get(i)].redraw();    
        }
        this.puzzle_array[this.current_puzzle].redraw();
    }

    void helloworld(){
        println("puzzles hellworold");
    }
}

class Display {
}

void keyPressed() {
    if (key_pressed == 0){

        if (key == 'j'){
            gs.puzzles.move_left();
        }

        if (key == 'k'){
            gs.puzzles.move_right();
        }

        if (key == 'm'){
            println("down pressed");
        }

        if (key == 'd'){
          gs.puzzles.get_active_puzzle().state = PUZZLE_FALLING;  
        }

        if (key == 'n'){
        }
        key_pressed = 1;
    }
}

void keyReleased(){
    key_pressed = 0;
}
