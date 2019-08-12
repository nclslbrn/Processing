PFont font;

StringDict sentences;
String language = "fr"; // <-- Set language here (fr, en, sp, de)
String sentence;

float zDist = 36, 
      zstep = 1.5, 
      rad = 120,
      rotationProbability = 0.15,
      globalRotationIncrement,
      zmin,
      zmax,
      arcWidth,
      tunnelSize,
      globalXRotation,
      globalYRotation,
      globalZRotation;

int animCount = 0,
    pointPerCircle = 8,
    pointSize = 36,
    nb;

boolean isRotating = false;

PVector[] circles;
char[] text;

void setup() {
  //fullScreen(P3D);
  size(640, 640, P3D);
  textAlign(CENTER, CENTER);
  //noLoop();
  
  font = loadFont("Novecentosanswide-Bold-99.vlw");
  //font = loadFont("InterUI-Bold-99.vlw");

  sentences = new StringDict();
  sentences.set("fr", "jusqu'ici tout va bien, ");
  sentences.set("en", "so far so good, ");
  sentences.set("sp", "hasta ahora todo bien, ");
  sentences.set("de", "so weit, so gut, ");

  sentence = sentences.get(language); 

  
  zmin = width * -0.8;
  zmax = width * 0.8;
  nb = sentence.length();

  circles = new PVector[nb];
  text = new char[nb];

  int c = 0;

  for (int i = 0; i < nb; i++) {
    
    text[i] = sentence.charAt(i);
    circles[i] = new PVector(0, 0, map(i, 0, nb, zmax, zmin));
  }
  arcWidth = circles[1].z - circles[0].z;
  tunnelSize = arcWidth * sentence.length();
  globalRotationIncrement = .01;
  println(globalRotationIncrement + "/360" );
}

void draw() {

  background(10);
  PVector pv;
  float angle = TWO_PI / pointPerCircle;
  for (int i = 0; i < nb; i++) {

    pv = circles[i];
    pv.x = width/2 + random(-1, 1);
    pv.y = height/2+ random(-1, 1);
    pv.z += zstep;

    float r = map(pv.z, zmin, zmax, rad*.1, rad);
    float arcSize = PI * (2 * r) / pointPerCircle;
    float medianSize = sqrt( (sq(r) - sq(arcSize/2)) );
    float middleZ = arcWidth /2;
    
    int stroke = (int) map(pv.z, zmin, zmax, 50, 255);

    float ellipeSize = r / pointSize;

    stroke(stroke);
    fill(stroke); 
    pushMatrix();
    translate(pv.x, pv.y, pv.z);
    rotateX(globalXRotation);
    rotateY(globalYRotation);
    rotateZ(radians(globalZRotation));

    for( int p = 1; p <= pointPerCircle; p++ ) {
      
      float halfAngle = angle/2;
      float thirdAngle = angle/3;

      float x = r * cos(angle*p);
      float y = r * sin(angle*p);

      float _x = r * cos(angle*(p+1));
      float _y = r * sin(angle*(p+1));
    
      float x_first_third = medianSize * cos(thirdAngle+(angle*p));
      float y_first_third = medianSize * sin(thirdAngle+(angle*p));

      float x_last_third = medianSize * cos((thirdAngle*2)+(angle*p));
      float y_last_third = medianSize * sin((thirdAngle*2)+(angle*p));

      float middleX = medianSize * cos(halfAngle+(angle*p));
      float middleY = medianSize * sin(halfAngle+(angle*p));
      
      float textRotZ = angle*p + angle/2;
      
      ellipse(x, y, ellipeSize, ellipeSize);
      
      line(x, y, 0, x, y, arcWidth);
      line(x, y, 0, _x, _y, 0);
      line(x_first_third, y_first_third, 0, x_first_third, y_first_third, arcWidth);
      line(x_last_third, y_last_third, 0, x_last_third, y_last_third, arcWidth);

      textFont(font, ellipeSize * 10);

      pushMatrix();
      translate(middleX, middleY, middleZ );
           
      rotateZ(textRotZ);
      rotateY(HALF_PI);
      rotateX(PI);
      //debug: ellipse(0, 0, ellipeSize, ellipeSize);
      text(text[i], 0, 0, 0);
      popMatrix();
    
    }
    popMatrix();

    if (pv.z > zmax) {
      circles[i].z = zmin + zstep;
      animCount++;
    }
    
    globalZRotation+= globalRotationIncrement;
    println(globalZRotation);
    if( globalZRotation == 360 || globalZRotation % 360 == 0 ) {
      //saveFrame("records/frame-###.jpg");
      println("loop");
      exit();
    } else {
    //saveFrame("records/frame-###.jpg");
    }
  }
  

 
}
