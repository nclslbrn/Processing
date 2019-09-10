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
int samplesPerFrame = 10,
    numFrames       = 20;     

float shutterAngle = .12;

boolean recording = false,
        preview = true;

float angle, cubeSize, h;

PVector center;
PVector[] points;

void setup() {

  size(600, 600);
  noStroke();
  colorMode(HSB, 3);
  cubeSize = width/3;
  angle    = atan(0.5);
  center   = new PVector(width/2, height/2);
  h        = sqrt(sq(cubeSize/2) + sq(cubeSize/4));
  
  points = new PVector[12];
  // right side
  points[0] = new PVector(
    center.x, 
    center.y
  );
  points[1] = new PVector(
    center.x, 
    center.y + cubeSize/2
  );
  points[2] = new PVector(
    center.x + h * cos(angle),
    center.y + h * sin(angle) 
  );
  points[3] = new PVector(
    center.x + h * cos(angle),
    (center.y- cubeSize/2) + h * sin(angle) 
  );
  // upper side
  points[4] = new PVector(
    center.x + h * cos(angle) ,
    (center.y - cubeSize/2) + h * sin(angle)
  );
  points[5] = new PVector(
    center.x, 
    center.y - cubeSize/2
  );
  points[6] = new PVector(
    center.x - h * cos(TWO_PI - angle),
    (center.y - cubeSize/2) - h * sin(TWO_PI - angle)
  );
  points[7] = new PVector(
    center.x, 
    center.y
  );
  //left side
  points[8] = new PVector(
    center.x - h * cos(TWO_PI - angle),
    (center.y - cubeSize/2) - h * sin(TWO_PI - angle)
  );
  points[9] = new PVector(
    center.x - h * cos(TWO_PI - angle),
    center.y - h * sin(TWO_PI - angle)
  );
  points[10] = new PVector(
    center.x, 
    center.y + cubeSize /2
  );
  points[11] = new PVector(
    center.x, 
    center.y
  );
}

void draw_() {
  background(0);

  float _t = 0;
  int n = 0;
  int _n = 0;

  if( t <= 0.33 ) {
    n = 0;
    _n = 4;
    _t = map(t, 0, 0.33, 0, 1);
  }
  if( t <= 0.66 && t > 0.33) {
    n = 4;
    _n = 8;
    _t = map(t, 0.33, 0.66, 0, 1);
  }
  if( t > 0.66 ) {
    n = 8;
    _n = 0;
    _t = map(t, 0.66, 1, 0, 1);
  }
  
  for( int face = 0; face < 3; face++ ) {
    
    int p = face * 4;

    fill( face, 100, 100 );
    beginShape();
    vertex(points[p].x, points[p].y);
    vertex(points[p+1].x, points[p+1].y);
    vertex(points[p+2].x, points[p+2].y);
    vertex(points[p+3].x, points[p+3].y);
    endShape(CLOSE);
  }

  fill(0,0,0);
  beginShape();
  for(int p = 0; p < 4; p++) {
    PVector moove = PVector.lerp(points[n+p], points[_n+p], _t);
    vertex( moove.x, moove.y);
  }
  endShape(CLOSE);
  
}
