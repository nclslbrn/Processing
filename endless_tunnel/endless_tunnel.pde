PFont      font;
//  Set language here (fr, en, sp, de)
String     language = "fr"; 
StringDict sentences;
String     sentence;

float // radius of circle
      radius              = 120,
      // percent of probability that the tunnel will turn
      rotationProbability = 0.75,
      // speed of every rotation
      rotationSpeed       = 0.00025,
      // angle of x and y rotation
      rotationAngle       = TWO_PI,
      rotate_x            = 0,
      rotate_y            = 0,
      rotate_z            = 0,
      zstep, 
      zmin,
      zmax,
      arcWidth,
      tunnelSize;

int // number of points draw along the circle
    pointPerCircle = 4, // need to be > 3
    // define ellipse and text size
    pointSize      = 36,
    // number of tunnel section (depends of sentene lenght)
    nb;

boolean isRotating = false;

PVector[] circles;
PVector[] circlesLeft;
PVector[] circlesRight;
PVector[] circlesTop;
PVector[] circlesBottom;


// Array of axis (left, right, top, bottom)
char[] axes = { 'l', 'r', 't', 'b' };
char[] text;

char randomAxe = 'd';

void setup() {
  //fullScreen(P3D);
  size(1280, 720, P3D);
  textAlign(CENTER, CENTER);
  
  font = loadFont("Novecentosanswide-Bold-99.vlw");

  sentences = new StringDict();
  sentences.set("fr", "jusqu'ici tout va bien, ");
  sentences.set("en", "so far so good, ");
  sentences.set("sp", "hasta ahora todo bien, ");
  sentences.set("de", "so weit, so gut, ");

  sentence = sentences.get(language); 
  
  zmin = width * -0.5;
  zmax = width * 0.5;
  nb   = sentence.length();

  circles       = new PVector[nb];
  circlesLeft   = new PVector[nb];
  circlesRight  = new PVector[nb];
  circlesTop    = new PVector[nb];
  circlesBottom = new PVector[nb];
  text          = new char[nb];
  tunnelSize    = (zmin - zmax) * -1;
  arcWidth      = tunnelSize/nb;
  zstep         = (tunnelSize/nb) / 15;

  for (int i = 0; i < nb; i++) {

    float z     = map(i, 0, nb, zmax, zmin);

    float angle, scale;
 
    if( i < nb / 2 ) {
      angle = map(i, 0, nb/2, 0, rotationAngle);
      scale = map(i, 0, nb/2, 0, radius);
    } else {
      angle = map(i, nb/2, nb, rotationAngle, 0);
      scale = map(i, nb/2, nb, radius, 0);
    }

    text[i]         = sentence.charAt(i);
    circles[i]      = new PVector(width/2, height/2, z);
    
    circlesLeft[i] = new PVector( 
      width/ 2 + (scale * cos(angle)), 
      height/2,
      z + (zstep * sin(angle))
    );

    circlesRight[i] = new PVector(
      width/2 - (scale * sin(angle)),
      height/2,
      z + (zstep * cos(angle))
    );

    circlesTop[i] = new PVector(
      width/2,
      height/2 + (scale * cos(angle)),
      z + (zstep * sin(angle))
    );

    circlesBottom[i] = new PVector(
      width/2,
      height/2 - (scale * sin(angle)),
      z + (zstep * cos(angle))
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
      rotate_x += rotationSpeed;
      if( rotate_x - rotationSpeed > 0 ) isRotating = false;
      break;

    case 'r':
      currentCircle = circlesRight;
      rotate_x -= rotationSpeed;
      if( rotate_x - rotationSpeed < 0 ) isRotating = false;
      break;

    case 't':
      currentCircle = circlesTop;
      rotate_y += rotationSpeed;
      if( rotate_y - rotationSpeed > 0 ) isRotating = false;
      break;

    case 'b':
      currentCircle = circlesBottom;
      rotate_y -= rotationSpeed;
      if( rotate_y - rotationSpeed < 0 ) isRotating = false;
      break;

    default:
      currentCircle = circles;
      isRotating = false;
      rotate_x = rotate_y = 0;
      break;
  }
   
  
  for (int i = 0; i < nb; i++) {

    float ease = 0;
    pv = currentCircle[i];
    
    if( i < nb*0.125) {
      ease = map(i, 0, nb*0.125, 1.0, 0.0);
    }
    if( i > nb*0.875) {
      ease = map(i, nb*0.875, nb, 0.0, 1.0);
    }
    if( i < nb*0.125 || i > nb*0.875 ) {
      pv.lerp(circles[i], ease);
    }
    pv.z = currentCircle[i].z;
    pv.z += zstep;

    float r = map(pv.z, zmin, zmax, radius*.1, radius);
    float arcSize = (PI * (2 * r) / pointPerCircle)* 0.85;
    float medianSize = sqrt( (sq(r) - sq(arcSize/2)) );
    float middleZ = arcWidth /2;
    
    int stroke = (int) map(pv.z, zmin, zmax, 10, 255);

    float ellipeSize = r / pointSize;

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
        rotateY(HALF_PI - rotate_y);
        rotateX(PI - rotate_y);
        text(text[i], 0, 0, 0);
      popMatrix();


    }
    popMatrix();


    if (pv.z > zmax) {
      
      currentCircle[i].z = zmin;
      
    }
    
    if( rotate_z - rotationSpeed > TWO_PI ) {

      if( random(1) < rotationProbability & !isRotating ) {

        randomAxe = axes[ (int) random( axes.length )];

        switch( randomAxe ) {
      
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
      println("randomAxe: "+randomAxe);

      rotate_z = 0;
    
    } else {

      rotate_z += rotationSpeed;
    
    }
  }
  //saveFrame("records/frame-###.jpg");
}
