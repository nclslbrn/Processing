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

int   radius = 20,
      size   = 8,
      agentsCount,
      cols,
      rows;

float noiseZ,
      phase,
      seed;

ArrayList<Agent> agents;
OpenSimplexNoise noise;

IntList   textPixels;
FloatDict config;
PGraphics pg;
PFont font;

color black = color(0);
color white = color(255);

void setup() {
  size(800, 800);
  agentsCount = floor( width * height / 300 );
  colorMode(HSB, agentsCount*3, 100, 100);
  textMode(SHAPE);
  cols = width / size;
  rows = height / size;
  noiseZ = 0;
  noise = new OpenSimplexNoise();
  textPixels = new IntList();

  config = new FloatDict();
  config.set("zoom",       80);
  config.set("noiseSpeed", 0.005);
  config.set("agentSpeed", 4);
  config.set("fieldForce", 40);
  config.set("agentAlpha", 10);

  pg = createGraphics(width, height);
  font = createFont("Inter-ExtraBold.otf", 120, true);

  reset();
}

void getTextPosition() {
  
  pg.beginDraw();
  pg.background(black);
  pg.fill(white);
  pg.textSize(120);
  pg.textAlign(CENTER, CENTER);
  pg.textFont(font);
  pg.text("KO", 0, 0, width, height);
  pg.endDraw();
  pg.loadPixels();

  for( int coord = 0; coord < width * height -1; coord++ ) {
    if( pg.pixels[coord] == white ) {
      textPixels.append(coord); 
    }
  }
}

void reset() {
  initAgents();
  background(0);
  getTextPosition();
  image(pg, 0, 0);
}

void alphaBackground( int alpha ) {
  fill(black, alpha);
  rect(-1, -1, width+2, height+2);
}

void initAgents() {

  agents = new ArrayList<Agent>();

  for( int a = 0; a < agentsCount; a++ ) {

    Agent newAgent    = new Agent();
    newAgent.position = new PVector(random(1)*width, random(1)*height);
    newAgent.stepSize = config.get("agentSpeed");
    newAgent.brightness = floor(random(1) * 100);
    agents.add(newAgent);
  }

}

void drawAgents() {
 
  int currentAgentID = floor(agentsCount); // only used for color

  for (Agent a : agents) {
    
    int coord = int((a.position.x + a.position.y) * width);

    if( textPixels.hasValue(coord) ) {

      if( a.brightness < 255 ) {
        a.brightness++;
      }
      a.angle = random(1) * TWO_PI;
      a.stepSize = 0.5;
      //a.updatePosition();

    } else {

      if( a.brightness > config.get("agentAlpha") ) {
        a.brightness--;
      }

      a.stepSize = config.get("agentSpeed");
      a.angle = getNoiseIntensity(a.position, noiseZ);
      
    }
    a.updatePosition();
    stroke(currentAgentID, a.brightness, a.brightness);
    line(a.previousPosition.x, a.previousPosition.y, a.position.x, a.position.y);
    currentAgentID++;
  }
}
void draw() {

  noiseZ += config.get("noiseSpeed");
  alphaBackground(1);
  drawAgents();

  phase += 0.001;
  seed  += 0.003;
  if( mousePressed == true ) {
    exit(); 
  }
}