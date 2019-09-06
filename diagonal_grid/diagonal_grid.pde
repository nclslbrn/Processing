int samplesPerFrame = 24;
int numFrames = 125;        
float shutterAngle = .6;
int cellSize;
float cols, rows, halfCellSize;
float _x, _y;
float zoom = 2;
boolean recording = true,
        preview = true;

int[][] result;
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

float c01(float g) {
  return constrain(g, 0, 1);
}


void setup() {
  size(600, 600);

  cellSize =(int) (width * zoom) / 4;
  halfCellSize = cellSize / 2;
  cols = (width * zoom) / cellSize;
  rows = (height * zoom) / cellSize;
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
void draw_() {

  background(0);
  fill(0);
  stroke(255);

  pushMatrix();
  translate(width/2, height/2);
  rotate(PI * t);
  translate((width*zoom)/-2, (height*zoom)/-2);
  
  for( int x = 0; x <= cols; x++ ) {
    
    float cellWidth = (width*zoom/cols);
    _x = x * cellSize;
    
    for( int y = 0; y <= rows; y++ ) {
  
      float cellHeight = (height*zoom/rows);
      _y = y * cellSize;
      
      float _halfCellSize = halfCellSize;
      float _cellSize = cellSize;
      float x1 = _x - cellWidth;
      float y1 = _y - cellHeight;
      float x2 = _x - (cellWidth/2);
      float y2 = _y - (cellHeight/2);   


      pushMatrix();
        translate(x1, y1);
        translate(width/2, height/2);
        rotate(TWO_PI- (PI*t));

        beginShape(QUADS);
        vertex(0, -cellHeight/2);
        vertex(cellWidth/2, 0);
        vertex(0, cellHeight/2);
        vertex(-cellWidth/2, 0);
        endShape(CLOSE);
      popMatrix();
      
      pushMatrix();
        translate(x2, y2);
        translate(width/2, height/2);
        rotate(TWO_PI*t);
        
        beginShape(QUADS);
        vertex(0, -cellHeight/2);
        vertex(cellWidth/2, 0);
        vertex(0, cellHeight/2);
        vertex(-cellWidth/2, 0);
        endShape(CLOSE);
      popMatrix();
    }
  }
  popMatrix();
  
}