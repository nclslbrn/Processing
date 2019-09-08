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

float mn = .5*sqrt(3), ia = atan(sqrt(.5));

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

    saveFrame("records/frame-###.jpg");
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
int samplesPerFrame = 4,
    numFrames       = 30;     

float shutterAngle = .12;

boolean recording = true,
        preview = true;

float angle, cubeSize, h;

PVector center;
PVector[] points;

void setup() {

  size(600, 600);
  noStroke();

  cubeSize = width/3;
  angle    = atan(0.5);
  center   = new PVector(width/2, height/2);
  h        = sqrt(sq(cubeSize/2) + sq(cubeSize/4));
  
  points = new PVector[7];

  points[0] = new PVector(
    center.x, 
    center.y + cubeSize/2
  );
  points[1] = new PVector(
    center.x + h * cos(angle),
    center.y + h * sin(angle)
  );
  points[2] = new PVector(
    points[1].x, 
    points[1].y-h
  );
  points[3] = new PVector(
    center.x, 
    center.y - cubeSize/2
  );
  points[4] = new PVector(
    center.x - h * cos(TWO_PI - angle),
    (center.y - h * sin(TWO_PI - angle)) - cubeSize/2
  );
  points[5] = new PVector(
    center.x - h * cos(TWO_PI - angle),
    center.y - h * sin(TWO_PI - angle)
  );
  points[6] = new PVector(
    center.x, 
    center.y + cubeSize/2
  );
}

void draw_() {
  background(0);

  fill(0, 200, 0);
  beginShape();
  vertex(center.x, center.y);
  vertex(points[0].x, points[0].y);
  vertex(points[1].x, points[1].y);
  vertex(points[2].x, points[2].y);
  endShape(CLOSE);

  fill(0, 0, 200); 
  beginShape();
  vertex(center.x, center.y);
  vertex(points[2].x, points[2].y);
  vertex(points[3].x, points[3].y);
  vertex(points[4].x, points[4].y);
  endShape(CLOSE);

  fill(200, 0, 0);
  beginShape();
  vertex(center.x, center.y);
  vertex(points[4].x, points[4].y);
  vertex(points[5].x, points[5].y);
  vertex(points[6].x, points[6].y);
  endShape(CLOSE);
   

  float _t = 0;
  int n = 0;
  int _n = 0;

  if( t <= 0.33 ) {
    n = 0;
    _n = 2;
    _t = ease( map(t, 0, 0.33, 0, 1));
  }
  if( t <= 0.66 && t > 0.33) {
    n = 2;
    _n = 4;
    _t = ease( map(t, 0.33, 0.66, 0, 1));
  }
  if( t > 0.66 ) {
    n = 4;
    _n = 0;
    _t = ease( map(t, 0.66, 1, 0, 1));
  }

  PVector p1 = PVector.lerp(points[n],   points[_n],   ease(_t, 1));
  PVector p2 = PVector.lerp(points[n+1], points[_n+1], ease(_t, 0.75));
  PVector p3 = PVector.lerp(points[n+2], points[_n+2], ease(_t, 0.5));

  fill(0);
  beginShape();
  vertex(center.x, center.y);
  vertex(p1.x, p1.y);
  vertex(p2.x, p2.y);
  vertex(p3.x, p3.y);
  endShape(CLOSE);
  
  fill(0);
  beginShape();
  vertex(center.x, center.y);
  vertex(points[n].x, points[n].y);
  vertex(points[n+1].x, points[n+1].y);
  vertex(points[n+2].x, points[n+2].y);
  endShape(CLOSE);
}
