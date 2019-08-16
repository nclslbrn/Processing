OpenSimplexNoise noise;
ArrayList<EllipseSection> arcs = new ArrayList<EllipseSection>(); // Custom arc class
PVector center; //  center of circle

int   margin         = 8,   // margin between circle
      numFrames      = 65, // animation loop duration (in frame)
      noiseScale     = 8,  
      noiseRadius    = 3,
      noiseStrength  = 4,
      lineSize       = 8;
      

float t              = 0,      // time of the current frame in the loop (percent)
      speed          = 2,      // the value wich increments circle's radiuses
      maxRadius;               // Limit the size of the arc circle

boolean recording = true;

float getNoiseIntensity(float x, float y, float t ) {
  
  return (float) noise.eval(
    noiseRadius * cos( TWO_PI * t),
    noiseRadius * sin( TWO_PI * t)
  ) * noiseStrength;
}

void setup() {
  //fullScreen(P3D);
  size(800, 800, P3D);

  noise = new OpenSimplexNoise();
  center = new PVector( width/2, height/2 );
  maxRadius = width/1.5;

  for( int c = margin; c <= maxRadius; c += margin ) {

    EllipseSection newArc;
    newArc = new EllipseSection(c, 0, new FloatList(), center);
    newArc.init();
    arcs.add( newArc );
  }

}

void draw() {

  background(0);
  float t = 1.0 * frameCount / numFrames;
  
  pushMatrix();
  translate(center.x, center.y, -height/2);
  rotateX(PI/3);

  for( int arcID = 1; arcID < arcs.size(); arcID++ ) {

    EllipseSection arc = arcs.get(arcID);
    float currentAngle = arc.initialAngle;

    for( int angleID = 0; angleID < arc.angles.size() - 1; angleID+= 2 ) {
      
      float stroke = map(arc.radius, 0, maxRadius, 255, 75 );
      float weight = map(arc.radius, 0, maxRadius, 0.1, 1.5 );

      float start = currentAngle + arc.angles.get( angleID );
      float end   = currentAngle + arc.angles.get( angleID + 1 );

      PVector startPoint = new PVector(
        arc.radius * cos(start),
        arc.radius * sin(start)
      );
      
      PVector endPoint = new PVector(
        arc.radius * cos(end),
        arc.radius * sin(end)
      );

      float distance = startPoint.dist(endPoint);
      PVector currentPoint = startPoint;
      
      stroke(stroke);
      strokeWeight( weight );

      for( float d = 0; d <= distance; d+= lineSize ) {

        float ratio = d / distance;

        float x = startPoint.x + (endPoint.x - startPoint.x) * ratio;
        float y = startPoint.y + (endPoint.y - startPoint.y) * ratio;
        
        float pointNoise = getNoiseIntensity( x, y, t );

        line(
          currentPoint.x,
          currentPoint.y,
          x + noiseRadius * cos( pointNoise ),
          y + noiseRadius * sin( pointNoise )
        );


        currentPoint = new PVector(x, y);
      }
      currentAngle = end;
    }

    arc.radius += margin;

    if( arc.radius >= maxRadius ) {

      if( arcID == 1 ) {

        exit();
      
      } else {
        
        arc.radius = margin;
      }
    } 
  }
  popMatrix();
  if( recording ) saveFrame("records/frame-###.jpg");
}
