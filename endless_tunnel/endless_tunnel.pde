PFont      font;
//  Set language here (fr, en, sp, de)
String     language = "fr"; 
StringDict sentences;
String     sentence;

float // radius of circle
      radius              = 120,
      // percent of probability that the tunnel will turn
      rotationProbability = 0.5,
      // angle of x and y rotation
      rotationAngle       = HALF_PI,
      // speed of every rotation
      rotationSpeed       = 0.003,
      rotate_z,
      zstep, 
      zmin,
      zmax,
      arcWidth,
      tunnelSize;

int // number of points draw along the circle
    pointPerCircle = 5, // need to be > 3
    // define ellipse and text size (inverted value)
    pointSize      = 36,
    // rotate x and y count
    rotate_count = 0,
    // number of tunnel section (depends of sentence lenght)
    nb;

boolean recording = true;

PVector[] circles;
PVector[] circlesLeft;
PVector[] circlesRight;
PVector[] circlesTop;
PVector[] circlesBottom;

PVector[] futureCircle;
PVector[] currentCircle;
// Array of axis (left, right, top, bottom)
char[] axes = { 'l', 'r', 't', 'b' };
char[] text;

char randomAxe = 'd';

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}
float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

PVector[] newCircle( char randomAxe ) {
  
  PVector[] newCircle;
  
  switch( randomAxe ) {
    case 'd':
      newCircle = circles;
      break;
    case 'l':
      newCircle = circlesLeft;
      break;
    case 'r':
      newCircle = circlesRight;
      break;
    case 't':
      newCircle = circlesTop;
      break;
    case 'b':
      newCircle = circlesBottom;
      break;
    default:
      newCircle = circles;
      break;
  }
  return newCircle;
}

void setup() {
  fullScreen(P3D);
  //size(1280, 720, P3D);
  textAlign(CENTER, CENTER);
  
  font = loadFont("Novecentosanswide-Bold-99.vlw");

  sentences = new StringDict();
  sentences.set("fr", "jusqu'ici tout va bien, ");
  sentences.set("en", "so far so good, ");
  sentences.set("sp", "hasta ahora todo bien, ");
  sentences.set("de", "so weit, so gut, ");

  sentence = sentences.get(language); 
  
  zmin = -width * 0.3;
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
  zstep         = (tunnelSize/nb) / 26;
  

  for (int i = 0; i < nb; i++) {

    float z     = map(i, 0, nb-1, zmax, zmin);
    float angle = map(i, 0, nb-1, 0, rotationAngle);
    
    float scale;

    if( i < (nb-1) / 2 ) {
      scale = map(i, 0, (nb-1)/2, 0, radius);
    } else {
      scale = map(i, (nb-1)/2, nb-1, radius, 0);
    }

    text[i]         = sentence.charAt(i);
    circles[i]      = new PVector(width/2, height/2, z);
    
    circlesLeft[i] = new PVector( 
      width/ 2 + (scale * cos(angle)), 
      height/2,
      z + (arcWidth * sin(angle))
    );

    circlesRight[i] = new PVector(
      width/2 - (scale * sin(angle)),
      height/2,
      z + (arcWidth * cos(angle))
    );

    circlesTop[i] = new PVector(
      width/2,
      height/2 + (scale * cos(angle)),
      z + (arcWidth * sin(angle))
    );

    circlesBottom[i] = new PVector(
      width/2,
      height/2 - (scale * sin(angle)),
      z + (arcWidth * cos(angle))
    );
  
  }
  currentCircle = newCircle('d');
  futureCircle = newCircle('d');
}



void draw() {

  background(5);
  
  float angle = TWO_PI / pointPerCircle;
  
  for (int i = 0; i < nb; i++) {

    currentCircle[i].z += zstep;

    float ease = map( currentCircle[i].z, zmin, zmax, 0, 1);

    float r = ease(ease) * radius;
    float arcSize = (PI * (2 * r) / pointPerCircle)* 0.85;
    float medianSize = sqrt( (sq(r) - sq(arcSize/2)) );
    float middleZ = arcWidth /2;

    float stroke = ease(ease) * 255;

    float ellipeSize = r / pointSize;

    stroke(stroke);
    fill(stroke);
    pushMatrix();
    translate(currentCircle[i].x, currentCircle[i].y, currentCircle[i].z);
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

      if( i < nb-1) {
        line(x, y, 0, _x, _y, 0);
      }
      line(x_first_third, y_first_third, 0, x_first_third, y_first_third, arcWidth);
      line(x_last_third, y_last_third, 0, x_last_third, y_last_third, arcWidth);

      textFont(font, pointSize);

      pushMatrix();
        translate(middleX, middleY, middleZ );
        rotateZ(textRotZ);
        rotateY(HALF_PI );
        rotateX(PI);
        text(text[i], 0, 0, 0);
      popMatrix();


    }
    popMatrix();


    if ( currentCircle[i].z > zmax) {
      
      if( i == 0 ) {

        if( rotate_count == 0) {

          futureCircle = new PVector[nb];
          
          if( random(1) < rotationProbability ) {

            randomAxe = axes[ (int) random( axes.length )];
            futureCircle = newCircle( randomAxe );

          } else {

            randomAxe = 'd';
            futureCircle = newCircle( randomAxe );
          }
          println("New section: "+ randomAxe );
        }

        
        if( rotate_count == 2 ) {
          
          rotate_count = 0;

        } else {

          rotate_count++;

        } 
      } // i == 0


      if( rotate_count > 1 ) {
        currentCircle[i] = futureCircle[i];
      }
      currentCircle[i].z = zmin;
    }
  } 

  if( rotate_z + rotationSpeed >= TWO_PI ) {
    rotate_z = 0;

  } else {
    rotate_z += rotationSpeed;
  }
  if( recording) saveFrame("records/frame-###.jpg");
}
