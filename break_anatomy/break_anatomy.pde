/**
 * Based on Voronoi clipping (exemple of Toxiclibs library)
 * @link http://toxiclibs.org/
 */
import toxi.geom.*;
import toxi.geom.mesh2d.*;
import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.processing.*;
//color[] ducci_x = {#dd614a, #f5cedb, #1a1e4f};
//color[] urban_scheme = {#A9C2C2, #1D1A11, #82B1B9, #A39A88, #2C3D25, #D53F18, #D7D8D0, #1F5D52, #738480, #596242,#48453D, #24A8BA};
int poly_num_limit = 164;
int minCircumference = 364;
float t;

ToxiclibsSupport gfx;
Voronoi voronoi;

boolean isVideoRecording = true;
boolean isRecording = false; 

PGraphics record;
int num_frame = 2;
int noise_loop_frame = 64;
int noiseRadius = 32;
int noiseStrength = 8;

float getNoiseIntensity(float x, float y, float t ) {
  
  return noise(
    noiseRadius * cos( TWO_PI * t),
    noiseRadius * sin( TWO_PI * t)
  ) * noiseStrength;
}


void setup() {

  size(1080, 1080);
  if( isVideoRecording ) {
    num_frame = 1;
  }
  voronoi = new Voronoi( width*4 );
  gfx = new ToxiclibsSupport(this, record = createGraphics(width, height));
  record.smooth(20);
  strokeWeight(0.25);
  
}
void draw() {

  int poly_id = 0;
  float t = 1.0 * frameCount / noise_loop_frame;

  record.beginDraw();
  record.background(255);
  record.stroke(0);


  for (Polygon2D poly : voronoi.getRegions()) {
    ArrayList <PVector> points = new ArrayList<PVector>(); 
    
    float circumference = poly.getCircumference();

    for (int p = 0; p < poly.vertices.size(); p++) {

      Vec2D v = poly.vertices.get(p);
      points.add( new PVector( v.x, v.y ) );
    
      drawPoly( points, circumference );

    }
    if( poly_id > poly_num_limit ) {

      isRecording = true;
    } else {
      poly_id++;

    }
    
  }
  
  record.endDraw();

  image(record, 0, 0);


  if( isRecording ) {
    
    if( ! isVideoRecording ) {
      record.save( "records/frame-"+ frameCount +".jpg" );
    }

    isRecording = false;
    voronoi = new Voronoi( width*4 );
  
  } else if( frameCount % num_frame == 0 ) {
    
    if( isVideoRecording ) {
       record.save( "records/video/frame-"+ frameCount +".jpg" );
    }

    float x = width/2 + random(-0.4, 0.4) * width;
    float y = height/2 + random(-0.4, 0.4) * width;
    voronoi.addPoint( new Vec2D( x, y ));
  }
}

void drawPoly( ArrayList <PVector> points, float circumference ) {

  boolean isRounded = false;

  if( circumference <= minCircumference ) { 

    record.fill( 0 );
    isRounded = true;

  } else {

    record.fill( 255 );
  
  }


  record.beginShape();
  
  for( int p = 0; p < points.size(); p++ ) {

    PVector point = points.get(p);

    if( isRounded && p != points.size()-1) { // && p != 0 ) {
      //record.curveVertex(point.x, point.y );
      for(float dis = 0; dis <= 1; dis += 0.05 ) {
        
          PVector newPoint = PVector.lerp( point, points.get(p+1), dis );
          float pointNoise = getNoiseIntensity( newPoint.x, newPoint.y, t);

          record.curveVertex( 
            newPoint.x + noiseRadius * cos( pointNoise ),
            newPoint.y + noiseRadius * sin( pointNoise )
          );
      }
    } else {
      record.vertex( 
        point.x, 
        point.y 
      );
    }

  }
  record.endShape(CLOSE);

}