ArrayList<PVector> agentBorder = new ArrayList<PVector>();
ArrayList<Agent> agents;

int numFrame = 75,
    agenCount;
float agentStepSize = 6;

float waves_b , waves_e, waves_c, waves_f;
float popcorn_c , popcorn_f;

void setup() {
  size(800, 800);
  noStroke();
  background(0);

  agenCount = width*2 + height *2;

  init();
}

void init() {


  waves_b = random(-0.8, 0.8);
  waves_e = random(-0.8, 0.8);
  waves_c = random(-0.8, 0.8);
  waves_f = random(-0.8, 0.8);

  popcorn_c = random(-0.8, 0.8);
  popcorn_f = random(-0.8, 0.8);

  agents = new ArrayList<Agent>();
  for(int x = 0; x <= width; x++) {
    
    Agent a = b = new Agent();
    a.stepsize = b.stepsize = agentStepSize;
    a.isPositionResetWhenOutside = b.isPositionResetWhenOutside = false;
    a.brightness = b.brightness  = initBrightness;


    a.position = new PVector(x, 0);
    a.angle = HALF_PI;
    b.position = new PVector(x, height);
    b.angle = -HALF_PI;

    agents.add(a);
    agents.add(b);

  }
  for(int y = 0; y <= width; y++) {
    
    Agent a = b = new Agent();
    a.stepsize = b.stepsize = agentStepSize;
    a.isPositionResetWhenOutside = b.isPositionResetWhenOutside = false;
    a.brightness = b.brightness  = initBrightness;

    a.position = new PVector(0, y);
    a.angle = QUARTER_PI;

    b.position = new PVector(width, y);
    b.angle = -QUARTER_PI;

    agents.add(a);
    agents.add(b);

  }

}

void draw() {

  float t = 1.0 * (frameCount < numFrame ? frameCount : frameCount % numFrame) / numFrame;

  if( t == 0 ) { // remove
    init();
    background(0);
    println("new");
  }
  if( t > 0.7 ) { // fadeout
    fill(0, (t-0.7)*200);
    rect(0, 0, width, height);
  }

  fill(255, 30);
  
  for (Agent a : agents){

    a.angle = 
    stroke(a.brightness, agentAlpha);
    line(a.previousPosition.x, a.previousPosition.y, a.position.x, a.position.y);

  }



  for (int i=0; i<10000; i++) { // draw 10000 points at once
    PVector v = new PVector(random(-1, 1), random(-1, 1)); // random input vector
    PVector fv = waves(popcorn(v)); // vector field
    fv.sub(v); // subtract trick
 
    float alpha = v.heading();
    float beta = fv.heading();
 
    float x = map(alpha, -PI, PI, 0, width);
    float y = map(beta, -PI, PI, 0, height);
 
    rect(x, y, 1, 1);
  }
  
}

void mooveAgents() {
  

  for (Agent a : agents) {


    a.updatePosition();
    if( a.brightness < 255 ) a.brightness += 10;
  }

void keyPressed() {
  if (keyCode == 32) saveFrame("######.jpg");
}
 

 
PVector popcorn(PVector p) {
  float x = p.x + popcorn_c * sin(tan(3.0 * p.y));
  float y = p.y + popcorn_f * sin(tan(3.0 * p.x));
  return new PVector(x, y);
}


 
PVector waves(PVector p) {
  float x = p.x + waves_b * sin(p.y * (1.0 / (waves_c * waves_c) ));
  float y = p.y + waves_e * sin(p.x * (1.0 / (waves_f * waves_f) ));
 
  return new PVector(x, y);
}