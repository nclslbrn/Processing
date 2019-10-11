int num_frame = 6;
int margin = 24;
color[] selected_color;
color backgroundColor = color(240, 235, 230);
ArrayList<PVector> points = new ArrayList<PVector>();

/**
 * Chromotone by Kjetil Golid
 * @link https://github.com/kgolid/chromotome
 */

color[] ducci_x = {#dd614a, #f5cedb, #1a1e4f};
color[] tundra_two = {#5f9e93, #3d3638, #733632, #b66239, #b0a1a4, #e3dad2};
color[] tundra_four = { #d53939, #b6754d, #a88d5f, #524643, #3c5a53, #7d8c7c, #dad6cd};

void setup() {
  size(800, 800);
  smooth(10);
  stroke(backgroundColor);
  init();

  selected_color = tundra_four;  
}


void draw() {

  if( frameCount % num_frame == 0 ) {
    updatePoint();
  }
  if( mousePressed == true ) {
    if (mouseButton == LEFT) {
      init();
    } else if( mouseButton == RIGHT ) {
      saveFrame( "records/frame-###.jpg" ); 
    }
  }
  drawShape();
}



void init() {

  if( points.size() > 0 ) {
    points.clear();
  }

  points.add( new PVector( margin, margin ));
  points.add( new PVector( width-margin, margin ));
  points.add( new PVector( width-margin, height-margin ));
  points.add( new PVector( margin, height-margin ));
  
  for( int p = 0; p <= 64; p++ ) {
    points.add( new PVector( random(margin, width-margin), random(margin, height-margin) ));
  }
  
}


void updatePoint() {

  int randomPoint = int( random(0, points.size() ) );
  int closestPoint = randomPoint;
  float minDistance = width;

  for( int p = 0; p < points.size(); p++ ) {

    if( p != randomPoint ) {
      
      float distance = PVector.dist( points.get(randomPoint), points.get(p) );

      if( minDistance > distance ) {
        minDistance = distance;
        closestPoint = p;
      }
    }
  }

  PVector newPoint = PVector.lerp( points.get(closestPoint), points.get(randomPoint), 0.75 );

  points.set(randomPoint, newPoint);
}


void drawShape() {

  background(backgroundColor);
  
  for( int p = 0; p < points.size()-4; p += 4 ) {

    int color_id = p < selected_color.length ? p : p % selected_color.length;
    fill( selected_color[color_id] );

    strokeWeight(p / margin);
    beginShape();
    for( int _p = 0; _p < 4; _p++ ) {
      vertex( points.get(p + _p).x, points.get(p + _p).y);
    }
    endShape(CLOSE);

  }
}