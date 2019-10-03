/**
 * Based on 500 Followers Flow field 
 * @link https://codepen.io/DonKarlssonSan/pen/KXLevM?editors=0010
 */

float getNoiseIntensity(PVector position, float t ) {
  
    return (float) noise(
      (position.x + phase) / config.get("zoom"),
      (position.y + phase) / config.get("zoom"),
      seed
    ) * config.get("fieldForce");
}

color colorInterpolation(int agentID) {

  color a = #3498db;
  color b = #e74c3c;
  println( agentID / agents.size());

  return lerpColor( a, b, agentID / agentsCount );
}

int   radius = 20,
      size   = 8,
      agentsCount;

float noiseZ,
      phase,
      seed;

ArrayList<Agent> agents;

IntList   textPixels;
FloatDict config;
PGraphics pg;
PFont     font;

void setup() {
  size(800, 800);
  agentsCount = floor( width * height / 500 );
  noiseZ = 0;

  textPixels = new IntList();

  config = new FloatDict();
  config.set("zoom",       400);
  config.set("noiseSpeed", 0.001);
  config.set("fieldForce", 60);
  config.set("agentSpeed", 8);
  config.set("agentAlpha", 120);

  pg = createGraphics(width, height);
  font = createFont("Inter-ExtraBold.otf", 80, true);

  reset();
}

void getTextPosition() {
  
  pg.beginDraw();
  pg.background(0);
  pg.fill(255);
  pg.textSize(80);
  pg.textAlign(CENTER, CENTER);
  pg.textFont(font);
  pg.text("STOP", 0, 0, width, height);
  pg.endDraw();
  pg.loadPixels();

  for( int coord = 0; coord < width * height -1; coord++ ) {
    if( pg.pixels[coord] == color(255) ) {     
      textPixels.append(coord);
    }
  }
}

void reset() {
  initAgents();
  background(0);
  getTextPosition();
  //image(pg, 0, 0);
}

void alphaBackground( int alpha ) {
  fill(0, alpha);
  rect(-1, -1, width+2, height+2);
}

void initAgents() {

  agents = new ArrayList<Agent>();

  for( int a = 0; a < agentsCount; a++ ) {

    Agent newAgent    = new Agent();
    newAgent.position = new PVector(random(1)*width, random(1)*height);
    newAgent.stepSize = config.get("agentSpeed") * random(4);
    newAgent.brightness = floor(random(1) * 100);
    agents.add(newAgent);
  }

}

void drawAgents() {
 
  int currentAgentID = 1;

  for (Agent a : agents) {
    
    a.updatePosition();
    int coord = (int(a.position.x) + int(a.position.y) * width )-1;

    if( textPixels.hasValue(coord) ) {

      if( a.brightness < 255 ) {
        a.brightness += 10;
      }
      //a.position.x += (random(1) - 0.5) * 5;
      //a.position.y += (random(1) - 0.5) * 5;
      a.stepSize = config.get("agentSpeed")/2;

      a.angle = random(1) * TWO_PI;

    } else {

      if( a.brightness > config.get("agentAlpha") ) {
        a.brightness -= 10;
      }

      a.stepSize = config.get("agentSpeed");
      a.angle = getNoiseIntensity(a.position, noiseZ);
      
    }
    color c = colorInterpolation( currentAgentID );
    stroke(red(c), green(c), blue(c), a.brightness);
    line(a.previousPosition.x, a.previousPosition.y, a.position.x, a.position.y);

    currentAgentID++;
  }
}
void draw() {
  
  noiseZ += config.get("noiseSpeed");
  //alphaBackground(1);
  drawAgents();

  phase += 0.01;
  seed  += 0.003;
  
  if( mousePressed == true ) {
    exit(); 
  }
}