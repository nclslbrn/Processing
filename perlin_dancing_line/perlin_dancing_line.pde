int noiseScale  = 260,
    noiseRadius = 8,
    pointNum    = 8,
    animFrame   = 260;

float threshold = .9,
      fieldIntensity = 5,
      zOffstet  = 0;

PVector[] points;

float noiseIntensity( PVector point, float zOffstet ) {

  return noise(
        point.x  / noiseScale,
        point.y  / noiseScale,
        zOffstet
      ) * fieldIntensity;
}

void setup() {

    size(800, 800);
    strokeWeight(1);
    stroke(255);
    noFill();

}
void draw() {
    
    background(0);
    
    float t;

    if (frameCount < animFrame) {
        t = map(frameCount, 0, animFrame, 0.0, 1);
    } else {
        t = map(frameCount % animFrame, 0, animFrame, 0.0, 1);
    }

    float _a = t * TWO_PI;
    pushMatrix();
    translate(width/2, height/2);
         
    beginShape();
    for (float a = 0; a < TWO_PI; a += radians(5)) {

        float xoff = map(cos(a + _a), -1, 1, 0, noiseScale);
        float yoff = map(sin(a + _a), -1, 1, 0, noiseScale);
        float r = map(noise(xoff, yoff, t), 0, 1, 100, height / 4);
        float x = r * cos(a);
        float y = r * sin(a);
        vertex(x, y);
    }
    endShape(CLOSE);
    popMatrix();
    zOffstet += 0.001;
}
