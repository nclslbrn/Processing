class Thunder {

	PVector pos = new PVector(0, 0);
	PVector previousPos = new PVector(0, 0);
	int minDisplace = 5;
	int maxDisplace = 52;

	PVector newPos( PVector previousPos, int y) {

		stroke( 255 );
		this.pos = previousPos;
		int displaceScale = (((maxDisplace-minDisplace) * (y / height)) / height) + minDisplace ;
		int displace = (int) ((random(0, 1)* 2 -1) * displaceScale);

		if( displace > 0 ) {
			for( int d = 0; d < displace; d++ ) {

				point( (previousPos.x + d), y);
			}
		}
		if( displace < 0 ) {
			for( int d = 0; d > displace; d-- ){

				point( (previousPos.x + d), y );

			}
		}
		if( displace == 0 ) {
				point( previousPos.x, y );
		}


		int x = (int) this.pos.x + displace;

		PVector newPos = new PVector( x, y );

		return newPos;
	}


}
