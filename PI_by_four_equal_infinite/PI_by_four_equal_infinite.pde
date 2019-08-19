
float gold = 1.618033;
int   pointSpeed = 128;
int   animCount  = 56;

PVector[] circleCenter;
PVector[] infinitePoints;
int   pointPerCircle;
int   totalPoint;
int   animPointSum;
float mainCircleRadius;
float mainCircleAngleStep;

void setup() {
  size(800, 800);
  fill(255);
  noStroke();
  ellipseMode(CENTER);

  mainCircleRadius = width/6;
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
  background(0);
  println(infinitePoints.length );
  println(totalPoint);
}

void draw() {

  float speed = frameCount <= pointSpeed ? 
    1.0*(frameCount-1)/pointSpeed
    :
    (1.0* (frameCount % pointSpeed)) / pointSpeed;

  float lenght = frameCount <= animCount ? 
    1.0*(frameCount-1)/animCount
    :
    (1.0* (frameCount % animCount)) / animCount;

  fill(0, 0, 0, lenght*255);
  rect(0, 0, width, height);
  
  
  fill(255);
  int pointId = (int) map(speed, 0, 1, 0, totalPoint );
  println(pointId);
  ellipse(infinitePoints[pointId].x, infinitePoints[pointId].y, 10, 10);


  int pointCount;

  if( lenght <= 0.5) {
    pointCount = (int) map( lenght, 0, 0.5, 1, infinitePoints.length-1 );
  }else {
    pointCount = (int) map( lenght, 0.5, 1, infinitePoints.length-1, 1 );
  }

  for( int p = 0; p <= pointCount; p++ ) {
    
    int newPointId = pointId - p;
    if(newPointId <= 0 ) {
      newPointId = (infinitePoints.length-1) - newPointId;
    }
    /*
    println(pointId - p + " => " + newPointId );
    if( infinitePoints[newPointId] != null ) {
      ellipse(infinitePoints[newPointId].x, infinitePoints[newPointId].y, 1, 1);
    } else {
      println( newPointId );
    }
   */ 
  }
}