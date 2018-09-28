int thunderBranchAtStart, thunderXPos;
ArrayList<Thunder> thunder = new ArrayList<Thunder>();
ArrayList<Thunder> branches = new ArrayList<Thunder>();
int newBranchProbability = 1; //per ten

void setup() {
  size( 960, 540);
	init();
}


void init() {
		thunder.clear();
		branches.clear();
		thunderBranchAtStart = (int) random( 1, 5);

		for( int t = 0; t < thunderBranchAtStart; t++ ) {

				int x = (int) random( 0, width );

				Thunder branch = new Thunder();
				branch.previousPos =  new PVector(x, 0 );
				branch.pos = new PVector(x, 0 );

				thunder.add( branch );
		}
		drawThunder();
}
void draw() {

}


void drawThunder() {
	background(0);
	stroke( 255 );

	for( int t = 0; t < thunder.size(); t++ ) {

			Thunder currentBranch = thunder.get(t);
			PVector tempPos = currentBranch.pos;
			point( tempPos.x, tempPos.y );

			for( int y = 0; y < height; y++ ) {

					boolean isSplitting = newBranchProbability > random(10) * 10 - 1;

					if( isSplitting ) {

							Thunder newBranch = new Thunder();
							newBranch.previousPos =  tempPos;
							newBranch.pos = tempPos;
							branches.add( newBranch );
					}
					PVector newPos = currentBranch.newPos( tempPos, y );
					tempPos = newPos;
					point( newPos.x, newPos.y );

			}
			currentBranch.pos = tempPos;
	}
	for( int n = 0; n < branches.size(); n++ ) {

			Thunder currentBranch = branches.get(n);
			PVector tempPos = currentBranch.pos;
			point( tempPos.x, tempPos.y );

			for( int y = (int) tempPos.y; y < height; y++ ) {

					PVector newPos = currentBranch.newPos( tempPos, y );
					tempPos = newPos;
					point( newPos.x, newPos.y );

			}
			currentBranch.pos = tempPos;

	}

	//noLoop();
}

void mousePressed() {
	init();
}
