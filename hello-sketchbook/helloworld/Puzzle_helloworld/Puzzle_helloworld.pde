// start
Puzzle puzzle;
int i;

void setup() {
    size(400, 800);
    
    puzzle = new Puzzle();
    puzzle.load_image();
    puzzle.slice();
    
    // temp_img= puzzle.get_image(0);
    frameRate(10);
}

void draw() {
    PImage temp_img;
    
    temp_img = puzzle.get_image(i);
    image(temp_img, 50, 50);
    
    i = i + 1;
    
    if (i > 15) {
        i = 0;
    }
}

class Puzzle {
    PImage img;  // Declare a variable to store the image
    PImage[] puzzled_image = new PImage[16];
    
    int puzzle_idx = 0;
    int x_div = 400 / 4;
    int y_div = 600 / 4;
    
    Puzzle() {}
    
    void load_image() {
        img = loadImage("./test_400_600.jpg");
    }
    
    void slice() {
        int x_ruler[] = new int[]{0,x_div, 2 * x_div, 3 * x_div};
        int y_ruler[] = new int[]{0,y_div, 2 * y_div, 3 * y_div};
        
        for (int y = 0; y < 4; y++) {
            for (int x = 0; x < 4; x++)  {
                puzzled_image[puzzle_idx] = img.get(x_ruler[x], y_ruler[y], x_div, y_div);
                
                puzzle_idx = puzzle_idx + 1;
            }
        }
    }
    
    PImage get_image(int idx) {
        return puzzled_image[idx];
    }
    
    
}