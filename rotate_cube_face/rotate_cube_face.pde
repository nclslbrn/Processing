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
int samplesPerFrame = 8,
    numFrames       = 60;     

float shutterAngle = .4;

boolean recording = true,
        preview = true;

PVector center;
int cubeSize;
float halfSize;
color cubeColor = color(75);


void setup() {
  size(800, 800, P3D);
  ortho();
  noStroke();
  colorMode(HSB, 3, 100, 100);
  fill(0, 0, 100);
  cubeSize = height/4;
  halfSize = cubeSize/2;
  center = new PVector(width/2, height/2, height/2);
}


void draw_() {

  background(0);
  //lights();
  directionalLight(1, 0, 100, -0.3, 0.5, -1);
  //(1,0,3, width, 0, -height/2, 1, -1, 1, QUARTER_PI, 0.5);

  float t1 = ease( map(t, 0, 0.33, 0, 1));
  float t2 = ease( map(t, 0.33, 0.66, 0, 1));
  float t3 = ease( map(t, 0.66, 1, 0, 1));

  push();
  translate(width*0.5, height*0.5);
  rotateX(-QUARTER_PI);
  rotateZ(QUARTER_PI);
  //fill(0);
  //stroke(cubeColor);
  box(cubeSize);

  
  noStroke();
  if( t > 5.0f/6.0f || t < 1.0f/6.0f ) {
    fill( 1, 100, 100);
  }
  if( t > 1.0f/6.0f && t < 3.0f/6.0f) {
    fill( 2, 100, 100);
  }
  if( t > 3.0f/6.0f && t < 5.0f/6.0f) {
    fill( 3, 100, 100);
  }

  if( t < 1.0f/3.0f ) {
    push();
    translate(-halfSize, -halfSize, halfSize);
    rotateX(PI*1.5*t1);
    rect(0, 0, cubeSize, cubeSize);
    pop();
  }
  if( t > 1.0f/3.0f && t < 2.0f/3.0f ) {
    push();
    translate(-halfSize, -halfSize, -halfSize);
    rotateZ(PI*1.5*-t2);
    rotateX(HALF_PI);
    rect(0, 0, cubeSize, cubeSize);
    pop();
  }
  if( t > 2.0f/3.0f ) {
    push();
    translate(-halfSize, -halfSize, halfSize);
    rotateY(PI*0.5 + PI*1.5*t3);
    rect(0, 0, cubeSize, cubeSize);
    pop();
  }
  
  

  pop();
}

