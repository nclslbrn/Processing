int noiseScale  = 120,
  noiseRadius = 64,
  animFrame   = 260,
  pointNum    = 24;

float fieldIntensity = 3,
  zOffstet  = 0,
  angleStep = TWO_PI / 16;

color[] jud_playground = {#f04924, #fcce09, #408ac9};
color backgroundColor = #ffffff;
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

  for( int p = 0; p <= pointNum; p++ ) {
    
    PVector pos = new PVector( 
      width/2 + random(-0.25, 0.25)*width, 
      width/2 + random(-0.25, 0.25)*height
    );
    points.add(pos);

  }   
  
}

void draw() {

  background(backgroundColor);  
  
  for( int p = 0; p <= pointNum; p++ ) {

    int color_id = p < jud_playground.length ? p : p % jud_playground.length;
    
    fill(jud_playground[color_id]);

    PVector startPos = points.get(p);
    beginShape(QUADS);

    for( float angle = 0; angle < TWO_PI; angle += angleStep ) {
        
      PVector pos = new PVector(
        startPos.x + noiseRadius * cos(angle),
        startPos.y + noiseRadius * sin(angle)
      );
      
      float noiseValue = ease( noiseIntensity(pos, zOffstet*p/pointNum) );
      vertex( 
        startPos.x + ((noiseRadius * noiseValue) * cos(angle + noiseValue)),
        startPos.y + ((noiseRadius * noiseValue) * sin(angle + noiseValue))
      );

    }
    endShape();
  }
  zOffstet += 0.01;

  if( mousePressed == true ) {
    saveFrame("records/frame-###.jpg");
  }
}
