OpenSimplexNoise noise;

int ellipseNum     = 64,
    animFrame      = 64,
    noiseScale     = 18,
    noiseRadius    = 4;

float[] ellipses;

float dotsMargin     = 0.045,
      step           = 1,
      fieldIntensity = 1.5,
      minRadius,
      maxRadius,
      centX,
      centY;

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
  size(800, 800, P3D);
  strokeWeight(1);
  stroke(255);

  noise = new OpenSimplexNoise();

  minRadius = 12;
  maxRadius = width/1.35;
  centX = width/2;
  centY = height/2;      
  
  ellipses = new float[ellipseNum];

  for( int i = 0; i < ellipseNum; i++ ) {
    ellipses[i] = map(i, 0, ellipseNum-1, minRadius, maxRadius);
  }
}

void draw() {
 
  background(0);
  float t;

  if( frameCount < animFrame ) {
    t = map(frameCount, 0, animFrame, 0.0, 1.0);
  } else {
    t = map(frameCount%animFrame, 0, animFrame, 0.0, 1.0);
  }

  pushMatrix();
  translate(width/2, height/2);
  rotateX(QUARTER_PI);
  translate(-width/2, -height/3.5, height/6);

  for( int i = 0; i < ellipseNum; i++ ) {
    
    ellipses[i] -= step;
    
    for( float p = 0; p <= TWO_PI; p+= dotsMargin ) {
      
      PVector point = new PVector(
        centX + ellipses[i] * cos(p),
        centY + ellipses[i] * sin(p)
      );

      float depth = (ellipses[i] / maxRadius) * noiseRadius;
      
      float noiseIntensity = (float) noise.eval(
        point.x / noiseScale, 
        point.y / noiseScale, 
        noiseRadius * cos(TWO_PI * t), 
        noiseRadius * sin(TWO_PI * t)
      )* fieldIntensity;

      point(
        point.x + noiseScale * cos(noiseIntensity),
        point.y + noiseScale * sin(noiseIntensity),
        depth * ease(noiseIntensity)
      );
    }
    
    if( ellipses[i] - step < minRadius) {
      ellipses[i] = maxRadius;
    }
  }
  popMatrix();
  
}