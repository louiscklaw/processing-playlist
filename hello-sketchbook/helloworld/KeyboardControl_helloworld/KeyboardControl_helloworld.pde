int key_pressed;

void setup() {
    size(100, 100);
    key_pressed = 0;
    
    frameRate(30);
}
  
void draw() {
    background(204);
}
  
void keyPressed() {
    if (key_pressed == 0){

        if (key == 'j'){
            println("left pressed");
       }

        if (key == 'k'){
            println("right pressed");
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