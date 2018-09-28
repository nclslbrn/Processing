int thunderBranchAtStart;
ArrayList<Thunder> thunder = new ArrayList<Thunder>();
ArrayList<Thunder> branches = new ArrayList<Thunder>();
int newBranchProbability = 1; //per ten

color[] skyColor = { color( 73, 51, 84 ), color( 59, 54, 110 ) };


void setup() {
	  size( 1280, 720);
		//fullScreen();
		smooth();
		frameRate(25);
		init();
		drawThunder();

}
void sky() {

		for( int y = 0; y < height; y++) {

				float colorScale = map( y, 0, height, 0.1, 0.9);
				color lineColor = lerpColor( skyColor[0], skyColor[1],colorScale );

				stroke( lineColor );
				line( 0, y, width, y );

		}
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
}


void draw() {

	int randomFrameStep = (int) random( 12, 24 );

	if( frameCount % 12 == 0 ) {

		background(15);
	}


	if( frameCount % randomFrameStep == 0 ) {
			sky();
			init();
			drawThunder();
	}
}


void drawThunder() {

		stroke( 255 );

		for( int t = 0; t < thunder.size(); t++ ) {

				Thunder currentBranch = thunder.get(t);
				PVector tempPos = currentBranch.pos;

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


				}
				currentBranch.pos = tempPos;
		}
		for( int n = 0; n < branches.size(); n++ ) {

				Thunder currentBranch = branches.get(n);
				PVector tempPos = currentBranch.pos;

				for( int y = (int) tempPos.y; y < height; y++ ) {

						PVector newPos = currentBranch.newPos( tempPos, y );
						tempPos = newPos;

				}
				currentBranch.pos = tempPos;

		}

		//noLoop();
}

void mousePressed() {
	init();
}
