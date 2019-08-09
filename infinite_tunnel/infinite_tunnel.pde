
float zDist = 36, 
      zstep = 1.8, 
      rad = 120;

String[] letters = {
  "a", "b", "c", "d", "e", "f", 
  "g", "h", "i", "j", "k", "l",
  "m", "n", "o", "p", "q", "r",
  "s", "t", "u", "v", "w", "x",
  "y", "z" };

int pointPerCircle = 7;
int pointSize = 36;
float zmin, zmax, rotation;
int nb;

PVector[] circles;
String[][] text;

void setup() {

  size(600, 600, P3D);

  zmin = width / -5;
  zmax = width * 0.6;
  
  nb = int((zmax - zmin) / zDist);

  circles = new PVector[nb];
  text = new String[nb][pointPerCircle+1];

  for (int i = 0; i < nb; i++) {
    
    circles[i] = new PVector(0, 0, map(i, 0, nb - 1, zmax, zmin));
    
    for( int p = 0; p <= pointPerCircle; p++ ) {
      text[i][p] = letters[ (int) random(letters.length) ];
    }
  }
}

void draw() {

  background(20);
  
  PVector pv;
  float fc = (float)frameCount, a;
  float angle = TWO_PI / pointPerCircle;

  for (int i = 0; i < nb; i++) {

    pv = circles[i];
    pv.x = width/2;
    pv.y = height/2;
    pv.z += zstep;
    
    float zRot = map(pv.z, zmin, zmax, QUARTER_PI, 0);

    float r = map(pv.z, zmin, zmax, rad*.1, rad);
    float size = r / pointSize;
    
    int stroke = (int) map(pv.z, zmin, zmax, 50, 255);
    stroke(stroke);
    fill(stroke); 

    pushMatrix();
    translate(0, -height/24, pv.z);
    //rotateX(zRot);
    
    for( int p = 0; p <= pointPerCircle; p++ ) {

      float x = width/2 + r * cos(angle*p+rotation);
      float y = height/2 + r * sin(angle*p+rotation);

      float _x = width/2 + r * cos(angle*(p+1)+rotation);
      float _y = height/2 + r * sin(angle*(p+1)+rotation);

      ellipse(x, y, size, size);

      line(x, y, 0, _x, _y, 0);
      text(text[i][p], x, y, 0);
      textSize(size*10);

    }
    popMatrix();
    rotation+= 0.0001;

    if (pv.z > zmax) {
      circles[i].z = zmin;
    }
  }
}
