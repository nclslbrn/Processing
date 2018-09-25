int triangleWidth;
Grid grid;

void setup() {
   size(800, 800);
   noStroke();
   init();
}

void init() {
  
  grid = new Grid();
  grid.cellWidth = floor( random(150, 200) );
  grid.init();
  
}

void draw() {
  pushMatrix();
  translate( grid.outer_x_margin, grid.outer_y_margin );
  
  for( int x = 0; x < grid.cols; x++ ) {
     for( int y = 0; y < grid.rows; y++) {
         
       fill( randomColor() );
       rect( 
         x * grid.cellWidth,
         y * grid.cellWidth,
         grid.cellWidth,
         grid.cellWidth
       );
     }
  }
  popMatrix();
  //noLoop();
}
