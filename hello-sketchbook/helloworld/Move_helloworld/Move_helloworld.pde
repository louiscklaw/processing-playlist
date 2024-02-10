// start

void setup() {
    size(400, 800);
    // int[] pos = new int[]{0,0};
    // MovePuzzle mp = new MovePuzzle();
    // // 2,3
    // println(mp.move_left(3,3));
    
    // // 0,3
    // println(mp.move_left(0,3));
    
    // // 3,3 
    // println(mp.move_right(2,3));
    
    // // 3,3 
    // println(mp.move_right(3,3));
    
    // println("move down");
    // // 3,2
    // println(mp.move_down(3,3));
    
    // // 3,1
    // println(mp.move_down(3,2));
    
    // // 3,0
    // println(mp.move_down(3,1));
    
    // // 3,0
    // println(mp.move_down(3,0));
    
    // int[][] puzzle_pos_x_y = new int[16][2];
    // puzzle_pos_x_y[0] = new int[]{99,98};
    // println(puzzle_pos_x_y[0]);
    
    Puzzles puzzles = new Puzzles("./test_400_600.jpg");
    // puzzles.helloworld();
    PImage pimg_temp = puzzles.get_test();
    image(pimg_temp, 50, 50);
}

void draw() {
}

static class Helloworld {
    static void hello() {
        println("hello");
    }
}

class MovePuzzle {
    MovePuzzle() {}
    
    
    int[] move_left(int current_x, int current_y) {
        int[] temp = new int[]{0,current_y};
        if (current_x > 0) {
            temp[0] = current_x - 1;
        }
        return temp;
    }
    
    int[] move_right(int current_x, int current_y) {
        int[] temp = new int[]{0,current_y};
        if (current_x < 3) {
            temp[0] = current_x + 1;
        }
        return temp;
    }
    
    int[] move_down(int current_x, int current_y) {
        int[] temp = new int[]{current_x,current_y};
        // consider on the bottom
        if (current_y > 0) {
            temp[1] = current_y - 1;
        }
        return temp;
    }
    
}

class Puzzle {
    PImage p_img;
    
    int current_x;
    int current_y;
    
    Puzzle(PImage puzzle_img, int pos_x, int pos_y) {
        this.current_x = 99;
        this.current_y = 99;
        this.p_img = puzzle_img;
    }
    
    void move_left() {
        println("move left ??");
        int[] temp = new int[]{0,current_y};
        if (this.current_x > 0) {
            this.current_x = this.current_x - 1;
        }
    }
    
    void move_right() {
        int[] temp = new int[]{0,current_y};
        if (current_x < 3) {
            this.current_x = current_x + 1;
        }
    }
    
    void move_down() {
        int[] temp = new int[]{current_x,current_y};
        // consider on the bottom
        if (current_y > 0) {
            this.current_y = current_y - 1;
        }
    }
    
    int[] get_position() {
        int[] temp = new int[]{this.current_x, this.current_y};
        return temp;
    }
    
    PImage get_image() {
        return this.p_img;
    }
}

// change name to Game??
class Puzzles {
    PImage img;  // Declare a variable to store the image
    PImage[] puzzled_image = new PImage[16];
    int[] puzzle_state = new int[16];
    int[][] puzzle_pos_x_y = new int[16][2];
    
    int puzzle_idx = 0;
    int x_div = 400 / 4;
    int y_div = 600 / 4;
    
    Puzzle[] puzzle_array = new Puzzle[16];
    
    Puzzles(String jpg_file_path) {
        this.load_image(jpg_file_path);
        this.slice();
        
        puzzle_array[0] = new Puzzle(puzzled_image[0], 1, 1);
        puzzle_array[0].move_left();
        println(puzzle_array[0].get_position());
        
    }
    
    PImage get_test() {
        PImage p_temp;
        p_temp = puzzled_image[0];
        return p_temp;
    }
    
    void load_image(String jpg_file_path) {
        this.img = loadImage(jpg_file_path);
    }
    
    void slice() {
        int x_ruler[] = new int[]{0,x_div, 2 * x_div, 3 * x_div};
        int y_ruler[] = new int[]{0,y_div, 2 * y_div, 3 * y_div};
        
        for (int y = 0; y < 4; y++) {
            for (int x = 0; x < 4; x++)  {
                puzzled_image[puzzle_idx] = this.img.get(x_ruler[x], y_ruler[y], x_div, y_div);
                
                puzzle_idx = puzzle_idx + 1;
            }
        }
    }
    
    PImage get_image(int idx) {
        return puzzled_image[idx];
    }
    
    
    void helloworld() {
        println("helloworld");
    }
}
