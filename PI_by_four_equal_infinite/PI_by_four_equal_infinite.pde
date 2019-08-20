
PVector[] circleCenter, infinitePoints;

int   pointSpeed = 64,
      animCount  = 156,
      pointPerCircle,
      totalPoint,
      animPointSum;

float splitProbabity = 0.5,
      gridCircleRadius,
      mainCircleRadius,
      mainCircleAngleStep;


void setup() {

  size(800, 800, P3D);
  fill(255);
  noStroke();
  ellipseMode(CENTER);

  mainCircleRadius = width/6;
  gridCircleRadius = mainCircleRadius / 4;

  pointPerCircle = (int) (2 * PI * mainCircleRadius);
  circleCenter = new PVector[2];
  circleCenter[0] = new PVector(width*0.333333333, height/2);
  circleCenter[1] = new PVector(width*0.666666666, height/2);

  totalPoint = (pointPerCircle * circleCenter.length)-1;
  infinitePoints = new PVector[totalPoint];

  float circleAngleStep = TWO_PI/(pointPerCircle-1);
  int pointNum = 0;
  
  for( float angle = 0; angle >= (TWO_PI)*-1; angle-= circleAngleStep ) {
    PVector start = new PVector(
      circleCenter[0].x + mainCircleRadius * cos(angle),
      circleCenter[0].y + mainCircleRadius * sin(angle)
    );
    infinitePoints[pointNum] = new PVector(start.x, start.y);
    pointNum++;
  }

  for( float angle = PI; angle <= TWO_PI+ PI; angle+= circleAngleStep ) {
    PVector start = new PVector(
      circleCenter[1].x + mainCircleRadius * cos(angle),
      circleCenter[1].y + mainCircleRadius * sin(angle)
    );
    infinitePoints[pointNum] = new PVector(start.x, start.y);
    pointNum++;
  }
}

void draw() {
  background(0);
  fill(255);

  float speed = frameCount <= pointSpeed ? 
    1.0*(frameCount-1)/pointSpeed
    :
    (1.0* (frameCount % pointSpeed)) / pointSpeed;

  float lenght = frameCount <= animCount ? 
    1.0*(frameCount-1)/animCount
    :
    (1.0* (frameCount % animCount)) / animCount;

  int pointId = (int) map(speed, 0, 1, 0, totalPoint );

  int pointCount;

  if( lenght <= 0.5) {
    pointCount = (int) map( lenght, 0, 0.5, 1, infinitePoints.length-1 );
  }else {
    pointCount = (int) map( lenght, 0.5, 1, infinitePoints.length-1, 1 );
  }

  float xCount = 1;
  float yCount = 1;

 
  for( int p = 0; p <= pointCount; p++ ) {
    
    int newPointId = pointId - p;
    if(newPointId < 0 ) {
      newPointId = (infinitePoints.length-1) + newPointId;
    }

    ellipse(
      infinitePoints[newPointId].x,
      infinitePoints[newPointId].y, 
      6,
      6
    );
    if( p == pointCount ) saveFrame("records/frame-###.jpg");
  }
}
