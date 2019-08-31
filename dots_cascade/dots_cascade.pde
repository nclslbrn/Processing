//OpenSimplexNoise noise;

import peasy.*;
import controlP5.*;

PeasyCam camera;
ControlP5 cp5;

int ellipseNum     = 56,
    animFrame      = 75,
    noiseScale     = 24,
    noiseRadius    = 4;

float[] ellipses;

float dotsMargin     = radians(2),
      step           = 1,
      fieldIntensity = 1.2,
      phase          = 0,
      zoff           = 0,
      minRadius,
      maxRadius;

Slider noiseScaleSlider;
Slider noiseRadiusSlider;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

void setup() {
  size(800, 800, P3D);
  strokeWeight(1);
  stroke(255);
  camera = new PeasyCam(this, width/2, height/2, height, 50);
  
  cp5 = new ControlP5(this);

  cp5.addSlider("noiseScale")
     .setPosition(5,5)
     .setRange(8,512);

  cp5.addSlider("noiseRadius")
    .setPosition(5,15)
    .setRange(2,48);

  cp5.setAutoDraw(false);

  minRadius = 64;
  maxRadius = width;
  
  ellipses = new float[ellipseNum];

  for( int i = 0; i < ellipseNum; i++ ) {

    ellipses[i] = map(i, 0, ellipseNum-1, minRadius, maxRadius);

  }
}

void draw() {

  
  float t;

  if( frameCount < animFrame ) {
    t = map(frameCount, 0, animFrame, 0.0, 1.0);
  } else {
    t = map(frameCount%animFrame, 0, animFrame, 0.0, 1.0);
  }

  background(0);  

  pushMatrix();

  /*
  translate(width/2, height/2, -height/2);
  */
  translate(width/2, height, -height/2.5);
  rotateX(QUARTER_PI);
  float angleStep = TWO_PI/ellipseNum;

  for( int i = 0; i < ellipseNum; i++ ) {
    
    ellipses[i] -= step;

    float radiusIndex = map( ellipses[i], minRadius*4, maxRadius/8, 0, 1);

    float depth = map(sin(TWO_PI/radiusIndex), -1, 1, 0, maxRadius);
    
    for( float p = 0; p <= TWO_PI; p+= dotsMargin ) {
      
      PVector point = new PVector(
        ellipses[i] * cos(p),
        ellipses[i] * sin(p),
        depth
      );

      float noiseIntensity = noise(
        point.x / noiseScale, 
        point.y / noiseScale, 
        depth + phase
      )* fieldIntensity;

      point(
        point.x + noiseScale * cos(noiseIntensity),
        point.y + noiseScale * sin(noiseIntensity),
        point.z + noiseScale * tan(noiseIntensity)
      );
      
    }
    
    if( ellipses[i] - step < minRadius) {
      ellipses[i] = maxRadius;
    }
  }
  popMatrix();
  phase += 0.03;
  zoff += 0.001;

  gui();
}

void gui() {
  hint(DISABLE_DEPTH_TEST);
  camera.beginHUD();
  cp5.draw();
  camera.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

/*
void mousePressed() {
  exit();
}
*/