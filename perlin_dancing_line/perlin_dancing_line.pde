int noiseScale  = 200,
  noiseRadius = 460,
  animFrame   = 260,
  pointNum    = 6;

float fieldIntensity = 1,
  zOffstet  = 0,
  angleStep = TWO_PI / 84;

ArrayList<PVector> points = new ArrayList<PVector>();

float noiseIntensity( PVector point, float zOffstet ) {
  return noise(
      point.x  / noiseScale,
      point.y  / noiseScale,
      zOffstet
    ) * fieldIntensity;
}

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

void setup() {

  size(800, 800);
  noStroke();
  colorMode(HSB, pointNum);
  

  for( int p = 0; p <= pointNum; p++ ) {
    
    PVector pos = new PVector( 
      random(1)*width, 
      random(1)*height
    );
    points.add(pos);

  }   
  
}

void draw() {

  background(0);
  for( int p = 0; p <= pointNum; p++ ) {

    //fill( p % 2 == 0 ? 255 : 0);
    fill(p, 100, 100);

    PVector startPos = points.get(p);
    beginShape();

    for( float angle = 0; angle < TWO_PI; angle += angleStep ) {
        
      PVector pos = new PVector(
        startPos.x + noiseRadius * cos(angle),
        startPos.y + noiseRadius * sin(angle)
      );
      
      float noiseValue = ease( noiseIntensity(pos, zOffstet) );
      vertex( 
        startPos.x + ((noiseRadius * noiseValue) * cos(angle + noiseValue)),
        startPos.y + ((noiseRadius * noiseValue) * sin(angle + noiseValue))
      );

    }
    endShape(CLOSE);
  }
  zOffstet += 0.01;

  if( mousePressed == true ) {
    saveFrame("records/frame-###.jpg");
  }
}
