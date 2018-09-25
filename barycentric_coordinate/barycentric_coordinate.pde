int numTrianglePerCircle = 7;
int[][][][][] triangles;
color[][][] trianglesColor;
Grid grid;
ArrayList<Point_in_triangle> points = new ArrayList<Point_in_triangle>();

void setup() {
   size(1280, 720);
	 frameRate(24);
	 smooth(30);
   init();
}

void init() {
    background(0);
	  grid = new Grid();
	  grid.cellWidth = (int) random(200, 500);
	  grid.init();

		triangles = new int[grid.cols][grid.rows][ numTrianglePerCircle ][3][3];
		trianglesColor = new color[grid.cols][grid.rows][ numTrianglePerCircle ];

	  for( int x = 0; x < grid.cols; x++ ) {

				for( int y = 0; y < grid.rows; y++) {

						int step = (int) random(60);
						int _x = x * grid.cellWidth;
						int _y = y * grid.cellWidth;

						for( int t = 0; t < numTrianglePerCircle; t++ ) {

								triangles[ x ][ y ][ t ] = getRandomPoints( _x, _y, grid.cellWidth/2 );
								trianglesColor[ x ][ y ][ t ] = randomColor();

                Point_in_triangle newPoint;
                newPoint = new Point_in_triangle(
                    getRandomPoints( _x, _y, grid.cellWidth/2 ),
                    randomColor()
                );
                points.add( newPoint );

						}
				}
		}

}

void draw() {

  pushMatrix();
  translate( grid.outer_x_margin + (grid.cellWidth/2) , grid.outer_y_margin + (grid.cellWidth/2) );
  for( int p = 0; p < points.size() - 1; p++) {

      Point_in_triangle point = points.get(p);
      point.display();

  }
  popMatrix();
//  noLoop();
}
