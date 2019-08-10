PFont font;

float zDist = 36, 
      zstep = 1.8, 
      rad = 120,
      radFactor = 0.85,
      globalZIncrement = PI / 50000;

Boolean englishVersion = false;
Boolean firstFrameSaved = false;

String sentence;
String frenchSentence = "jusqu'ici tout va bien, ";
String englishSentence = "so far so good, ";

int animCount = 0;
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
    float arcSize = PI * (2 * r) / pointPerCircle;
   
    float medianSize = sqrt( (sq(r) - sq(arcSize/2)) );
    float arcWidth = zstep * nb;
    
    int stroke = (int) map(pv.z, zmin, zmax, 50, 255);

    float ellipeSize = r / pointSize;

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
    
      float x_first_third = medianSize * cos(thirdAngle+(angle*p)+rotation);
      float y_first_third = medianSize * sin(thirdAngle+(angle*p)+rotation);

      float x_last_third = medianSize * cos((thirdAngle*2)+(angle*p)+rotation);
      float y_last_third = medianSize * sin((thirdAngle*2)+(angle*p)+rotation);

      float middleX = medianSize * cos(halfAngle+(angle*p)+rotation);
      float middleY = medianSize * sin(halfAngle+(angle*p)+rotation);
      
      float textRotZ = angle*p + angle/2 + rotation;

      ellipse(x, y, ellipeSize, ellipeSize);
      
      line(x, y, 0, x, y, arcWidth);
      line(x, y, 0, _x, _y, 0);
      line(x_first_third, y_first_third, 0, x_first_third, y_first_third, arcWidth);
      line(x_last_third, y_last_third, 0, x_last_third, y_last_third, arcWidth);

      textFont(font, ellipeSize * 10);

      pushMatrix();
      translate(middleX, middleY, arcWidth/2 );
           
      rotateZ(textRotZ);
      rotateY(HALF_PI);
      rotateX(PI);
      //debug: ellipse(0, 0, ellipeSize, ellipeSize);
      text(text[i], 0, 0, 0);
      popMatrix();
    
    }
    popMatrix();
    rotation+= globalZIncrement;

    if (pv.z > zmax) {
      circles[i].z = zmin + zstep;
      animCount++;
    }
    if( rotation % PI == 0 ) {
      saveFrame("records/frame-###.jpg");
      println("loop");
    }

    /** Debug
    saveFrame("records/frame-###.jpg");
    exit();
  
    if( animCount >= sentence.length() ) {
      saveFrame("records/frame-###.jpg");
    }
    */
  }
}
