int shelves, stages, colorStep, maxRadius;
float radius, rotation, frameRadius;
int circleInSreen = 5;
int step = 36;
int ellipseSize = 4;
int numFrame = 50;
float gold = 1.618033;

void setup() {
  size(800, 800);
  frameRate(25);

  noFill();
  ellipseMode(CENTER);
  maxRadius = (int) sqrt( sq(width) + sq(height)) / 2;
  frameRadius = radius = width / 4;
  shelves = 7;
  stages = 0;
  colorStep = 255 / circleInSreen;

  println( frameRadius + " " + radius + " " +maxRadius );
}

void draw() {

  background(0);

  float animCursor = 1.0 * (frameCount%numFrame) / numFrame;
  
  float angle = (TWO_PI / shelves);
  float radiusStep = radius * animCursor;
  
  frameRadius = radius + radiusStep;
  
  for( int n = 0; n < circleInSreen; n++ ) {

    stroke(circleInSreen*colorStep);

    if( frameRadius >= maxRadius ) {
      println("maxRadius reached");
      frameRadius = radius;
    }
    for( int s = 0; s < shelves; s++ ) {

      float x = width/2 + frameRadius * cos(s*angle+rotation);
      float y = height/2 + frameRadius * sin(s*angle+rotation);

      int _s = s + 1;
      float _x = width/2 + frameRadius * cos(_s*angle+rotation);
      float _y = height/2 + frameRadius * sin(_s*angle+rotation);

      float nextRadius = (frameRadius+radiusStep);
      float n_x = width/2 + nextRadius * cos(_s*angle+rotation);
      float n_y = height/2 + nextRadius * sin(_s*angle+rotation);

      line(x, y, _x, _y);
      
      line(x, y, n_x, n_y);
      
      ellipse(x, y, ellipseSize, ellipseSize);

    }
    frameRadius = radius + (radiusStep * n );
  }
  
  rotation = angle * animCursor;
}
