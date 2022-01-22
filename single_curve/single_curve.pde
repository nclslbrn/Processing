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
int samplesPerFrame = 12,
    numFrames       = 60;     

float shutterAngle = .9;
boolean recording = true,
        preview = true;

float radius, cx, cy, theta;
int cellSize = 12;
float freq = 0.007;
int step = 1;
int cols, rows, ctx, cty;
float depth;
OpenSimplexNoise noise;

void setup() {
  size(800, 800);
  noFill();
  smooth(10);
  stroke(220);
  strokeWeight(2);
  noise = new OpenSimplexNoise();
 
  cols = width / cellSize;
  rows = height / cellSize;
  ctx = width / 2;
  cty = height / 2;
  depth = cellSize*1.7; 
}

void draw_() {
  background(20);
  beginShape();
  for( int x = 1; x <= cols - 1; x++ ) {
    for( int y = 2; y <= rows - 2; y++ ) {
      
      int _y = x % 2 == 0 ? cols - y - 1: y;
      float posX = x * cellSize;
      float posY = _y * cellSize;
      
      
      for( int dy = 0; dy < cellSize; dy += step ) {
        int _dy = x % 2 == 0 ? cellSize - dy : dy;
        float distToCt = sqrt(pow(abs(ctx - posX), 2) + pow(abs(cty - (posY + _dy)), 2));
        float n = 9.0f * (float)noise.eval(
          posX * freq,
          (posY + _dy) * freq,
          0.8 * cos(TWO_PI * t),
          0.8 * sin(TWO_PI * t) 
         );
        float rX = pow((ctx - distToCt) / ctx, 3);
        float rY = pow((cty - distToCt) / cty, 3);

        curveVertex(
          posX + cos(n) * rX * depth,
          posY + _dy + sin(n) * rY * depth
        );
        
      }
    }
  }
  endShape();
}
