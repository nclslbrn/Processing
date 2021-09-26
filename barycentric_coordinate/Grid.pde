class Grid {
 
  int cols = 1;
  int rows = 1;
  int cellWidth = 1;
  int cellMargin = 1;
  int outer_x_margin = 0;
  int outer_y_margin = 0;
  
  void init() {
  
    this.cols = floor( width / (cellWidth + cellMargin) );
    this.rows = floor( height / (cellWidth + cellMargin) );
  
    this.outer_x_margin = floor( ( width % ((cellMargin + cellWidth) * cols)) / 2 );
    this.outer_y_margin = floor( ( height % ((cellMargin + cellWidth) * rows)) / 2 );
    
  }
  
}
