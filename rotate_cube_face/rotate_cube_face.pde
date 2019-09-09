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
int samplesPerFrame = 4,
    numFrames       = 50;     

float shutterAngle = .6;

boolean recording = false,
        preview = true;

float angle = 0;
PVector center;
int cubeSize;
float halfSize = cubeSize/2;

PVector[] initPos;
float[][] initAngle;

void setup() {
  size(520, 520, P3D);
  ortho();
  strokeWeight(1.5);
  stroke(0);

  cubeSize = height/4;
  center = new PVector(width/2, height/2, height/2);
}


void draw_() {

  background(0);
  lights();

  pushMatrix();
  translate(width/2, height/2);
  rotateX(-QUARTER_PI);
  rotateZ(QUARTER_PI);
  
  fill(255);
  box(cubeSize);
  
  fill(0,0,255);
  pushMatrix();
  translate(-cubeSize/2, -cubeSize/2, cubeSize/2);
  rect(0, 0, cubeSize, cubeSize);
  popMatrix();

  fill(255, 0, 0);
  pushMatrix();
  translate(-cubeSize/2, -cubeSize/2, -cubeSize/2);
  rotateY(-HALF_PI);
  rect(0, 0, cubeSize, cubeSize);
  popMatrix();

  fill(0, 255, 0);
  pushMatrix();
  translate(-cubeSize/2, -cubeSize/2, -cubeSize/2);
  rotateX(HALF_PI);
  rect(0, 0, cubeSize, cubeSize);
  popMatrix();

  popMatrix();

}