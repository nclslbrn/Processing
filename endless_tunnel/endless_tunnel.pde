PFont font;

float zDist = 36, 
      zstep = 1.8, 
      rad = 120,
      radFactor = 0.9;

Boolean englishVersion = false;

String sentence;
String frenchSentence = "jusqu'ici tout va bien, ";
String englishSentence = "so far so good, ";

int pointPerCircle = 5;
int pointSize = 36;
float zmin, zmax, rotation;
int nb;

PVector[] circles;
char[] text;

void setup() {
  //fullScreen(P3D);
  size(860, 860, P3D);
  textAlign(CENTER, CENTER);
  //noLoop();
  
  font = loadFont("Novecentosanswide-Bold-99.vlw");
  
  if( englishVersion ) {
    sentence = englishSentence;
  } else {
    sentence = frenchSentence;
  }
  
  zmin = width / -5;
  zmax = width * 0.8;
  nb = sentence.length();

  circles = new PVector[nb];
  text = new char[nb];

  int c = 0;

  for (int i = 0; i < nb; i++) {
    
    text[i] = sentence.charAt(c);
    circles[i] = new PVector(0, 0, map(i, 0, nb - 1, zmax, zmin));

    if(c == sentence.length() ) {
      c = 0;
    } else {
      c++;
    }
  }
}

void draw() {
  background(10);
  
  PVector pv;
  float angle = TWO_PI / pointPerCircle;

  for (int i = 0; i < nb; i++) {

    pv = circles[i];
    pv.x = width/2;
    pv.y = height/2;
    pv.z += zstep;
    
    float middleZ = zstep /2;
    float r = map(pv.z, zmin, zmax, rad*.1, rad);
    float ellipeSize = r / pointSize;

    
    int stroke = (int) map(pv.z, zmin, zmax, 50, 255);

    stroke(stroke);
    fill(stroke); 

    pushMatrix();
    translate(width/2, height/2, pv.z);
    
    for( int p = 1; p <= pointPerCircle; p++ ) {
      
      float halfAngle = angle/2;
      float thirdAngle = angle/3;

      float x = r * cos(angle*p+rotation);
      float y = r * sin(angle*p+rotation);

      float _x = r * cos(angle*(p+1)+rotation);
      float _y = r * sin(angle*(p+1)+rotation);
    
      float x_first_third = r * cos(thirdAngle+(angle*p)+rotation);
      float y_first_third = r * sin(thirdAngle+(angle*p)+rotation);

      float x_last_third = r * cos((thirdAngle*2)+(angle*p)+rotation);
      float y_last_third = r * sin((thirdAngle*2)+(angle*p)+rotation);

      float middleX = (r*radFactor) * cos(halfAngle+(angle*p)+rotation);
      float middleY = (r*radFactor) * sin(halfAngle+(angle*p)+rotation);
      
      
      
      
      float textRotZ = angle*p + angle/2 + rotation;

      ellipse(x, y, ellipeSize, ellipeSize);
      
      //line(middleX, middleY, 0, middleX, middleY, pv.z);
      
      line(x, y, 0, x, y, pv.z);
      line(x, y, 0, _x, _y, 0);
      line(x_first_third, y_first_third, 0, x_first_third, y_first_third, pv.z);
      line(x_last_third, y_last_third, 0, x_last_third, y_last_third, pv.z);

      textFont(font, ellipeSize * 10);

      pushMatrix();
      translate(middleX, middleY, middleZ );
      
     
      rotateZ(textRotZ);
      rotateY(HALF_PI);
      rotateX(PI);
      
      text(text[i], 0, 0, 0);
      popMatrix();
    }
    popMatrix();
    rotation+= 0.0001;

    if (pv.z > zmax) {
      circles[i].z = zmin;
    }
  }
}
