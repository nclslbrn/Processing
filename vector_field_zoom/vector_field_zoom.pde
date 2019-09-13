/**
 * From @tsulej
 * https://generateme.wordpress.com/2016/04/24/drawing-vector-field/
 */

// dynamic list with our points, PVector holds position
ArrayList<PVector> points = new ArrayList<PVector>();
int numFrame = 10;
float seed = 1;

// colors used for points
color[] pal = {
  color(0, 91, 197),
  color(0, 180, 252),
  color(23, 249, 255),
  color(223, 147, 0),
  color(248, 190, 0)
};
 
// global configuration
float vector_scale = 0.1; // vector scaling factor, we want small steps
 
void setup() {
  size(800, 800);
  //fullScreen(); <- TODO: make computation relative to height
  strokeWeight(1);
  background(0, 5, 25);
  noFill();
 
 
  // create points from [-3,3] range
  for (float x=-3; x<=3; x+=0.07) {
    for (float y=-3; y<=3; y+=0.07) {
      // create point slightly distorted
      PVector v = new PVector(x+randomGaussian()*0.003, y+randomGaussian()*0.003);
      points.add(v);
    }
  }
}
void reinit() {

  int point_idx = 0;
  for (float x=-3; x<=3; x+=0.07) {
    for (float y=-3; y<=3; y+=0.07) {
      PVector v = new PVector(x+randomGaussian()*0.003, y+randomGaussian()*0.003);
      points.set(point_idx, v);
      point_idx++;
    }
  }
}

void draw() {

  float t = 1.0 * ( frameCount < numFrame ? frameCount : frameCount % numFrame) / numFrame;
  if( t == 0) {
    reinit();
    seed = random(15);
    //background(0, 5, 25);
  }
  float _t = (t+0.5)*0.75;

  fill(0, 5, 25, 100);
  rect(-1, -1, width+1, height+1);

  int point_idx = 0; // point index
  
  for (PVector p : points) {
    // map floating point coordinates to screen coordinates
    float xx = map(p.x, -6.5, 6.5, width/2 - width*_t, width/2 + width*_t);
    float yy = map(p.y, -6.5, 6.5, height/2 - height*_t, height/2 + height*_t);
 
    // select color from palette (index based on noise)
    int cn = (int)(100*pal.length*noise(point_idx))%pal.length;
    stroke(pal[cn], (1-t)*50 );
    //point(xx, yy); //draw

    line(xx, yy, p.x + xx, p.y + yy);

    // placeholder for vector field calculations
    float n1a = 3*map(noise(p.x/2,p.y/2,seed),0,1,-1,1);
    float n1b = 3*map(noise(p.y/2,p.x/2,seed),0,1,-1,1);
    float nn = 6*map(noise(n1a,n1b,seed),0,1,-1,1);
    
    //PVector v = circle(nn);
    PVector v = sinusoidal(p, nn);
    v.mult(1);
    // different values for different functions
    // v is vector from the field

    p.x += vector_scale * v.x;
    p.y += vector_scale * v.y;

    // go to the next point
    point_idx++;
  }
  saveFrame("records/frame-###.jpg");
}
PVector circle(float n) { // polar to cartesian coordinates
  return new PVector(cos(n), sin(n));
}
 
PVector astroid(float n) {
  float sinn = sin(n);
  float cosn = cos(n);
 
  float xt = sq(sinn)*sinn;
  float yt = sq(cosn)*cosn;
 
  return new PVector(xt, yt);
}
 
PVector cissoid(float n) {
  float sinn2 = 2*sq(sin(n));
 
  float xt = sinn2;
  float yt = sinn2*tan(n);
 
  return new PVector(xt, yt);
}
 
PVector kampyle(float n) {
  float sec = 1/sin(n);
 
  float xt = sec;
  float yt = tan(n)*sec;
 
  return new PVector(xt, yt);
}
 
PVector rect_hyperbola(float n) {
  float sec = 1/sin(n);
 
  float xt = 1/sin(n);
  float yt = tan(n);
 
  return new PVector(xt, yt);
}
 
final static float superformula_a = 1;
final static float superformula_b = 1;
final static float superformula_m = 6;
final static float superformula_n1 = 1;
final static float superformula_n2 = 7;
final static float superformula_n3 = 8;
PVector superformula(float n) {
  float f1 = pow(abs(cos(superformula_m*n/4)/superformula_a), superformula_n2);
  float f2 = pow(abs(sin(superformula_m*n/4)/superformula_b), superformula_n3);
  float fr = pow(f1+f2, -1/superformula_n1);
 
  float xt = cos(n)*fr;
  float yt = sin(n)*fr;
 
  return new PVector(xt, yt);
}

PVector sinusoidal(PVector v, float amount) {
  return new PVector(amount * sin(v.x), amount * sin(v.y));
}
 
PVector waves2(PVector p, float weight) {
  float x = weight * (p.x + 0.9 * sin(p.y * 4));
  float y = weight * (p.y + 0.5 * sin(p.x * 5.555));
  return new PVector(x, y);
}
 
PVector polar(PVector p, float weight) {
  float r = p.mag();
  float theta = atan2(p.x, p.y);
  float x = theta / PI;
  float y = r - 2.0;
  return new PVector(weight * x, weight * y);
}
 
PVector swirl(PVector p, float weight) {
  float r2 = sq(p.x)+sq(p.y);
  float sinr = sin(r2);
  float cosr = cos(r2);
  float newX = 0.8 * (sinr * p.x - cosr * p.y);
  float newY = 0.8 * (cosr * p.y + sinr * p.y);
  return new PVector(weight * newX, weight * newY);
}
 
PVector hyperbolic(PVector v, float amount) {
  float r = v.mag() + 1.0e-10;
  float theta = atan2(v.x, v.y);
  float x = amount * sin(theta) / r;
  float y = amount * cos(theta) * r;
  return new PVector(x, y);
}
 
PVector power(PVector p, float weight) {
  float theta = atan2(p.y, p.x);
  float sinr = sin(theta);
  float cosr = cos(theta);
  float pow = weight * pow(p.mag(), sinr);
  return new PVector(pow * cosr, pow * sinr);
}
 
PVector cosine(PVector p, float weight) {
  float pix = p.x * PI;
  float x = weight * 0.8 * cos(pix) * cosh(p.y);
  float y = -weight * 0.8 * sin(pix) * sinh(p.y);
  return new PVector(x, y);
}
 
PVector cross(PVector p, float weight) {
  float r = sqrt(1.0 / (sq(sq(p.x)-sq(p.y)))+1.0e-10);
  return new PVector(weight * 0.8 * p.x * r, weight * 0.8 * p.y * r);
}
 
PVector vexp(PVector p, float weight) {
  float r = weight * exp(p.x);
  return new PVector(r * cos(p.y), r * sin(p.y));
}
 
// parametrization P={pdj_a,pdj_b,pdj_c,pdj_d}
float pdj_a = 0.1;
float pdj_b = 1.9;
float pdj_c = -0.8;
float pdj_d = -1.2;
PVector pdj(PVector v, float amount) {
  return new PVector( amount * (sin(pdj_a * v.y) - cos(pdj_b * v.x)),
  amount * (sin(pdj_c * v.x) - cos(pdj_d * v.y)));
}
 
final float cosh(float x) { return 0.5 * (exp(x) + exp(-x));}
final float sinh(float x) { return 0.5 * (exp(x) - exp(-x));}