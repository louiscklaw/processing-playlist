int key_pressed;
PImage img;
PImage small_img;

int canvas_width;
int canvas_height;
int puzzle_height;
int puzzle_width;
int pos_y ;
int start_pos_y;
// int canvas_bottom_y;

int[] puzzle_lanes_x;
int puzzle_current_lane;
int[] lane_puzzle_count;
int lane_bottom_y;
int puzzle_x;
int puzzle_y;

void setup() {
    size(800, 1000);
    canvas_height = 1000;
    canvas_width = 800;

    puzzle_lanes_x = new int[]{0,100,200,300};
    puzzle_current_lane = 0;
    lane_puzzle_count=new int[]{0,0,0,0};

    img = loadImage("./test_400_600.jpg");
    
    int temp_y = convert_to_canvas_y(700);
    puzzle_width =100;
    puzzle_height = 600/4;
    small_img = img.get(0 ,0 ,puzzle_width ,puzzle_height );

    key_pressed = 0;
    
    start_pos_y = 1000;
    puzzle_y = start_pos_y;
    puzzle_x = 0;
    // canvas_bottom_y = puzzle_height;

    frameRate(30);
}


void draw(){
    background(204);
    
    lane_bottom_y = 150 * (lane_puzzle_count[puzzle_current_lane]+1);

    if (puzzle_y > lane_bottom_y){
        puzzle_y =puzzle_y -1;
    }
    
    // when the puzzle touch bottom
    if (puzzle_y == lane_bottom_y) {
        lane_puzzle_count[puzzle_current_lane] = lane_puzzle_count[puzzle_current_lane] + 1;
        println(lane_puzzle_count);
    }

    int pos_y = convert_to_canvas_y(puzzle_y);
    int pos_x = puzzle_lanes_x[puzzle_current_lane];

    image(small_img, pos_x, pos_y);
}


int convert_to_canvas_y(int bottom_zero_coord){
    int temp;
    temp = canvas_height - bottom_zero_coord;
    return temp;
}



void keyPressed() {
    if (key_pressed == 0){

        if (key == 'j'){
            println("left pressed");
            if (puzzle_current_lane >0) {
                puzzle_current_lane = puzzle_current_lane - 1;
            }
       }

        if (key == 'k'){
            println("right pressed");
            if (puzzle_current_lane < 3) {
                puzzle_current_lane = puzzle_current_lane + 1;
                println(puzzle_current_lane);
            }
        }

        if (key == 'm'){
            println("down pressed");
        }

        key_pressed = 1;
    }
}

void keyReleased(){
    key_pressed = 0;
}
