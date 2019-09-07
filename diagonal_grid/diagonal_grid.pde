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
int samplesPerFrame = 24;
int numFrames = 75;        
float shutterAngle = .4;


int cellSize;
float cols, rows, halfCellSize;
float _x, _y, xx, yy;
float zoom = 2;
boolean recording = true,
        preview = true;

int[][] result;

void setup() {
  size(800, 800);
  rectMode(CENTER);
  cellSize = (int) (width * zoom) / 8;
  halfCellSize = cellSize / 2;
  cols = (width * zoom) / cellSize;
  rows = (height * zoom) / cellSize;
}


void draw_() {

  background(0);
  noStroke();
  pushMatrix();
  translate(width/2, height/2);
  rotate(PI * t);
  translate((width*zoom)/-2, (height*zoom)/-2);
  float tt = map(
    t, 
    0,
    1,
    (t < 0.5 ? 0   : 1),
    (t < 0.5 ? 1   : 0)
  );

  for( int x = 0; x <= cols; x++ ) {

    _x = x * cellSize;
    xx = ease( map(
      x, 
      (x < cols/2 ? 0 : cols/2), 
      (x < cols/2 ? cols/2 : cols),
      0.2,
      0.65
    ), tt);

    for( int y = 0; y <= rows; y++ ) {
      
      _y = y * cellSize;
      yy = ease( map(
        y, 
        (y < rows/2 ? 0 : rows/2), 
        (y < rows/2 ? rows/2 : rows),
        0.2,
        0.65
      ), tt);

      fill(255);
      pushMatrix();
        translate(_x - cellSize, _y - cellSize);
        translate(width/2, height/2);
        rotate(TWO_PI- (TWO_PI*ease(t)));
        rect(0, 0, cellSize * xx, cellSize * yy); //ease(t)* cellSize );
      popMatrix();

      fill(255);
      pushMatrix();
        translate(_x - (cellSize/2), _y - (cellSize/2));
        translate(width/2, height/2);
        rotate(TWO_PI*ease(t));
        rect(0, 0, cellSize * xx, cellSize * yy); //ease(yy, t)* cellSize );

      popMatrix();
    }
  }
  popMatrix();
  
}