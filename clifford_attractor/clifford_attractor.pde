/**
* Attributed to Cliff Pickover
* Based on works/contribution by Paul Richards
* http://paulbourke.net/fractals/clifford/
*/
float a, b, c, d;
float res = 0.005;
float x = 0;
float y = 0;
float dx, dy, nScale;
int step = int(6 / res);
int p = 0;
int iters = 5000000; // 35000000
ArrayList<PVector> points = new ArrayList<PVector>();

float minX = -4.0;
float minY = minX * height / width;

float maxX = 4.0;
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
  
  a = random(-1.8, 1.8);
  b = random(-1.8, 1.8);
  c = random(-1.8, 1.8);
  d = random(-1.8, 1.8);

  x = 0;
  y = 0;
  p = 0;
  nScale = 0.001;
  points.clear();

  for( int i = 0; i < iters; i++) {
    
    float xn = sin(a * y) + c * cos(a * x);
    float yn = sin(b * x) + d * cos(b * y);
    float xi = (x - minX) * width / (maxX - minX);
    float yi = (y - minY) * height / (maxY - minY);
    points.add(new PVector(xi, yi));
    x = xn;
    y = yn;
  }

  background(0);
  println("a: " + a +" b: " + b + " c: "+ c + " d: "+d);
}

void draw() {

  if( p < points.size() / step ) { 


    for( int s = 0; s < step; s++ ) {

      int point = p * s;
      point(points.get(point).x, points.get(point).y);
      
    }
    p++;
  
  } else {
    
    println((p*step)+"/"+points.size());
    saveFrame("records/__a"+a+"__b"+b+"__c"+c+"__d"+d+".jpg");
    reinit();
  }

  if( mousePressed == true ) {
    reinit();
  }
}
