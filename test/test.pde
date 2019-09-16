/**
 * Hyperbolic and julia from @generateme
 * https://generateme.wordpress.com/2016/04/11/folds/  
 */
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

int samplesPerFrame = 6;
int numFrames = 75;        
float shutterAngle = .6;

boolean recording = false,
        preview = true;

PVector center;
int radius;
int variationScale;
int scale = 4;

void setup() {
  size(800, 800);
  background(250);
  smooth(8);
  noFill();
  stroke(20);
  strokeWeight(0.9);
  center = new PVector(width/2, height/2);
  radius = floor( width/3 );
  variationScale = floor(radius/numFrames);
 
}

void draw_() {
  
  float angle = TWO_PI / t;

  PVector pointInCircle = new PVector(
    center.x + radius * cos(angle),
    center.y + radius * sin(angle)
  );

  PVector moove  = hyperbolic(pointInCircle, 1);
  float x = map(moove.x, -30, 30, center.x - scale, center.x + scale * cos(angle));
  float y = map(moove.y, -30, 30, center.y - scale, center.y + scale * sin(angle));

  line(
    pointInCircle.x, 
    pointInCircle.y, 
    pointInCircle.x * moove.x, 
    pointInCircle.y * moove.y
  );
  
} 


PVector hyperbolic(PVector v, float amount) {
  
  float r = v.mag() + 1.0e-10;
  float theta = atan2(v.x, v.y);
  float x = amount * sin(theta) / r;
  float y = amount * cos(theta) * r;
  return new PVector(x, y);
}
PVector julia(PVector v, float amount) {
  float r = amount * sqrt(v.mag());
  float theta = 0.5 * atan2(v.x, v.y) + (int)(2.0 * random(0, 1)) * PI;
  float x = r * cos(theta);
  float y = r * sin(theta);
  return new PVector(x, y);
}
