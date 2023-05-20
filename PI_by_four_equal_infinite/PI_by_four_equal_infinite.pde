float t, c;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

void push() {
  pushMatrix();
  pushStyle();
}

void pop() {
  popStyle();
  popMatrix();
}

void draw() {
  if (recording) {
    result = new int[width*height][3];
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    c = 0;
    for (int sa=0; sa<samplesPerFrame; sa++) {
      t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
      draw_();
      loadPixels();
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += pixels[i] >> 16 & 0xff;
        result[i][1] += pixels[i] >> 8 & 0xff;
        result[i][2] += pixels[i] & 0xff;
      }
    }

    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = 0xff << 24 | 
        int(result[i][0]*1.0/samplesPerFrame) << 16 | 
        int(result[i][1]*1.0/samplesPerFrame) << 8 | 
        int(result[i][2]*1.0/samplesPerFrame);
    updatePixels();

    saveFrame("records/frame-###.gif");
    if (frameCount==numFrames)
      exit();
  } else if (preview) {
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    t = (millis()/(20.0*numFrames))%1;
    draw_();
  } else {
    t = mouseX*1.0/width;
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    draw_();
  }
}

//////////////////////////////////////////////////////////////////////////////
int[][] result;

boolean recording = true,
        preview = true;

PVector[] circleCenter, infinitePoints;
float[] infiniteAngle;

int   samplesPerFrame = 60,
      numFrames       = 30,
      cubeSize        = 48,
      pointPerCircle,
      totalPoint,
      animPointSum;

float shutterAngle = .9,
      mainCircleRadius,
      mainCircleAngleStep;


void setup() {

  size(800, 800, P3D);
  noStroke();
  ellipseMode(CENTER);

  mainCircleRadius = width/6;
  pointPerCircle = ceil((2 * PI * mainCircleRadius) / cubeSize);
  circleCenter = new PVector[2];
  circleCenter[0] = new PVector(width*1/3, height/2);
  circleCenter[1] = new PVector(width*2/3, height/2);

  totalPoint = pointPerCircle * circleCenter.length + 1;
  infinitePoints = new PVector[totalPoint];
  infiniteAngle = new float[totalPoint];
  println(totalPoint);
  float circleAngleStep = TWO_PI/(pointPerCircle);
  int pointNum = 0;
  
  for( float angle = circleAngleStep; angle >= -TWO_PI; angle-= circleAngleStep ) {
    PVector start = new PVector(
      circleCenter[0].x + mainCircleRadius * cos(angle),
      circleCenter[0].y + mainCircleRadius * sin(angle)
    );
    infinitePoints[pointNum] = new PVector(start.x, start.y);
    infiniteAngle[pointNum] = angle/2;
    pointNum++;
  }

  for( float angle = PI + circleAngleStep; angle < (TWO_PI+ PI) - circleAngleStep; angle+= circleAngleStep ) {
    PVector start = new PVector(
      circleCenter[1].x + mainCircleRadius * cos(angle),
      circleCenter[1].y + mainCircleRadius * sin(angle)
    );
    println(pointNum);
    infinitePoints[pointNum] = new PVector(start.x, start.y);
    infiniteAngle[pointNum] = angle/2;
    pointNum++;
  }
  
  colorMode(HSB, totalPoint, 100, 100);
}

void draw_() {
  background(0);
  lights();
  ambientLight(255,255,255);
  
  int pointId = (int) map(t, 0, 1, 0, totalPoint );

  int pointCount = (int) map(
    t,
    (t < 0.5 ? 0 : 0.5),
    (t < 0.5 ? 0.5 : 1),
    (t < 0.5 ? 1 : 6),
    (t < 0.5 ? 6 : 1)
  );

  for( int p = 0; p <= pointCount; p++ ) {
    
    int newPointId = pointId - p;
    if(newPointId < 0 ) {
      newPointId = infinitePoints.length + newPointId;
    }
    
    fill( newPointId, 100, 100 );
    
    pushMatrix();
    
    translate(infinitePoints[newPointId].x, infinitePoints[newPointId].y);
    rotateX(cos(infiniteAngle[p]));
    rotateY(sin(infiniteAngle[p]));
    rotateZ(ease(p/pointCount)*PI);
    box(cubeSize);
    
    popMatrix();
    
  }
  
}
