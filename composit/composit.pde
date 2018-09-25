PImage satelliteShot;
PVector satelliteShotAnchor;
int numParticle = 40;

void setup() {
  satelliteShot = loadImage("satellite-shots/ISS032-E-17497-hd.JPG"); //4256 × 2832
  size( 720, 960);
  imageMode(CENTER);
  satelliteShotAnchor = new PVector( width/3, height/2);
}

void draw() {
  satelliteShotAnchor.y += 0.5;
  image( satelliteShot, satelliteShotAnchor.x, satelliteShotAnchor.y);

  stroke( color( random(120, 255), random(120, 255), random(120, 255) ) );

  for( int p = 0; p < numParticle; p++ ) {

      point( random( 0, width), random(0, height) );

  }
}
