int numTrianglePerCircle = 7;
int drawStartTime = 0;
int drawDuration = 15000;
Grid grid;
ArrayList<Point_in_triangle> points = new ArrayList<Point_in_triangle>();

void setup() {
   size(800, 800);
	 frameRate(24);
	 smooth(30);
   init();
}

void init() {

    background(0);
	  grid = new Grid();
	  grid.cellWidth = (int) random(200, 500);
	  grid.init();

	  for( int x = 0; x < grid.cols; x++ ) {

				for( int y = 0; y < grid.rows; y++) {

						int _x = x * grid.cellWidth;
						int _y = y * grid.cellWidth;

						for( int t = 0; t < numTrianglePerCircle; t++ ) {

                Point_in_triangle newPoint;
                newPoint = new Point_in_triangle(
                    getRandomPoints( _x, _y, grid.cellWidth/2 ),
                    randomColor()
                );
                points.add( newPoint );

						}
				}
		}
    drawStartTime = millis();
}

void draw() {

  pushMatrix();
  translate( grid.outer_x_margin + (grid.cellWidth/2) , grid.outer_y_margin + (grid.cellWidth/2) );
  for( int p = 0; p < points.size() - 1; p++) {

      Point_in_triangle point = points.get(p);
      point.display();

  }
  popMatrix();

  if( millis() > drawStartTime + drawDuration ) {
      init();
  }
}
