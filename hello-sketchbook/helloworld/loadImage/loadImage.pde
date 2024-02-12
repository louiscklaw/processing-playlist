PImage black_jpg;
PImage orange_jpg;
PImage masked_jpg;
PImage white_jpg;
PImage resulting_jpg;
int[] mask_store;

void setup() {
    size(720, 480);
    black_jpg = loadImage("720x480_black.jpg");
    white_jpg = loadImage("720x480_white.jpg");
    masked_jpg = loadImage("720x480_black.jpg");
    orange_jpg = loadImage("720x480_orange.jpg");
    
    mask_store = new int[345600];
    
    // white_jpg.loadPixels();
    // black_jpg.loadPixels();
    // masked_jpg.loadPixels();
    // orange_jpg.loadPixels();
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
            if (dist_r < 10) {
                black_jpg.set(x,y,#00FFFF);
            }
            i = i + 1;
        }
    }
    
    white_jpg.mask(black_jpg);
    image(white_jpg, 0, 0);
}


void keyPressed() {
    if (keyCode == UP)
        {
        println("UP pressed");
    } else if (keyCode ==  DOWN) {
        println("DOWN pressed");
    } else if (keyCode ==  ENTER || keyCode ==  RETURN) {
        println("ENTER pressed");
        
    } else{
        println("unhandled");
    }
}


void keyReleased() {
}



void mouseDragged() 
    {
    print(mouseX);
    print(",");
    print(mouseY);
    println("---");
}
