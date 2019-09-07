
PVector[] circleCenter, infinitePoints;
float[] infiniteAngle;

int   pointSpeed = 64,
      animCount  = 256,
      cubeSize   = 48,
      pointPerCircle,
      totalPoint,
      animPointSum;

float splitProbabity = 0.5,
      cellSize,
      mainCircleRadius,
      mainCircleAngleStep;

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
  stroke(0);
  ellipseMode(CENTER);

  mainCircleRadius = width/6;
  cellSize = width/16;
  pointPerCircle = ceil((2 * PI * mainCircleRadius) / cubeSize);
  circleCenter = new PVector[2];
  circleCenter[0] = new PVector(width*0.333333333, height/2);
  circleCenter[1] = new PVector(width*0.666666666, height/2);

  totalPoint = (pointPerCircle * circleCenter.length) - 2;
  infinitePoints = new PVector[totalPoint];
  infiniteAngle = new float[totalPoint];

  float circleAngleStep = TWO_PI/(pointPerCircle-1);
  int pointNum = 0;
  
  for( float angle = 0; angle >= (TWO_PI)*-1; angle-= circleAngleStep ) {
    PVector start = new PVector(
      circleCenter[0].x + mainCircleRadius * cos(angle),
      circleCenter[0].y + mainCircleRadius * sin(angle)
    );
    infinitePoints[pointNum] = new PVector(start.x, start.y);
    infiniteAngle[pointNum] = angle;
    pointNum++;
  }

  for( float angle = PI; angle <= TWO_PI+ PI; angle+= circleAngleStep ) {
    PVector start = new PVector(
      circleCenter[1].x + mainCircleRadius * cos(angle),
      circleCenter[1].y + mainCircleRadius * sin(angle)
    );
    infinitePoints[pointNum] = new PVector(start.x, start.y);
    infiniteAngle[pointNum] = angle;
    pointNum++;
  }
}

void draw() {
  background(0);
  lights();
  ambientLight(255,255,255);
  
  float speed = frameCount <= pointSpeed ? 
    1.0*(frameCount-1)/pointSpeed
    :
    (1.0* (frameCount % pointSpeed)) / pointSpeed;

  float lenght = frameCount <= animCount ? 
    1.0*(frameCount-1)/animCount
    :
    (1.0* (frameCount % animCount)) / animCount;

  int pointId = (int) map(speed, 0, 1, 0, totalPoint );

  int pointCount = (int) map(
    lenght,
    (lenght < 0.5 ? 0   : 0.5),
    (lenght < 0.5 ? 0.5 : 1),
    (lenght < 0.5 ? infinitePoints.length/32 : infinitePoints.length-1),
    (lenght < 0.5 ? infinitePoints.length-1 : infinitePoints.length/32)
  );

  for( int p = 0; p <= pointCount; p++ ) {
    
    int newPointId = pointId - p;
    float fill = map( p, 0, pointCount, 204, 0);
    if(newPointId < 0 ) {
      newPointId = (infinitePoints.length-1) + newPointId;
    }
    
    fill( 46, fill, 113 );
    
    pushMatrix();
    
    translate(infinitePoints[newPointId].x, infinitePoints[newPointId].y);
    rotateX(cos(infiniteAngle[p]));
    rotateY(sin(infiniteAngle[p]));
    rotateZ( ease(p/pointCount) * PI);
    box(cubeSize);
    
    popMatrix();
    
    if( p == pointCount ) saveFrame("records/frame-###.jpg");
  }
  
}
