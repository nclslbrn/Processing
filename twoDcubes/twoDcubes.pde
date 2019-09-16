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
    numFrames       = 20;     

float shutterAngle = .12;

boolean recording = false,
        preview = true;

float angle, cubeSize, h;

PVector center;
PVector[] points;

void setup() {

  size(600, 600);
  noStroke();
  cubeSize = width/3;
  angle    = atan(0.5);
  center   = new PVector(width/2, height/2);
  h        = sqrt(sq(cubeSize/2) + sq(cubeSize/4));
  
  points = new PVector[12];
  // right side
  points[0] = new PVector(
    center.x, 
    center.y
  );
  points[1] = new PVector(
    center.x, 
    center.y + cubeSize/2
  );
  points[2] = new PVector(
    center.x + h * cos(angle),
    center.y + h * sin(angle) 
  );
  points[3] = new PVector(
    center.x + h * cos(angle),
    (center.y- cubeSize/2) + h * sin(angle) 
  );
  // upper side
  points[4] = new PVector(
    center.x + h * cos(angle) ,
    (center.y - cubeSize/2) + h * sin(angle)
  );
  points[5] = new PVector(
    center.x, 
    center.y - cubeSize/2
  );
  points[6] = new PVector(
    center.x - h * cos(TWO_PI - angle),
    (center.y - cubeSize/2) - h * sin(TWO_PI - angle)
  );
  points[7] = new PVector(
    center.x, 
    center.y
  );
  //left side
  points[8] = new PVector(
    center.x - h * cos(TWO_PI - angle),
    (center.y - cubeSize/2) - h * sin(TWO_PI - angle)
  );
  points[9] = new PVector(
    center.x - h * cos(TWO_PI - angle),
    center.y - h * sin(TWO_PI - angle)
  );
  points[10] = new PVector(
    center.x, 
    center.y + cubeSize /2
  );
  points[11] = new PVector(
    center.x, 
    center.y
  );
}

void draw_() {
  background(0);
  int face = floor( t * 3 );
 
  float _t = t/3;
 /* 
  for( int f = 0; f < 3; f++ ) {
    
    int index = f * 4;

    fill( f, 100, 100 );
    beginShape();

    for( int p = 0; p < 4; p++ ) {
      vertex(points[index + p].x, points[index + p].y);
    }
    endShape(CLOSE);

  }
  

  fill(255);
    
  beginShape();
  for(int p = 0; p < 4; p++) {

    int index = face*4;
    vertex( points[index+p].x, points[index+p].y );
  }

  endShape(CLOSE);

  fill(75);
  beginShape();
  for(int p = 0; p < 4; p++) {

    int index = face*4;
    int _n = index < 8 ? index + 4 : 0;
    
    vertex( points[_n+p].x, points[_n+p].y );
  }

  endShape(CLOSE);
*/
  stroke(255);
  float distance = h * _t;
  for( int _d = 0; _d < distance; _d++ ) {

    if( t < 0.33 ) {
      line(
        center.x,
        center.y + cubeSize/2 - _d,
        center.x + h * cos(angle),
        center.y + h * sin(angle) - _d
      );
    }
    if( t >= 0.33 && t < 0.66) {
      line(
        center.x - _d * cos(TWO_PI - angle),
        center.y - (h * sin(angle)) - _d  * sin(angle),
        center.x + (h+_d) * cos(angle),
        center.y - (h * sin(angle)) - (_d  * sin(angle))
      );
    }
    if( t >= 0.66 ) {

    }
  }

}
