

int[][] getRandomPoints( int x, int y, int radius) {

    float last_angle = 0.0;
		int points[][];
    points = new int[3][3];

    for (int n_p = 0; n_p < 3; n_p++ ) {

        int angle = (int) ( last_angle + random(QUARTER_PI, TWO_PI) );

        points[n_p][0] = (int) (x + cos(angle) * radius );
				points[n_p][1] = (int) (y + sin(angle) * radius );
        points[n_p][2] = angle;
        
        last_angle = angle;
				//	println( "x: " + x + " y: "+ y );
				//	printArray(points[n_p]);
    }

    return points;
}
