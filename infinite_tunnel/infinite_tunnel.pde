float zDist = 36, 
      zstep = 1.8, 
      rad = 120;

int pointPerCircle = 5;
int pointSize = 36;
float zmin, zmax, rotation;
int nb;

PVector[] circles;

void setup() {
  size(1280, 720, P3D);
  //fullScreen(P3D);
  noFill();

  zmin = width / -5;
  zmax = width * 0.6;
  
  nb = int((zmax - zmin) / zDist);
  circles = new PVector[nb];

  for (int i = 0; i < nb; i++) {
    circles[i] = new PVector(0, 0, map(i, 0, nb - 1, zmax, zmin));
  }
}

void draw() {
  background(20);
  PVector pv;
  float fc = (float)frameCount, a;
  float angle = TWO_PI / pointPerCircle;

  for (int i = 0; i < nb; i++) {

    pv = circles[i];
    pv.z += zstep;
    pv.x = width/2;
    pv.y = height/1.9;
    
    float zRot = map(pv.z, zmin, zmax, QUARTER_PI, 0);

    float r = map(pv.z, zmin, zmax, rad*.1, rad);
    float size = r / pointSize;
    
    int stroke = (int)map(pv.z, zmin, zmax, 50, 255);
    stroke(stroke); 

    pushMatrix();
    translate(0, -height/24, pv.z);
    rotateX(zRot);
    
    for( int p = 0; p <= pointPerCircle; p++ ) {

      float x = width/2 + r * cos(angle*p+rotation);
      float y = height/2 + r * sin(angle*p+rotation);

      float _x = width/2 + r * cos(angle*(p+1)+rotation);
      float _y = height/2 + r * sin(angle*(p+1)+rotation);

      ellipse(x, y, size, size);

      line(x, y, _x, _y);
      line(x, y, 0, x * sin(zRot/zstep), y * cos(zRot/zstep), pv.z);

    }
    //ellipse(0, 0, r, r);
    popMatrix();
    rotation+= 0.0001;

    if (pv.z > zmax) {
      circles[i].z = zmin;
    }
  }
}
