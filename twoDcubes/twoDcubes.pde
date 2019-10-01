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
    numFrames       = 75;     

float shutterAngle = .12;

boolean recording = false,
        preview = true;

float angle, cubeSize, h;

PVector center;
PVector[] points;

void setup() {

  size(600, 600);
  colorMode(HSB, 3, 100, 100);
  noStroke();
  cubeSize = width/3;
  angle    = atan(0.5);
  center   = new PVector(width/2, height/2);
  h        = sqrt(sq(cubeSize/2) + sq(cubeSize/4));
}

void draw_() {
  
  background(0);
  
  int face = floor( t * 3 );
 
  float _t = 0;
  if( t < 0.33 ) {
    _t = map(t, 0, 0.33, 0, 1);
  }
  else if( t < 0.66 && t > 0.33 ) {
    _t = map(t, 0.33, 0.66, 0, 1);
  }
  else if( t > 0.66 ) {
    _t = map(t, 0.66, 1, 0, 1);
  }
  
  stroke(t*3, 100, 100);
  float distance = h * _t;
  for( int _d = 0; _d < distance; _d++ ) {

    if( t < 0.33 ) {
      line(
        center.x,
        center.y + (cubeSize/2) - _d,
        center.x + h * cos(angle),
        center.y + h * sin(angle) - _d
      );
    }
    if( t >= 0.33 && t < 0.66) {
      line(
        center.x - (_d * cos(angle)),
        center.y - (_d * sin(angle)),
        (center.x + cubeSize/2) - (_d * cos(angle)),
        (center.y - h/2) - (_d * sin(angle))
      );
    }
    if( t >= 0.66 ) {
      line( 
        center.x - h * cos(angle),
        center.y - h * sin(angle) + _d,
        center.x,
        center.y + _d
      );
    }
  }
  
}
