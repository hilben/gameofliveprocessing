// Game of Life implementation
// Benjamin Hiltpolt

int cols = 20;
int rows = 20;
int cell_size = 25;
int[][] grid; 
int[][] grid_updated; 

void setup() {
  size(cell_size * cols, cell_size * rows);
  frameRate(30);
  grid = new int[cols][rows];
  grid_updated = new int[cols][rows];

  for (int i = 0; i < cols; i ++ ) {
    for (int j = 0; j < rows; j ++ ) {
      grid[i][j] = 0;
      grid_updated[i][j] = 0;
    }
  }
}


void update_grid() {
  for (int i = 0; i < cols; i += 1 ) {
    for (int j = 0; j < rows; j += 1 ) {
      grid_updated[i][j] = lives(i, j);
    }
  }

  grid = grid_updated;
}

int lives(int i, int j) {
  //rule 4: Any dead cell with exactly three live neighbours becomes a live cell
  if (grid[i][j] == 0) {
    if (number_of_neighbours(i, j) == 3) {
      return 1;
    }
    return 0;
  }

  //rule 1: Any live cell with fewer than two live neighbours dies
  //rule 3: Any live cell with more than three live neighbours dies, as if by overcrowding. 
  if (number_of_neighbours(i, j) < 2 || number_of_neighbours(i, j) > 3) {
    return 0;
  }
  //rule 2: Any live cell with two or three live neighbours lives on to the next generation.
  if (number_of_neighbours(i, j) == 2 || number_of_neighbours(i, j) == 3) {
    return 1;
  }

  return -1;
}

int number_of_neighbours(int i, int j) {
  int counter = 0;

  i += cols;
  j += rows;

  counter += grid[(i-1) % cols][(j-1) % rows];
  counter += grid[(i+1) % cols][(j-1) % rows];
  counter += grid[(i-1) % cols][(j+1) % rows];
  counter += grid[(i+1) % cols][(j+1) % rows];

  counter += grid[(i) % cols][(j-1) % rows];
  counter += grid[(i) % cols][(j+1) % rows];
  counter += grid[(i-1) % cols][(j) % rows];
  counter += grid[(i+1) % cols][(j) % rows];


  return counter;
}

void draw() {
  background(0);
  for (int i = 0; i < cols; i ++ ) {     
    for (int j = 0; j < rows; j ++ ) {

      stroke(0);
      fill(256, 256, 256);
      if (grid[i][j] == 1) {
        fill(25);
      }

      rect(i*cell_size, j*cell_size, cell_size, cell_size);

      //Debugg to display number of neighbours and updated grid
     // debug(i, j);
    }
  }

  if (frameCount % 60 == 0) {  
    update_grid();
  }
}

void debug(int i, int j) {
  if (grid[i][j] == 1) {
    fill(256, 0, 0);
  } else {
    stroke(50);
    fill(0,0,0);
  }
  text("n:"+number_of_neighbours(i, j), i*cell_size, j*cell_size, cell_size, cell_size);

  stroke(0);
  fill(256, 0, 0, 100);
  if (grid_updated[i][j] == 1) {
    fill(0, 0, 256, 100);
  }

  rect(i*cell_size, j*cell_size, cell_size, cell_size);
}

void mousePressed() {
  grid[mouseX/cell_size][mouseY/cell_size] = 1;
}

