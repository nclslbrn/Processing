class Point_in_triangle {

	int triangle[];
	PVector a, b, c;

	color col = color(0);

	void display( int[][] triangle, color col ) {

		this.a = new PVector( triangle[0][0], triangle[0][1] );
		this.b = new PVector( triangle[1][0], triangle[1][1] );
		this.c = new PVector( triangle[2][0], triangle[2][1] );

		this.col = col;

		PVector ab = new PVector( a.x - b.x, a.y - b.y );
		PVector ac = new PVector( a.x - c.x, a.y - c.y );

		int[] points_to_compare = {
			(int) ( b.x - a.x ),
			(int) ( a.x - b.x ),
			(int) ( c.x - a.x ),
			(int) ( a.x - c.x ),
			(int) ( b.x - c.x ),
			(int) ( c.x - a.x )
		};

		int point_by_frame = max( points_to_compare );

		stroke( this.col );

		for( int n = 0; n < point_by_frame; n++ ) {

			float r = random( -1, 0 );
			float s = random( -1, 0 );

			if( r + s >= -1 ) {

					point(
							( a.x + r * ab.x + s * ac.x ),
							( a.y + r * ab.y + s * ac.y )
					);
			}
		}

	}

}
