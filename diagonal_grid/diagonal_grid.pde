int animFrame = 64,
    cellSize;
float cols, rows, halfCellSize;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float softplus(float q,float p){
  float qq = q+p;
  if(qq<=0){
    return 0;
  }
  if(qq>=2*p){
    return qq-p;
  }
  return 1/(4*p)*qq*qq;
}


void setup() {
  size(800, 800);
  frameRate(24);
  noStroke();
  cellSize = width / 16;
  halfCellSize = cellSize / 2;
  cols = (width * 1.5) /cellSize;
  rows = (height * 1.5)  / cellSize;
}

void draw() {

  float t, t1, t2;

  if( frameCount < animFrame/2 ) {
    t = map(frameCount, 0, animFrame/2, 0.0, 1.0);
    t1 = ease( map(frameCount, 0, animFrame/2, 0.0, 1.0));
  } else {
    t = map(frameCount%animFrame/2, 0, animFrame/2, 0.0, 1.0);
    t1 = ease( map(frameCount%animFrame/2, 0, animFrame/2, 0.0, 1.0));
  }
  if( frameCount < animFrame ) {
    t2 = ease( map(frameCount, 0, animFrame, 0.0, 1.0));
  } else {
    t2 = ease( map(frameCount%animFrame, 0, animFrame, 0.0, 1.0));
  }

  pushMatrix();
  translate(width/2, height/2);
  rotate(HALF_PI*t);
  translate(-width/2, -height/2);

  for( int x = 0; x <= cols; x++ ) {
    for( int y = 0; y <= rows; y++ ) {
      
      float middle_t1 = map(t1, 0, 1, 0.5, 1);
      float _halfCellSize = halfCellSize * middle_t1;
      float _cellSize = cellSize * cos(t1);

      float _x = x * cellSize;
      float _y = y * cellSize;

      float x1 = _x - cellSize;
      float y1 = _y - cellSize;
      float x2 = _x - halfCellSize;
      float y2 = _y - halfCellSize;

      fill(0);
      beginShape(QUADS);
      vertex(x1, y1-_halfCellSize);
      vertex(x1+_halfCellSize, y1);
      vertex(x1, y1+_halfCellSize);
      vertex(x1-_halfCellSize, y1);
      endShape(CLOSE);

      fill(255);
      beginShape(QUADS);
      vertex(x2, y2-_halfCellSize);
      vertex(x2+_halfCellSize, y2);
      vertex(x2, y2+_halfCellSize);
      vertex(x2-_halfCellSize, y2);
      endShape(CLOSE);


    }
  }
  popMatrix();
  if( frameCount >= animFrame && frameCount < animFrame*2) {
    saveFrame("records/frame-###.jpg");
  }
}