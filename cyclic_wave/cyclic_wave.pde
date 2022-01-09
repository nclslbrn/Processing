float t, c;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

void draw() {
  if (recording) {
    result = new int[width*height][3];
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    c = 0;
    for (int sa=0; sa<samplesPerFrame; sa++) {
      t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
      draw_();
      loadPixels();
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += pixels[i] >> 16 & 0xff;
        result[i][1] += pixels[i] >> 8 & 0xff;
        result[i][2] += pixels[i] & 0xff;
      }
    }

    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = 0xff << 24 | 
        int(result[i][0]*1.0/samplesPerFrame) << 16 | 
        int(result[i][1]*1.0/samplesPerFrame) << 8 | 
        int(result[i][2]*1.0/samplesPerFrame);
    updatePixels();

    saveFrame("records/frame-###.gif");
    if (frameCount==numFrames)
      exit();
  } else if (preview) {
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    t = (millis()/(20.0*numFrames))%1;
    draw_();
  } else {
    t = mouseX*1.0/width;
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    draw_();
  }
}

//////////////////////////////////////////////////////////////////////////////
int[][] result;

int samplesPerFrame = 2,
    numFrames = 60; // animation loop duration (in frame)   

float shutterAngle = 0.5;

boolean recording = true,
        preview = true;

OpenSimplexNoise noise;
ArrayList<EllipseSection> arcs = new ArrayList<EllipseSection>(); // Custom arc class
PVector center; //  center of circle

int   margin         = 16,   // margin between circle
      noiseScale     = 24,  
      noiseRadius    = 4,
      noiseStrength  = 32,
      lineSize       = 3;
      

float speed,      // the value wich increments circle's radiuses
      maxRadius;               // Limit the size of the arc circle


float getNoiseIntensity(float x, float y, float t ) {
  
  return noise(
    x / noiseScale,
    y / noiseScale,
    noiseRadius * t
  ) * noiseStrength;
}

void setup() {
  //fullScreen(P3D);
  size(800, 800, P3D);
  //smooth(20);

  noise = new OpenSimplexNoise();
  center = new PVector( width/2, height/2 );
  maxRadius = width/1.75;
  speed     = (maxRadius-margin) / numFrames;

  for( int c = margin; c <= maxRadius; c += margin ) {

    EllipseSection newArc;
    newArc = new EllipseSection(c, 0, new FloatList(), center);
    newArc.init();
    arcs.add( newArc );
  }

}

void draw_() {

  background(0);
  
  pushMatrix();
  translate(center.x, center.y, -height/2);
  rotateX(PI/3);

  for( int arcID = 0; arcID < arcs.size(); arcID++ ) {

    EllipseSection arc = arcs.get(arcID);
    float currentAngle = arc.initialAngle;

    for( int angleID = 0; angleID < arc.angles.size() - 1; angleID+= 2 ) {
      
      float stroke = map(arc.radius, 0, maxRadius, 255, 1 );
      float weight = map(arc.radius, 0, maxRadius, 0.1, 4 );

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
      beginShape();
      for( float d = 0; d < distance; d+= lineSize ) {

        float ratio = d / distance;

        float x = startPoint.x + (endPoint.x - startPoint.x) * ratio;
        float y = startPoint.y + (endPoint.y - startPoint.y) * ratio;
        
        float pointNoise = getNoiseIntensity( x, y, t );

        curveVertex(
          x + noiseRadius * cos( pointNoise ),
          y + noiseRadius * sin( pointNoise )
        );


      }
      endShape(CLOSE);
      currentAngle = end;
    }


    if( arc.radius >= maxRadius) {

      if( arcID != 1 ) {

        arc.radius = margin;

      }
      
    } else {

      arc.radius += speed;
    } 
  }
  popMatrix();
}
