	

import java.util.Map;
int selected_color_id = 0;
int num_frame = 16;
int margin = 24;
int distanceMin = 120;
color[] selected_color;
color backgroundColor = color(240, 235, 230);
ArrayList<PVector> points = new ArrayList<PVector>();

/**
 * Chromotone by Kjetil Golid
 * @link https://github.com/kgolid/chromotome
 */
void get_selected_color() {

  if( selected_color_id == 0) {

    color[] ducci_x = {#dd614a, #f5cedb, #1a1e4f};
    selected_color = ducci_x;

  } else if(selected_color_id == 1) { 

    color[] tundra_two = {#5f9e93, #3d3638, #733632, #b66239, #b0a1a4, #e3dad2};
    selected_color = tundra_two;

  } else if(selected_color_id == 2) {

    color[] tundra_four = { #d53939, #b6754d, #a88d5f, #524643, #3c5a53, #7d8c7c, #dad6cd};
    selected_color = tundra_four;

  } else if(selected_color_id == 3) {

    color[] rag_misore = { #ec6c26, #613a53, #e8ac52, #639aa0 };
    selected_color = rag_misore;

  } else if(selected_color_id == 4) {

    color[] kov_one = {#d24c23, #7ba6bc, #f0c667, #ede2b3, #672b35, #142a36};
    selected_color =  kov_one;

  } else if(selected_color_id == 5) {

    color[] hermes = {#253852, #51222f, #b53435, #ecbb51};
    selected_color = hermes;
  }
}
int color_scheme_num = 5;

void setup() {
  size(800, 800);
  
  smooth(10);
  noStroke();
  init();

}


void draw() {

  if( frameCount % num_frame == 0 ) {
    updatePoint();
  }
  if( frameCount % num_frame == 1 ) {
    drawShape();
  }
  if( mousePressed == true ) {
    if (mouseButton == LEFT) {
      init();
    } else if( mouseButton == RIGHT ) {
      saveFrame( "records/frame-###.jpg" );
    }
  }
}



void init() {
  
  selected_color_id = int( random(1) * color_scheme_num );
  get_selected_color();

  if( points.size() > 0 ) {
    points.clear();
  }

  points.add( new PVector( margin, margin ));
  points.add( new PVector( width-margin, margin ));
  points.add( new PVector( width-margin, height-margin ));
  points.add( new PVector( margin, height-margin ));
  
  for( int p = 0; p <= 32; p++ ) {
    points.add( new PVector( random(margin, width-margin), random(margin, height-margin) ));
  }
  
}


void updatePoint() {
  float distanceMax = 0;
  int firstPoint = 0;
  int secondPoint = 0;

  for( int p = 0; p < points.size( )-2; p+=2 ) {
   
    float distance = PVector.dist( points.get(p), points.get(p+1) );

    if( distanceMax < distance ) {
      distanceMax = distance;
      firstPoint = p;
      secondPoint = p+1;
    }
    if( distanceMax < distanceMin ) {
      saveFrame( "records/frame-###.jpg" );
      println("new drawing");
      init();
    }
  }

  int oppositeSidePoint,
      oppositeNextPoint;

  boolean cutFront = firstPoint + 3 < points.size();

  if( cutFront ) {
    oppositeSidePoint = firstPoint + 2;
    oppositeNextPoint = oppositeSidePoint + 1;

  } else {

    oppositeSidePoint = firstPoint - 2;
    oppositeNextPoint = oppositeSidePoint - 1;
  }

  float randomLength = random(1);

  PVector randomNewPoint = PVector.lerp( points.get(firstPoint), points.get(secondPoint), 0.5);
  PVector oppositePoint = PVector.lerp( points.get(oppositeSidePoint), points.get(oppositeNextPoint), 0.5);
  
  points.set(firstPoint, randomNewPoint);
  points.set(oppositeSidePoint, oppositePoint);
  
}


void drawShape() {

  background(backgroundColor);

  int poly_id = 0;
  
  for( int p = 0; p < points.size()-4; p += 4 ) {

    int color_id = poly_id < selected_color.length ? poly_id : poly_id % selected_color.length;
    boolean isCurve = random(1) > 0.75;

    fill( selected_color[color_id] );

    beginShape();
    for( int _p = 0; _p <= 4; _p++ ) {

      if( isCurve ) {
        curveVertex(points.get(p + _p).x, points.get(p +_p).y);
      } else {
        vertex( points.get(p + _p).x, points.get(p + _p).y);
      }
    }
    endShape(CLOSE);
    poly_id++;
  }
}