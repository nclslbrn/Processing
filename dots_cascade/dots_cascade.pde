import controlP5.*;

ControlP5 cp5;

int ellipseNum = 62,
  sphereNum    = 12,
  animFrame    = 256,
  noiseScale   = 216,
  noiseRadius  = 6;

float[] ellipses;
int[]   sphereEllipseID;
float[] sphereAngle;

float dotsMargin = radians(2),
  step           = 1,
  fieldIntensity = 35,
  zoff           = 0,
  shapeHeight    = 0.5,
  sinStart       = 0.8,
  sinEnd         = 0.33,
  cameraXAngle   = degrees(QUARTER_PI),
  cameraZoom     = 1.5,
  minRadius,
  maxRadius;

Slider noiseScaleSlider;
Slider noiseRadiusSlider;

boolean close     = false,
        recording = false,
        loops     = false,
        capture   = false;


float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float randomAngle() {
  return random(1) * TWO_PI;
}

float radiusIndex(int i) {
  return map(ellipses[i], minRadius * sinStart, maxRadius * sinEnd, -1, 1);
}

float depth(float radiusIndex) {
  return map(sin(radiusIndex), -1, 1, 0, maxRadius * shapeHeight);
}

int randomEllipse() {
  return (int) random(ellipseNum-1);
}

float noiseIntensity(PVector point, float t, int noiseScale) {

  float zOffstet = loops ? t : zoff;

  return noise(
        point.x  / noiseScale,
        point.y  / noiseScale,
        zOffstet
      ) * fieldIntensity;
}

float dotColor(int i) {
  return map(ellipses[i], minRadius, maxRadius, 150, 255);
}

void setup() {

  size(800, 800, P3D);
  //pixelDensity(2);
  controls();
  sphereDetail(2);
  strokeWeight(1.5);
  noFill();
  
  minRadius = 64;
  maxRadius = width*1.5;

  ellipses = new float[ellipseNum];

  for (int i = 0; i < ellipseNum; i++) {

    ellipses[i] = map(i, 0, ellipseNum - 1, minRadius, maxRadius);

  }

  sphereEllipseID = new int[sphereNum];
  sphereAngle     = new float[sphereNum];

  for( int a = 0; a < sphereNum; a++ ) {
    sphereAngle[a] = randomAngle();
    sphereEllipseID[a] = randomEllipse();
  }
}

void draw() {

  float t, ellipseStep;

  if (frameCount < animFrame) {
  
    if( frameCount < animFrame/2 ) {
      t = map(frameCount, 0, animFrame, 0.0, 5);
    } else {
      t = map( frameCount, 0, animFrame, 5, 0);
    }
  
  } else {

    if( frameCount % animFrame < animFrame/2) {
      t = map(frameCount % animFrame, 0, animFrame, 0.0, 5);
    } else {
      t = map(frameCount % animFrame, 0, animFrame, 5, 0.0);
    }
  }

  if( loops ) {
    ellipseStep = (maxRadius - minRadius) / animFrame;
  } else {
    ellipseStep = step;
  }

  background(0);

  pushMatrix();
  translate(width / 2, height * 0.75, -height * cameraZoom);
  rotateX(radians(cameraXAngle));
  strokeWeight(1.5);

  float angleStep = TWO_PI / ellipseNum;

  for (int i = 0; i < ellipseNum; i++) {

    ellipses[i] -= ellipseStep;

    stroke(dotColor(i));

    for (float p = 0; p <= TWO_PI; p += dotsMargin) {

      PVector point = new PVector(
        ellipses[i] * cos(p),
        ellipses[i] * sin(p),
        depth(radiusIndex(i))
      );

      float noiseIntensity = noiseIntensity( point, t, noiseScale);

      point(
        point.x + noiseRadius * cos(noiseIntensity),
        point.y + noiseRadius * sin(noiseIntensity),
        point.z + noiseRadius * cos(noiseIntensity)
      );

    }

    if (ellipses[i] - step < minRadius) {
      ellipses[i] = maxRadius;
    }
  }
  strokeWeight(0.5);

  for( int a = 0; a < sphereNum; a++ ) {
      
    PVector sphere = new PVector(
      ellipses[sphereEllipseID[a]] * cos( sphereAngle[a] ),
      ellipses[sphereEllipseID[a]] * sin( sphereAngle[a] ),    
      depth(radiusIndex(sphereEllipseID[a]))
    );

    stroke(dotColor(sphereEllipseID[a]), 0, 0);
    pushMatrix();
    translate(sphere.x, sphere.y, sphere.z);
    sphere(10);
    popMatrix();    
    
    
    if ( ellipses[sphereEllipseID[a]] - step*2 < minRadius ) {
      sphereAngle[a] = randomAngle();
    }
    
  }

  popMatrix();
  zoff += 0.01;

  if( 
    close == true || 
    (recording && frameCount > animFrame )
  ) {

    exit();
  
  }

  if( capture == true ) {
    saveFrame("records/capture-###.jpg");
    capture = false;
  }

  if( frameCount < animFrame-1 && recording ) {
    saveFrame("records/frame-###.jpg");
  }
}

void controls() {
  cp5 = new ControlP5(this);

  cp5.addSlider("noiseScale")
    .setPosition(5, 5)
    .setRange(16, 1440)
    .setNumberOfTickMarks(20)
    .setValue(noiseScale);
  cp5.addSlider("noiseRadius")
    .setPosition(5, 40)
    .setRange(1, 36)
    .setNumberOfTickMarks(20)
    .setValue(noiseRadius);
  cp5.addSlider("fieldIntensity")
    .setPosition(5, 75)
    .setRange(0.1, 180)
    .setNumberOfTickMarks(20)
    .setValue(fieldIntensity);

  cp5.addSlider("shapeHeight")
    .setPosition(200, 5)
    .setRange(0, 1)
    .setNumberOfTickMarks(15)
    .setValue(shapeHeight);
  cp5.addSlider("sinStart")
    .setPosition(200, 40)
    .setRange(0.1, 1)
    .setNumberOfTickMarks(20)
    .setValue(sinStart);
  cp5.addSlider("sinEnd")
    .setPosition(200, 75)
    .setRange(0.1, 1)
    .setNumberOfTickMarks(20)
    .setValue(sinEnd);

  cp5.addSlider("cameraXAngle")
    .setPosition(395, 5)
    .setRange(0, 180)
    .setValue(cameraXAngle);
  cp5.addSlider("cameraZoom")
    .setPosition(395, 40)
    .setRange(0.1, 2)
    .setValue(cameraZoom);

  cp5.addToggle("loops")
     .setPosition(590, 5)
     .setSize(50,30);

  cp5.addToggle("capture")
     .setPosition(590, 60)
     .setSize(50,30);

  cp5.addToggle("close")
     .setPosition(660, 5)
     .setSize(50,30);
}
