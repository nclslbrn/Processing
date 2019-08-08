float zDist = 36, 
      zstep = 1.8, 
      rad = 120;

int pointPerCircle = 7;
int pointSize = 36;
float zmin, zmax, rotation;
int nb;

PVector[] circles;

void setup() {
  size(600, 600, P3D);
  noFill();

  zmin = width / -3;
  zmax = width * 1.2;
  
  nb = int((zmax - zmin) / zDist);
  circles = new PVector[nb];

  for (int i = 0; i < nb; i++) {
    circles[i] = new PVector(0, 0, map(i, 0, nb - 1, zmax, zmin));
  }
}

void draw() {
  background(20);
  stroke(255);
  PVector pv;
  float fc = (float)frameCount, a;
  float angle = TWO_PI / pointPerCircle;

  for (int i = 0; i < nb; i++) {

    pv = circles[i];
    pv.z += zstep;
    pv.x = width/2;
    pv.y = height/1.9;

    float r = map(pv.z, zmin, zmax, rad*.1, rad);
    float size = r / pointSize;

    pushMatrix();
    //translate(pv.x, pv.y, pv.z);
    translate(0, 0, pv.z);
    for( int p = 0; p <= pointPerCircle; p++ ) {
      float x = width/2 + r * cos(angle*p+rotation);
      float y = height/2 + r * sin(angle*p+rotation);
      ellipse(x, y, size, size);
    }
    //ellipse(0, 0, r, r);
    popMatrix();

    if (pv.z > zmax) {
      circles[i].z = zmin;
    }
  }
}
