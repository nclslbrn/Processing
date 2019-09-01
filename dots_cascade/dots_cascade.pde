import controlP5.*;

ControlP5 cp5;

int ellipseNum = 62,
  arcNum       = 12,
  animFrame    = 75,
  noiseScale   = 216,
  noiseRadius  = 6;

float[] ellipses;
int[] arcsEllipseID;
float[][] arcsDegrees;

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

float[] randomAngle() {
  float[] newAngle;
  newAngle = new float[2];
  newAngle[0] = random(1) * TWO_PI;
  newAngle[1] = newAngle[0] + random(1) * QUARTER_PI;

  return newAngle;
}

float radiusIndex(int i) {
  return map(ellipses[i], minRadius * sinStart, maxRadius * sinEnd, -1, 1);
}

float depth(float radiusIndex) {
  return map(sin(radiusIndex), -1, 1, 0, maxRadius * shapeHeight);
}

float noiseIntensity(PVector point, float t, int noiseScale) {
  return noise(
        point.x  / noiseScale,
        point.y  / noiseScale,
        t / noiseScale
      ) * fieldIntensity;
}

float dotColor(int i) {
  return map(ellipses[i], minRadius, maxRadius, 150, 255);
}

void setup() {

  size(800, 800, P3D);
  //pixelDensity(2);
  strokeWeight(1.5);
  noFill();
  control();
  
  minRadius = 64;
  maxRadius = width*1.5;

  ellipses = new float[ellipseNum];

  for (int i = 0; i < ellipseNum; i++) {

    ellipses[i] = map(i, 0, ellipseNum - 1, minRadius, maxRadius);

  }

  arcsEllipseID = new int[arcNum];
  arcsDegrees  = new float[arcNum][2];

  for( int a = 0; a < arcNum; a++ ) {
    arcsDegrees[a] = randomAngle();
    arcsEllipseID[a] = (int) random(ellipseNum-1);
  }
}

void draw() {

  float t;

  if (frameCount < animFrame) {
    t = map(frameCount, 0, animFrame, 0.0, 1.0);
  } else {
    t = map(frameCount % animFrame, 0, animFrame, 0.0, 1.0);
  }

  background(0);

  pushMatrix();
  translate(width / 2, height * 0.75, -height * cameraZoom);
  rotateX(radians(cameraXAngle));
  strokeWeight(1.5);

  float angleStep = TWO_PI / ellipseNum;

  for (int i = 0; i < ellipseNum; i++) {

    ellipses[i] -= step;

    float depth = depth(radiusIndex(i));

    stroke(dotColor(i));

    for (float p = 0; p <= TWO_PI; p += dotsMargin) {

      PVector point = new PVector(
        ellipses[i] * cos(p),
        ellipses[i] * sin(p),
        depth
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
  strokeWeight(2);

  for( int a = 0; a < arcNum; a++ ) {
      
    float depth = depth(radiusIndex(arcsEllipseID[a]));

    PVector arc[] = new PVector[2];

    arc[0] = new PVector(
      ellipses[arcsEllipseID[a]] * cos( arcsDegrees[a][0] ),
      ellipses[arcsEllipseID[a]] * sin( arcsDegrees[a][0] ),
      depth
    );

    arc[1] = new PVector(
      ellipses[arcsEllipseID[a]] * cos( arcsDegrees[a][1] ),
      ellipses[arcsEllipseID[a]] * sin( arcsDegrees[a][1] ),
      depth
    );
    stroke(dotColor(arcsEllipseID[a]), 0, 0);

    float angleToDraw = arcsDegrees[a][1] - arcsDegrees[a][0];
    
    beginShape();
    
    for( float angle = arcsDegrees[a][0]; angle <= arcsDegrees[a][1]; angle+= dotsMargin/2 ) {
      
      PVector point = new PVector(
        ellipses[arcsEllipseID[a]] * cos(angle),
        ellipses[arcsEllipseID[a]] * sin(angle),
        depth
      );

      float noiseIntensity = noiseIntensity( point, t, noiseScale );

      vertex(
        point.x + noiseRadius * cos(noiseIntensity),
        point.y + noiseRadius * sin(noiseIntensity),
        point.z + noiseRadius * cos(noiseIntensity)
      );
    }
    endShape();

    if (ellipses[arcsEllipseID[a]] - step*2 < minRadius) {
      arcsDegrees[a] = randomAngle();
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

void control() {
  cp5 = new ControlP5(this);

  cp5.addSlider("noiseScale")
    .setPosition(5, 5)
    .setRange(8, 800)
    .setNumberOfTickMarks(20)
    .setValue(noiseScale);
  cp5.addSlider("noiseRadius")
    .setPosition(5, 40)
    .setRange(1, 16)
    .setNumberOfTickMarks(20)
    .setValue(noiseRadius);
  cp5.addSlider("fieldIntensity")
    .setPosition(5, 75)
    .setRange(0.1, 64)
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

  cp5.addToggle("capture")
     .setPosition(590, 5)
     .setSize(50,50);

  cp5.addToggle("close")
     .setPosition(660, 5)
     .setSize(50,50);
}
