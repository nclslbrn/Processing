/**
 * Inpired by Daniel Shuffman and Etienne Jacob works
 *
 * Agents from Ianis Lallemand 
 * https://github.com/ianisl/workshop-processing-paris-2015/
 * OpenSimplexNoise from 
 */

OpenSimplexNoise noise;

ArrayList<PVector> circlePoints = new ArrayList<PVector>();
ArrayList<Agent> agents;

boolean recording   = true;

int rototionTiming  = 64,
    rotationStart   = 0,
    border          = 5,
    margin          = 10,
    initBrightness  = 75,
    radius,
    circunference, 
    centX, 
    centY, 
    agentCount, 
    outsideAgentCount;

float agentSize      = 1,
      agentAlpha     = 120,
      agentStepSize  = 6,
      fieldIntensity = 12,
      noiseScale     = 400,
      angle,
      seed,
      phase,
      t;



void setup() {
  fullScreen();
  strokeWeight(agentSize);

  //size(1280, 750);
  
  
  //noise = new OpenSimplexNoise();

  radius = ceil( width / 7);
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
      a.brightness = initBrightness;
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
  

  for (Agent a : agents) {
    
    t = map( frameCount, rotationStart, rotationStart + rototionTiming, 0.0, 1.0);
    
    a.angle = getNoiseIntensity(a.position, t);
    
    if(
         a.position.x < margin 
      || a.position.x > width-margin 
      || a.position.y < margin 
      || a.position.y > height-margin 
    ) {

      PVector randomPos = getRandomPointFromCircle(circlePoints);

      float noiseIntensity = getNoiseIntensity( randomPos, t);

      a.position.x = randomPos.x + random(radius) * cos(a.angle);
      a.position.y = randomPos.y + random(radius) * sin(a.angle);
      a.brightness = initBrightness;
      a.previousPosition.x = a.position.x;
      a.previousPosition.y = a.position.y;

      a.stepSize = agentStepSize;
      a.angle = random(2 * PI);
      outsideAgentCount++;

    } else {

      a.updatePosition();
      if( a.brightness < 255 ) a.brightness += 10;

    }
  }
}


void draw() {

  
  t = map( frameCount, rotationStart, rotationStart + rototionTiming, 0.0, 1.0);
  
  mooveAgents();
  background(0);

  for (Agent a : agents){

    stroke(a.brightness, agentAlpha);
    line(a.previousPosition.x, a.previousPosition.y, a.position.x, a.position.y);
  }
  
  if( frameCount >= rotationStart + rototionTiming ) {
    rotationStart = frameCount;
  }
  
  if( mousePressed == true ) {
     exit(); 
  }
  phase += 0.001;
  seed  += 0.015;
}

float getNoiseIntensity(PVector position, float t ) {
  return (float) noise(
    (position.x + phase) / noiseScale,
    (position.y + phase) / noiseScale,
    seed
  ) * fieldIntensity;
}


PVector getRandomPointFromCircle( ArrayList<PVector> circlePoints ) {

  int randomInt = (int) random( circlePoints.size() );
  return circlePoints.get(randomInt);
}
