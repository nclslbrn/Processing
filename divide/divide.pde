	

import java.util.Map;
int selected_color_id = 0;
int num_frame = 6;
int margin = 24;
int maxPoint = 360;
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

  //selected_color = ducci_x;  
}


void draw() {

  if( points.size() > maxPoint ) {
    saveFrame( "records/frame-###.jpg" );
    init();
  }
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
  
  selected_color_id = int( random(1) * color_scheme_num );
  get_selected_color();
  println("selected_color_id: "+selected_color_id);

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

  int randomNextPoint,
      oppositeSidePoint,
      oppositeNextPoint;

  boolean cutFront = randomPoint + 3 < points.size();

  if( cutFront ) {
    randomNextPoint = randomPoint + 1;
    oppositeSidePoint = randomPoint + 2;
    oppositeNextPoint = oppositeSidePoint + 1;

  } else {

    randomNextPoint = randomPoint - 1;
    oppositeSidePoint = randomPoint - 2;
    oppositeNextPoint = oppositeSidePoint - 1;
  }

  float randomLength = random(1);

  PVector randomNewPoint = PVector.lerp( points.get(randomPoint), points.get(randomNextPoint), 0.5);
  PVector oppositePoint = PVector.lerp( points.get(oppositeSidePoint), points.get(oppositeNextPoint), 0.5);
  
  points.add(randomPoint, randomNewPoint);
  points.add(oppositeSidePoint, oppositePoint);
  
/*
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

  points.add(randomPoint, newPoint);
  */
}


void drawShape() {

  background(backgroundColor);

  int poly_id = 0;

  for( int p = 0; p < points.size()-3; p += 3 ) {

    int color_id = poly_id < selected_color.length ? poly_id : poly_id % selected_color.length;

    fill( selected_color[color_id] );

    beginShape();
    for( int _p = 0; _p <= 3; _p++ ) {
      vertex( points.get(p + _p).x, points.get(p + _p).y);
    }
    endShape(CLOSE);
    poly_id++;
  }
}