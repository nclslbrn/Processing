/**
 * Inpired by Daniel Shuffman and Etienne Jacob works
 *
 * Agents from Ianis Lallemand 
 * https://github.com/ianisl/workshop-processing-paris-2015/
 * OpenSimplexNoise from 
 */

OpenSimplexNoise noise;

int radius, circunference, centX, centY, agentCount, outsideAgentCount;
boolean recording = true;

int rototionTiming = 1024;
int rotationStart = 0;
float angle, t;
int border = 5;
int margin = 10;

float agentSize = 1;
float agentAlpha = 90;
float agentStepSize = 6;

float fieldIntensity = 12;
float noiseScale = 600;

ArrayList<PVector> circlePoints = new ArrayList<PVector>();
ArrayList<Agent> agents;


void setup() {

  size(1280, 750);
  stroke(255, agentAlpha);
  strokeWeight(agentSize);
  
  noise = new OpenSimplexNoise();

  radius = ceil( width / 5);
  centX = width / 2;
  centY = height / 2;

  init();
}

void init() {

  agents = new ArrayList<Agent>();

  for( int b = 0; b < border; b++ ) {

    circunference = (int) TWO_PI * radius * 2;
    angle = TWO_PI / circunference;

    for( int r = 0; r < circunference; r++ ) {
      
      int x = centX + (int) ( radius * sin(angle*r) );
      int y = centY + (int) ( radius * cos(angle*r) );
      circlePoints.add(new PVector(x, y));

      Agent a = new Agent();
      a.stepSize = agentStepSize;
      a.position = new PVector(x, y);
      a.isPositionResetWhenOutside = false;
      agents.add(a);
    }
    radius--;
  }
  agentCount = circlePoints.size();

  if( recording ) {
    while( outsideAgentCount < agentCount ) {
      mooveAgents();
      rotationStart = frameCount;
    }
  }
}


void mooveAgents() {
  
  //t = outsideAgentCount % agentCount / agentCount;

  for (Agent a : agents) {
    
    t = map( frameCount, rotationStart, rotationStart+ rototionTiming, 0.0, 1.0);
    
    //t = map(outsideAgentCount%(agentCount*4), 0, agentCount*4, 0.0, 1.0);

    a.angle = getNoiseIntensity(a.position, t);
    
    if(
         a.position.x < margin 
      || a.position.x > width-margin 
      || a.position.y < margin 
      || a.position.y > height-margin 
    ) {

      PVector randomPos = getRandomPointFromCircle(circlePoints);
  
      a.position.x = randomPos.x;
      a.position.y = randomPos.y;
      
      a.previousPosition.x = randomPos.x;
      a.previousPosition.y = randomPos.y;

      a.stepSize = agentStepSize;
      a.angle = random(2 * PI);
      outsideAgentCount++;

    } else {
     
      a.updatePosition();

    }
  }
}


void draw() {

  background(0);
  mooveAgents();


  for (Agent a : agents){
    line(a.previousPosition.x, a.previousPosition.y, a.position.x, a.position.y);
  }

  if (outsideAgentCount <= agentCount*26 && recording) {
      saveFrame("records/frame-###.jpg");
  }

  if (outsideAgentCount == agentCount*26 && recording ) {
    exit();
  }

  if( frameCount >= rotationStart+ rototionTiming ) {
    rotationStart = frameCount;
  }

}
float getNoiseIntensity(PVector position, float t ) {
  return (float) noise.eval(
    position.x / noiseScale,
    position.y / noiseScale,
    agentStepSize * cos( TWO_PI * t),
    agentStepSize * sin( TWO_PI * t)
  ) * fieldIntensity;
}


PVector getRandomPointFromCircle( ArrayList<PVector> circlePoints ) {

  int randomInt = (int) random( circlePoints.size() );
  return circlePoints.get(randomInt);
}
