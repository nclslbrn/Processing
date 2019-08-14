PFont font;
String language = "fr"; // <-- Set language here (fr, en, sp, de)

StringDict sentences;
String sentence;

float zDist = 36, 
      zstep = 1.5, 
      rad = 120,
      rotationProbability = 0.5,
      globalRotationIncrement = 0.0001,
      rotate_x = 0,
      rotate_y = 0,
      rotate_z = 0,
      zmin,
      zmax,
      arcWidth,
      tunnelSize;

int animCount = 0,
    pointPerCircle = 5,
    pointSize = 36,
    nb;

boolean isRotating = false;

PVector[] circles;
PVector[] circlesLeft;
PVector[] circlesRight;
PVector[] circlesTop;
PVector[] circlesBottom;

char[] axes = { 'd', 'l', 'r', 't', 'b' };
char[] text;

char randomAxe = 'd'; 


void setup() {
  fullScreen(P3D);
  //size(720, 450, P3D);
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

  
  zmin = width * -0.3;
  zmax = width * 0.5;
  nb = sentence.length();


  circles = new PVector[nb];
  circlesLeft = new PVector[nb];
  circlesRight = new PVector[nb];
  circlesTop = new PVector[nb];
  circlesBottom = new PVector[nb];
  text = new char[nb];

  int c = 0;

  for (int i = 0; i < nb; i++) {

    text[i] = sentence.charAt(i);

    circles[i] = new PVector(width/2, height/2, map(i, 0, nb, zmax, zmin));
    
  }
  arcWidth = circles[1].z - circles[0].z;
  tunnelSize = arcWidth * sentence.length();
  
  float verticalRadius = sqrt( sq( tunnelSize ) + sq( width/2 ) );
  float horizontalRadius = sqrt( sq( tunnelSize) + sq( height/2) );

  for( int i = 0; i < nb; i++ ) {

    float z = map(i, 0, nb, zmax, zmin);
    float angle = TWO_PI / nb * i;

    circlesLeft[i] = new PVector( 
      width/2 + arcWidth * cos(angle), 
      height/2,
      z + arcWidth * sin(angle)
    );

    circlesRight[i] = new PVector(
      width/2 - arcWidth * sin(angle),
      height/2,
      z + arcWidth * cos(angle)
    );

    circlesTop[i] = new PVector(
      width/2,
      height/2 + arcWidth * cos(angle),
      z + arcWidth * sin(angle)
    );

    circlesBottom[i] = new PVector(
      width/2,
      height/2 - arcWidth * sin(angle),
      z + arcWidth * cos(angle)
    );
  }
}

void draw() {

  background(10);
  PVector pv;
  PVector[] currentCircle;
  
  float angle = TWO_PI / pointPerCircle;
  
  switch( randomAxe ) {
    case 'd':
      currentCircle = circles;
      rotate_x = rotate_y = 0;
      isRotating = false;
      break;
    case 'l':
      currentCircle = circlesLeft;
      rotate_x += globalRotationIncrement;
      if( rotate_x > 0 ) isRotating = false;
      break;
    case 'r':
      currentCircle = circlesRight;
      rotate_x -= globalRotationIncrement;
      if( rotate_x < 0 ) isRotating = false;
      break;
    case 't':
      currentCircle = circlesTop;
      rotate_y += globalRotationIncrement;
      if( rotate_y > 0 ) isRotating = false;
      break;
    case 'b':
      currentCircle = circlesBottom;
      rotate_y -= globalRotationIncrement;
      if( rotate_y < 0 ) isRotating = false;
      break;
    default:
      currentCircle = circles;
      isRotating = false;
      rotate_x = rotate_y = 0;
      break;
  }
  for (int i = 0; i < nb; i++) {

    pv = currentCircle[i];
    pv.z += zstep;

    float r = map(pv.z, zmin, zmax, rad*.1, rad);
    float arcSize = PI * (2 * r) / pointPerCircle;
    float medianSize = sqrt( (sq(r) - sq(arcSize/2)) );
    float middleZ = arcWidth /2;
    
    int stroke = (int) map(pv.z, zmin, zmax, 10, 255);

    float ellipeSize = r / pointSize;

    //pv.x = pv.x * acos(radians(45-x_rotation));

    stroke(stroke);
    fill(stroke); 
    pushMatrix();
    translate(pv.x, pv.y, pv.z);
          
    rotateX(rotate_x);
    rotateY(rotate_y);
    rotateZ(rotate_z);

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
      
      currentCircle[i].z = zmin + zstep;
      animCount++;
      
      if( random(1) < rotationProbability & !isRotating ) {

        randomAxe = axes[ (int) random( axes.length )];
        println("randomAxe: "+randomAxe);
        switch( randomAxe ) {
          case 'd':
            rotate_x = rotate_y = 0;
            isRotating = false;
            break;
          case 'l':
            rotate_x = -TWO_PI;
            rotate_y = 0;
            isRotating = true;
            break;
          case 'r':
            rotate_x = TWO_PI;
            rotate_y = 0;
            isRotating = true;
            break;
          case 't':
            rotate_x = 0;
            rotate_y = -TWO_PI;
            isRotating = true;
            break;
          case 'b':
            rotate_x = 0;
            rotate_y = TWO_PI;
            isRotating = true;
            break;
          default:
            rotate_x = rotate_y = 0;
            isRotating = false;
            break;
        }
      } else {
        randomAxe = 'd';
      }
    }
    
    rotate_z += globalRotationIncrement;

    if( rotate_z == TWO_PI || 
      ( rotate_z % TWO_PI == 0 && rotate_z != 0) 
    ) {
      //saveFrame("records/frame-###.jpg");
     // exit();
    } else {
      saveFrame("records/frame-###.jpg");
    }
  }
  

 
}
