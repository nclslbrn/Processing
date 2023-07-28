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
