class Thunder {

	PVector pos = new PVector(0, 0);
	PVector previousPos = new PVector(0, 0);


	PVector newPos( PVector previousPos, int y) {

		this.pos = previousPos;

		int x = (int) this.pos.x + (int) random(-4, 4);
		PVector newPos = new PVector( x, y );

		return newPos;
	}


}
