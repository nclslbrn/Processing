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

color colorInterpolation(color c, int alpha) {

  float red   = red(c);
  float green = green(c);
  float blue  = blue(c);

  return color(red, green, blue, alpha);

}

int   size   = 8,
      agentsCount;

float noiseZ,
      phase,
      seed;

ArrayList<Agent> agents;

IntList   textPixels;
FloatDict config;
PImage    bg;
PFont     font;

void setup() {
  size(800, 800);
  agentsCount = floor( width * height / 500 );
  noiseZ = 0;

  textPixels = new IntList();

  config = new FloatDict();
  config.set("zoom",            120);
  config.set("noiseSpeed",      0.05);
  config.set("fieldForce",      10);
  config.set("agentSpeed",      4);
  config.set("alphaBackground", 10);
  config.set("agentMinAlpha",   50);
  config.set("agentMaxAlpha",   120);
  config.set("agentMinWeight",  0.25);
  config.set("agentMaxWeight",  0.75);
  

  reset();
}

void getTextPosition() {
  PGraphics    pg;

  pg = createGraphics(width, height);
  bg = createImage(width, height, ARGB);
  bg.loadPixels();
  font = createFont("Inter-ExtraBold.otf", 80, true);

  pg.beginDraw();
  pg.background(0);
  pg.fill(255);
  pg.textSize(80);
  pg.textAlign(CENTER, CENTER);
  pg.textFont(font);
  pg.text("VOID", 0, 0, width, height);
  pg.endDraw();
  pg.loadPixels();

  for( int coord = 0; coord < width * height -1; coord++ ) {
    if( pg.pixels[coord] < color(10) ) {     
      textPixels.append(coord);
      bg.pixels[coord] = color(0,0,0,0);
    }
    else {
      bg.pixels[coord] = color(0,0,0,config.get("alphaBackground"));
    }
  }
  bg.updatePixels();
}


void getImagePosition() {
  PImage    pg;

  pg = loadImage("Vladimir-Poutine.jpg");
  bg = createImage(width, height, ARGB);
  bg.loadPixels();
  pg.loadPixels();

  for( int coord = 0; coord < width * height -1; coord++ ) {
    if( pg.pixels[coord] < color(60) ) {     
      textPixels.append(coord);
      bg.pixels[coord] = color(0,0,0,0);
    }
    else {
      bg.pixels[coord] = color(0,0,0, config.get("alphaBackground"));
    }
  }
  bg.updatePixels();
}

void reset() {
  initAgents();
  background(0);
  getImagePosition();
  //getTextPosition();
  //image(pg, 0, 0);
}


void initAgents() {

  agents = new ArrayList<Agent>();
  colorMode(HSB, agentsCount*3, 100, 100);
  for( int a = 0; a < agentsCount; a++ ) {

    Agent newAgent        = new Agent();
    newAgent.position     = new PVector(random(1)*width, random(1)*height);
    newAgent.stepSize     = config.get("agentSpeed") * random(4);
    newAgent.brightness   = floor(random(1) * 100);
    newAgent.strokeWeight = random(config.get("agentMinWeight"), config.get("agentMaxWeight"));
    newAgent.strokeColor  = color(agentsCount + a, 100, 100);
    agents.add(newAgent);
  }
  colorMode(RGB, 255, 255, 255);
}

void drawAgents() {
 
  int currentAgentID = 1;

  for (Agent a : agents) {
    
    a.updatePosition();
    int coord = (int(a.position.x) + int(a.position.y) * width )-1;

    if( textPixels.hasValue(coord) ) {

      if( a.brightness < config.get("agentMaxAlpha") ) {
        a.brightness += 10;
      }
      a.position.x += (random(1) - 0.5) * 12;
      a.position.y += (random(1) - 0.5) * 12;
      a.stepSize = 0.25;

      a.angle = random(1) * TWO_PI;

      textPixels.remove( textPixels.index(coord) );

    } else {

      if( a.brightness > config.get("agentMinAlpha") ) {
        a.brightness -= 10;
      }

      a.stepSize = config.get("agentSpeed");
      a.angle = getNoiseIntensity(a.position, noiseZ);
      
    }
    strokeWeight(a.strokeWeight);
    stroke(colorInterpolation(a.strokeColor, a.brightness));
    line(a.previousPosition.x, a.previousPosition.y, a.position.x, a.position.y);

    currentAgentID++;
  }
}
void draw() {
  
  noiseZ += config.get("noiseSpeed");
  image(bg, 0, 0);
  drawAgents();

  phase += 0.01;
  seed  += 0.003;
   if( mousePressed == true && (mouseButton == RIGHT) ) {
    saveFrame("records/frame-###.jpg");
  }
  if( mousePressed == true && (mouseButton == LEFT) ) {
    exit(); 
  }
}