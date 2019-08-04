int step = 2;
float border = 0.1;
int t = 0;

int mx = 0;
int my = 0;
int nx = 0;
int ny = 0;
float nh = 0.0;

ArrayList < PVector > points = new ArrayList < PVector > ();


void setup() {
  size(600, 600);

}

void draw() {

  if (t++ % 250 == 0) {

    background(255);
    noiseSeed((int) random(1000));

    float mh = 0.0;

    for (int i = 0; i < 1000; i++) {

      nx = (int) random(1000);
      ny = (int) random(1000);
      nh = noise(nx / 350, ny / 350);

      if (nh > mh) {
        mx = nx;
        my = ny;
        mh = nh;
      }
    }

    nx = mx;
    ny = my;
    nh = mh;

    for(int nc=0; nc < 30; nc++ ) {

      do {ny++;} while ( noise( nx/350, ny/350 ) > ( nh -0.01) );

			nh = noise( nx/350, ny/350 );
      points.add( new PVector( nx, ny) );
    }
    
    for( int p = points.size() -2; p>=0; p-=2 ) {
      drawPoints( points.get(p), points.get(p+1) );
    }
    println("loop");
  }

}

void drawPoints(PVector nx, PVector ny) {
  println("nx: " + nx + " ny: " + ny );
}