int animFrame = 256,
    cellSize;
float cols, rows, halfCellSize;
float _x, _y;
float zoom = 1.5;

boolean recording = false;

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
  noStroke();
  cellSize =(int) (width * zoom) / 5;
  halfCellSize = cellSize / 2;
  cols = (width * zoom) / cellSize;
  rows = (height * zoom) / cellSize;
}

void draw() {
  background(0);

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
  rotate(TWO_PI * t2);
  translate(-width/2, -height/2);

  for( int x = 0; x <= cols; x++ ) {
    
    float cellWidth = width/cols;
    _x = x * cellSize;

    for( int y = 0; y <= rows; y++ ) {
  
      float cellHeight = height/rows;
      _y = y * cellSize;
      
      float _halfCellSize = halfCellSize;
      float _cellSize = cellSize;
      float x1 = _x - cellWidth;
      float y1 = _y - cellHeight;
      float x2 = _x - (cellWidth/2);
      float y2 = _y - (cellHeight/2);

      fill(0);
      beginShape(QUADS);
      vertex(x1, y1-(cellHeight/2));
      vertex(x1+(cellWidth/2), y1);
      vertex(x1, y1+(cellHeight/2));
      vertex(x1-(cellWidth/2), y1);
      endShape(CLOSE);

      fill(255);
      beginShape(QUADS);
      vertex(x2, y2-(cellHeight/2));
      vertex(x2+(cellWidth/2), y2);
      vertex(x2, y2+(cellHeight/2));
      vertex(x2-(cellWidth/2), y2);
      endShape(CLOSE);

    }
  }
  popMatrix();
  if( recording && frameCount >= animFrame && frameCount < animFrame*2) {
    saveFrame("records/frame-###.jpg");
  }
}