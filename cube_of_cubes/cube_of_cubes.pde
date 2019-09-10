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
int samplesPerFrame = 2,
    numFrames       = 75;     

float shutterAngle = .8;

boolean recording = true,
        preview = false;

float angle = 0;

int cubePerAxes = 3,
    cubeSize    = 64,
    cubeCount   = (int) pow(cubePerAxes, 3);

PVector[] initPos;
float[][] initAngle;

void setup() {
  size(800, 800, P3D);
  colorMode(HSB, cubeCount/2, 100, 100);
  ortho();
  strokeWeight(1.5);
  stroke(0);

  initPos = new PVector[cubeCount];
  initAngle = new float[cubeCount][3];

  computePos();
  
}

void computePos() {

  for( int c = 0; c < cubeCount; c++ ) {
    initPos[c] = new PVector( 
      random(width)-(width/2), 
      random(height)-(height/2), 
      random(height)-(height/2)
    );
    for( int a = 0; a < 3; a++ ) {
      initAngle[c][a] = random(1) * TWO_PI;
    }
  }
}

void draw_() {

  background(0);
  lights();
  ambientLight(255,255,255);
  pushMatrix();
  translate(width/2, height/2);
  rotateX(-QUARTER_PI);
  rotateZ(QUARTER_PI);

  int id = 0;
  float tt = ease( map(
    t,
    (t < 0.5 ? 0 : 1),
    (t < 0.5 ? 1 : 0),
    0,
    2
  ));

  for(int x = 0; x < cubePerAxes; x++ ) {
    for( int y = 0; y < cubePerAxes; y++ ) {
      for( int z = 0; z < cubePerAxes; z++ ) {

        PVector finalPos = new PVector(
          cubeSize * (-cubePerAxes/2) + x*cubeSize,
          cubeSize * (-cubePerAxes/2) + y*cubeSize,
          cubeSize * (-cubePerAxes/2) + z*cubeSize
        );

        PVector currentPos = PVector.lerp(initPos[id], finalPos, ease(tt));
        float xRot = initAngle[id][0] * ease(1-tt);
        float yRot = initAngle[id][1] * ease(1-tt); 
        float zRot = initAngle[id][2] * ease(1-tt); 
        
        stroke(x+y+z, 100, 25);
        fill(x+y+z, 70, 70);
        
        pushMatrix();  
        
        rotateX(xRot);
        rotateY(yRot);
        rotateZ(zRot);
        translate(currentPos.x, currentPos.y, currentPos.z);
        
        box(cubeSize);  
        
        popMatrix();

        id++;
      }
    }
  }
  popMatrix();

  if( tt > 0.99 && !recording ) {
    computePos();
  }
}