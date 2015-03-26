// Game of Life implementation
// Benjamin Hiltpolt

int cols = 30;
int rows = 30;
int cell_size = 15;
int speed = 2;
int frames = 30;
int[][] grid; 
int[][] grid_updated; 
int[][] grid_used;

boolean run = false;
boolean debug = false;

void setup() {
  size(cell_size * cols, cell_size * (rows+1));
  frameRate(frames);
  grid = new int[cols][rows];
  grid_updated = new int[cols][rows];

  initGrid();
}

void initGrid() {
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

  if (run) {
    for (int i = 0; i < cols; i++) {
      arrayCopy(grid_updated[i], grid[i]);
    }
  }
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
  if (mousePressed) {
    grid[mouseX/cell_size][mouseY/cell_size] = 1;
  }

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
      if (debug) {
        debug(i, j);
      }

      drawInfo();
    }
  }

  if (frameCount % speed == 0) {  
    update_grid();
  }
}

void drawInfo() {
  fill(256, 0, 0);
  if (run) {
    text("running: " + run + " Click to draw. Press s to stop. Press x to clear all. Press g to create a glider.", cell_size, rows*cell_size, cell_size*rows, cell_size);
  } else {
    text("running: " + run + " Click to draw. Press a to run. Press x to clear all. Press g to create a glider.", cell_size, rows*cell_size, cell_size*rows, cell_size);
  }
}

void debug(int i, int j) {
  if (grid[i][j] == 1) {
    fill(256, 0, 0);
  } else {
    stroke(50);
    fill(0, 0, 0);
  }
  text("n:"+number_of_neighbours(i, j), i*cell_size, j*cell_size, cell_size, cell_size);

  stroke(0);
  fill(256, 0, 0, 100);
  if (grid_updated[i][j] == 1) {
    fill(0, 0, 256, 100);
  }

  rect(i*cell_size, j*cell_size, cell_size, cell_size);
}


void keyPressed() {
  if (key == 'a') {
    run = true;
  } 
  if (key == 's') {
    run = false;
  }
  if (key == 'p') {
    debug = true;
  }
  if (key == 'P') {
    debug = false;
  }
  if (key == 'x') {
    initGrid();
  }
  if (key == 'g') {
    createGlider();
  }
}

void createGlider() {
  initGrid();
  grid[5][5] = 1;
  grid[6][5] = 1;
  grid[7][5] = 1;
  grid[7][4] = 1;
  grid[6][3] = 1;
}

