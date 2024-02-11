int key_pressed = 0;

int canvas_width;
int canvas_height;

// constants
int GAME_START = 0;
int GAME_ENDED = 1;
int GAME_SHOW_RESULT = 2;

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
    // gs.init_game();
}

void draw() { 
    background(204);
    // gs.puzzles.puzzle_array[0].redraw();
    gs.redraw();

} 

void DrawMarks(int marks){
    String str_marks = str(marks);
    textSize(64);

    text("marks:", 450, 280); 
    fill(0, 0, 0);
    text(str_marks, 450, 350); 
    fill(0, 0, 0);

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
        this.puzzles = new Puzzles(this, "./test_400_600.jpg");
        this.state = GAME_START;
        this.puzzles.fall_init_puzzle();
    }
    
    void reset_game() {
        this.state = GAME_ENDED;
    }

    void end_game(){
        this.state = GAME_ENDED;
        println("game ended");
    }

    void show_result(){
        this.state = GAME_SHOW_RESULT;
        print("game show result");

    }

    void redraw(){

        if (this.state== GAME_START || this.state == GAME_SHOW_RESULT){
            this.puzzles.redraw();
        }else if (this.state == GAME_ENDED){
            DrawPressToStart();
        }else{
        }

        if (this.state == GAME_SHOW_RESULT){
            DrawGameEnded();
        }

        DrawMarks(100);
    }
}


void DrawPressToStart(){
    textSize(32);

    text("press \"s\" to start", 450, 480); 
    fill(0, 0, 0);
}

void DrawGameEnded(){
    textSize(32);

    text("Game ended", 450, 480); 
    text("press \"s\" to restart", 450, 510); 
    fill(0, 0, 0);
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
    int[] puzzle_order = new int[]{12,13,14,15,8,9,10,11,4,5,6,7,0,1,2,3};

    // ArrayList<Puzzle> shuffled_puzzle_array = new ArrayList<Puzzle>();
    IntList temp_to_shuffle = new IntList();
    int[] shuffled_puzzle_order = new int[16];

    int[] puzzle_state = new int[16];
    int[][] puzzle_pos_x_y = new int[16][2];

    int puzzle_idx = 0;
    int x_div = 400 / 4;
    int y_div = 600 / 4;
    int lane_puzzle_count[] = new int[]{0,0,0,0};

    // idx of falling puzzle
    int current_puzzle = 0;
    int landed_puzzle = 0;

    // number of fallen_puzzle;
    int fallen_puzzle = 0;

    GameState parent_gs;

    IntList fallen_puzzles;
    
    void load_image(String jpg_file_path) {
        this.img = loadImage(jpg_file_path);
        this.slice();
    }
    
    void slice() {
        puzzle_idx = 0;
        int i = 0;

        int x_ruler[] = new int[]{0,x_div, 2 * x_div, 3 * x_div};
        int y_ruler[] = new int[]{0,y_div, 2 * y_div, 3 * y_div};
        
        for (int y = 0; y < 4; y++) {
            for (int x = 0; x < 4; x++)  {
                puzzle_idx = puzzle_order[i];
                i = i + 1;
                this.sliced_img[puzzle_idx] = this.img.get(x_ruler[x], y_ruler[y], x_div, y_div);
            }
        }
    }
    
    Puzzles(GameState parent_gs, String jpg_file_path) {
        this.parent_gs = parent_gs;

        this.load_image(jpg_file_path);
        this.slice();
        for (int i = 0; i<16;i++){
            // puzzle with the correct slice order
            this.puzzle_array[i] = new Puzzle(this, sliced_img[i], 1, 1);
        }

        for (int i = 0; i<16;i=i+4){
            temp_to_shuffle = new IntList();
            temp_to_shuffle.append(i+0);
            temp_to_shuffle.append(i+1);
            temp_to_shuffle.append(i+2);
            temp_to_shuffle.append(i+3);

            temp_to_shuffle.shuffle();

            this.shuffled_puzzle_order[i+0] = temp_to_shuffle.get(0);
            this.shuffled_puzzle_order[i+1] = temp_to_shuffle.get(1);
            this.shuffled_puzzle_order[i+2] = temp_to_shuffle.get(2);
            this.shuffled_puzzle_order[i+3] = temp_to_shuffle.get(3);
        }

        this.fallen_puzzles = new IntList();
        this.current_puzzle = 0;
        this.fallen_puzzle = 0;
        this.landed_puzzle = 0;
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

    void fall_init_puzzle(){
        // current_puzzle is a [0..16] look up from shuffled_puzzle_order
        this.current_puzzle = 0;
        this.get_active_puzzle().state = PUZZLE_FALLING;
    }

    void fall_next_puzzle(){
        print("fall_next_puzzle");

        if (this.fallen_puzzle < (puzzle_array.length -1)) {
            this.current_puzzle = this.current_puzzle + 1;
            this.fallen_puzzle = this.fallen_puzzle + 1;
            gs.puzzles.get_active_puzzle().state = PUZZLE_FALLING;  
        }else{
            println("all puzzle fallen");
        }
        
    }

    void inc_lane_puzzle_count(int lane){
        this.lane_puzzle_count[lane] = this.lane_puzzle_count[lane] +1;
    }

    void puzzle_landed(int lane){
        // current_puzzle means landing puzzle here
        this.inc_lane_puzzle_count(lane);
        this.fallen_puzzles.append(this.current_puzzle);
            
        // fallback to 16
        
        if (this.fallen_puzzles.size() < 3){
        // if (this.fallen_puzzles.size() < this.puzzle_array.length){
            gs.puzzles.fall_next_puzzle();

        }else{
            println("all puzzle falled");
            this.parent_gs.show_result();
        }
    }

    Puzzle get_active_puzzle(){
        return this.puzzle_array[this.current_puzzle];
    }

    void redraw(){

        for(int i=0; i<this.fallen_puzzles.size();i++){
            this.puzzle_array[this.fallen_puzzles.get(i)].redraw();    
        }
        this.get_active_puzzle().redraw();

    }

    void helloworld(){
        println("puzzles hellworold");
    }
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
        }

        if (key == 's'){
          gs.start_game();
        }

        if (key == 'r'){
          println("press r to restart");
          gs.reset_game();
        }

        if (key == 'n'){
        }
        key_pressed = 1;
    }
}

void keyReleased(){
    key_pressed = 0;
}
