int noiseScale  = 512,
    noiseRadius = 256,
    animFrame   = 260,
    pointNum    = 16;

float threshold = .9,
      fieldIntensity = 1,
      zOffstet  = 0,
      precision = 2,
      currentNoiseValue  = 0,
      angleStep = TWO_PI / 32;

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
    strokeWeight(1);
    colorMode(HSB, pointNum);
    stroke(255);
    noFill();

    for( int p = 0; p <= pointNum; p++ ) {
        
        PVector pos = new PVector( random(1)*width, random(1)*height );
        points.add(pos);

    }   
    
}
void draw() {
    
    background(0);    

    for( int p = 0; p <= pointNum; p++ ) {
        
        PVector startPos = points.get(p);
        fill(p, 100, 100); 
        beginShape();

        for( float angle = 0; angle < TWO_PI; angle += angleStep ) {
            
            PVector pos = new PVector(
                startPos.x + noiseRadius * cos(angle),
                startPos.y + noiseRadius * sin(angle)
            );
            
            float noiseValue = ease( noiseIntensity(pos, zOffstet) );
            vertex( 
                startPos.x + ((noiseRadius * noiseValue) * cos(angle)),
                startPos.y + ((noiseRadius * noiseValue) * sin(angle))
            );

        }
        endShape(CLOSE);
    }
    zOffstet += 0.003;
}
