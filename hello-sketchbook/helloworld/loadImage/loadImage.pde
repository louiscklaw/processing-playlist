PImage black_jpg;
PImage orange_jpg;
PImage masked_jpg;
PImage white_jpg;
PImage resulting_jpg;
int[] mask_store;

int brush_size = 10;

void setup() {
    size(720, 480);
    black_jpg = loadImage("720x480_black.jpg");
    white_jpg = loadImage("720x480_white.jpg");
    masked_jpg = loadImage("720x480_black.jpg");
    orange_jpg = loadImage("720x480_orange.jpg");
    resulting_jpg = loadImage("720x480_black.jpg");
    
    color c = black_jpg.get(100,100);
    println(c);
    
    mask_store = new int[345600];
    mouseX = -99;
    mouseY = -99;
}

void draw() {
    
    int i = 0;
    for (int x = 0;x < 720;x++) {
        for (int y = 0;y < 480;y++) {
            float dist_x = mouseX - x;
            float dist_y = mouseY - y;
            dist_x = abs(dist_x);
            dist_y = abs(dist_y);
            float dist_r = sqrt((dist_x * dist_x) + (dist_y * dist_y));
            if (dist_r < brush_size) {
                // black_jpg.set(x,y,#00FFFF);
                mask_store[i] = 1;
            } else{
            }
            i = i + 1;
        }
    }
    
    i = 0;
    for (int x = 0;x < 720;x++) {
        for (int y = 0;y < 480;y++) {
            color c;
            if (mask_store[i] == 1) {
                c = white_jpg.get(x, y);
            } else{
                c = black_jpg.get(x, y);
            }
            resulting_jpg.set(x,y, c);
            i = i + 1;
        }
    }
    
    
    // white_jpg.mask(black_jpg);
    image(resulting_jpg, 0, 0);
}


int keypressed = 0;
void keyPressed() {
    if (keypressed == 0) {
        if (keyCode == UP) {
            println("UP pressed");
            brush_size = brush_size + 2;
        } else if (keyCode ==  DOWN && brush_size > 10) {
            println("DOWN pressed");
            brush_size = brush_size - 2;
        } else if (keyCode ==  ENTER || keyCode ==  RETURN) {
            println("ENTER pressed");
            mouseX = -99;
            mouseY =-  99;
            
            for (int i = 0; i < mask_store.length; i++) {
                mask_store[i] = 0;
            }
        } else{
            println("unhandled");
        }
    }
    
    keypressed = 1;
}


void keyReleased() {
    keypressed = 0;
}



void mouseDragged() 
    {
    print(mouseX);
    print(",");
    print(mouseY);
    println("---");
}
