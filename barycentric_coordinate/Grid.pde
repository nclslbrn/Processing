class Grid {
 
  int cols = 1;
  int rows = 1;
  int cellWidth = 1;
  int cellPadding = 1;
  int outer_x_margin = 0;
  int outer_y_margin = 0;

  Grid(int cellWidth, int cellPadding) {
    this.cellPadding = cellPadding;
    this.cellWidth = cellWidth;

    this.cols = floor( width / this.cellWidth );
    this.rows = floor( height / this.cellWidth );
  
    this.outer_x_margin = int( ( width % (this.cellWidth * this.cols)) / 2 );
    this.outer_y_margin = int( ( height % (this.cellWidth * this.rows)) / 2 );
  }
}
