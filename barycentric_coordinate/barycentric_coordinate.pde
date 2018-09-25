int numTrianglePerCircle = 20;
int[][][][][] triangles;
color[][][] trianglesColor;
Grid grid;
ArrayList<Point_in_triangle> points = new ArrayList<Point_in_triangle>();

void setup() {
   size(1280, 720);
	 frameRate(24);
	 smooth();
   init();
}

void init() {

	  grid = new Grid();
	  grid.cellWidth = 200;
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
						}
				}
		}
		println( triangles.length );

}

void draw() {

  pushMatrix();
  translate( grid.outer_x_margin + (grid.cellWidth/2) , grid.outer_y_margin + (grid.cellWidth/2) );


	int y = 0;

	for( int cols = 0; cols < triangles.length; cols++ ) {

			for( int rows = 0; rows < triangles[cols].length; rows++ ) {

					int _x = cols * grid.cellWidth;
					int _y = rows * grid.cellWidth;

					for( int t = 0; t < triangles[cols][rows].length; t++ ) {

							noStroke();
							fill( trianglesColor[cols][rows][t] );
							triangle(
								triangles[cols][rows][t][0][0],
								triangles[cols][rows][t][0][1],

								triangles[cols][rows][t][1][0],
								triangles[cols][rows][t][1][1],

								triangles[cols][rows][t][2][0],
								triangles[cols][rows][t][2][1]
							);
/*
							noFill();
							stroke(0);
							rect(
				        _x,
				        _y,
				        grid.cellWidth,
				        grid.cellWidth
						 );
*/
					}
			}
  }
  popMatrix();
//  noLoop();
}
