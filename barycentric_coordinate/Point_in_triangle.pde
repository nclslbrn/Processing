class Point_in_triangle {

	int[][] triangle;
	color col = color(0);
	int alpha = 0;
	PVector a, b, c = new PVector();

	Point_in_triangle( int[][] triangle, color col, int alpha ) {

			PVector a, b, c = new PVector();

			this.triangle = triangle;
			this.col = col;
			this.alpha = alpha;
	}

	void display(PGraphics canvas) {

			this.a = new PVector( this.triangle[0][0], this.triangle[0][1] );
			this.b = new PVector( this.triangle[1][0], this.triangle[1][1] );
			this.c = new PVector( this.triangle[2][0], this.triangle[2][1] );

			this.col = color( red( this.col ), green( this.col ), blue( this.col ), this.alpha );

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
      
			canvas.stroke( this.col );

			for( int n = 0; n < point_by_frame; n++ ) {
				PVector p = new PVector(random(n), random(n));
				float r = -1 * noise(p.x);
				float s = -1 * noise(p.y);
				//float r = random( -1, 0 );
				//float s = random( -1, 0 );

				if( r + s >= -1 ) {

					canvas.point(
						( a.x + r * ab.x + s * ac.x ),
						( a.y + r * ab.y + s * ac.y )
					);
				}
			}

		}

}
