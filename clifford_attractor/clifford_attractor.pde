/**
* Attributed to Cliff Pickover
* Based on works of Paul Richards
* http://paulbourke.net/fractals/clifford/
*
*/
float a, b, c, d;
float res = 0.005;
float x = 0;
float y = 0;
float dx, dy, nScale;
int step = int(6 / res);
int p = 0;
ArrayList<PVector> points = new ArrayList<PVector>();


float minX = -2.0;
float minY = minX * height / width;

float maxX = 2.0;
float maxY = maxX * height / width;

void setup() {
  size(800, 800); // need to be equal
  //fullScreen();
  noFill();
  strokeWeight(0.05);
  stroke(255, 20);

  reinit();
}

void reinit() {
  /*
  a = random(-2, 2);
  b = random(-2, 2);
  c = random(-2, 2);
  d = random(-2, 2);
  */
  
  x = 0.1;
  y = 0;
  a = -1.8;
  b = -2.0;
  c = -0.5;
  d = -0.9;
  x = 0;
  y = 0;
  p = 0;
  nScale = 0.001;
  points.clear();

  for( int i = 0; i < 35000000; i++) {
    
    float xn = sin(a * y) + c * cos(a * x);
    float yn = sin(b * x) + d * cos(b * y);
    float xi = (x - minX) * width / (maxX - minX);
    float yi = (y - minY) * height / (maxY - minY);
    points.add(new PVector(xi, yi));
    x = xn;
    y = yn;
  }
  

/*
  for ( float nx = -3; nx <= 3; nx += res) {
    for ( float ny = -3; ny <= 3; ny += res) {

      dx = (sin(a * ny) + c * cos(a * nx));
      dy = (sin(b * nx) + d * cos(b * ny));

      x = map( dx, -nScale, nScale, 0, width);
      y = map( dy, -nScale, nScale, 0, height);
      
      points.add(new PVector( x, y));
    }
  }
  */

  background(0);
  println("a: " + a +" b: " + b + " c: "+ c + " d: "+d);
}

void draw() {

  if( p < points.size() / step ) { 


    //beginShape();
    for( int s = 0; s < step; s++ ) {

      int point = p * s;
      //int point = (p*step) + s;
      //float current = map(point, 0, points.size(), 120, 180);      
      point(points.get(point).x, points.get(point).y);
      
    }
    //endShape();
    p++;
  
  } else {
    
    println((p*step)+"/"+points.size());
    saveFrame("records/__a"+a+"__b"+b+"__c"+c+"__d"+d+".jpg");
    //delay(500); // .5sec
    //reinit();
    exit();
  }

  if( mousePressed == true ) {
    exit();
  }
}