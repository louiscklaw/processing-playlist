// start
Board board;
int CELL_EMPTY = 0;
int CELL_OCCUPIED = 1;

void setup() {
  size(400, 800);
  
  board = new Board();
  board.init();

  println("test 1");
  println(board.get_cell_status(0,0));
  println(board.get_cell_status(1,0));
  println(board.get_cell_status(0,1));
  println(board.get_cell_status(1,1));

  println("test 2");
  board.set_cell_occupied(0,0);
  println(board.get_cell_status(0,0));
  println(board.get_cell_status(1,0));
  println(board.get_cell_status(0,1));
  println(board.get_cell_status(1,1));

  println("test 3");
  board.set_cell_occupied(0,1);
  println(board.get_cell_status(0,0));
  println(board.get_cell_status(1,0));
  println(board.get_cell_status(0,1));
  println(board.get_cell_status(1,1));

  println("helloworld");
  // equivalently asking cell 0,1 as below 0,2
  println(board.get_cell_below_status(0,2));
}

class Board {
  int state = 0;
  int board_cell[] = new int[16];

  Board(){}

  void init() {
    int i = 0;
    for(int y = 0; y < 4; y++){
      for(int x = 0; x < 4; x++){
        board_cell[i] = CELL_EMPTY;
        i = i + 1;
      }
    }
  }

  int get_cell_status(int x_wanted, int y_wanted){
    int i = 0;

    for(int y = 0; y < 4; y++){
      for(int x = 0; x < 4; x++){
        if (x == x_wanted){
          if (y == y_wanted){
            return board_cell[i];
          }
        }
        i = i + 1;
      }
    }
    return CELL_OCCUPIED;
  }

  int get_cell_below_status(int x_wanted, int y_wanted){
    return get_cell_status(x_wanted, y_wanted - 1);
  }

  void set_cell_occupied(int x_to_set, int y_to_set){
    int i = 0;

    for(int y = 0; y < 4; y++){
      for(int x = 0; x < 4; x++){
        if (x == x_to_set){
          if (y == y_to_set){
            board_cell[i] = CELL_OCCUPIED;
          }
        }
        
        i = i + 1;
      }
    }
  }

} 