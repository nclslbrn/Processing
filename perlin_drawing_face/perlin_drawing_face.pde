/**
 * Based on 500 Followers Flow field 
 * @link https://codepen.io/DonKarlssonSan/pen/KXLevM?editors=0010
 */

float getNoiseIntensity(PVector position, float t ) {
  
    return (float) noise(
      position.x / config.get("zoom"),
      position.y / config.get("zoom"),
      noiseZ
    ) * config.get("fieldForce");
}

color colorInterpolation(color c, int alpha) {

  float red   = red(c);
  float green = green(c);
  float blue  = blue(c);

  return color(red, green, blue, alpha);
}

int size   = 8,
    paintedPeopleIndex = 0,
    agentsCount;

float noiseZ;

ArrayList<Agent> agents;
color[] lineColors = {
  #3498DB,
  #2980B9,
  #E74C3C,
  #C0392B
};

IntList   selectedFacePixels;
FloatDict config;
PFont     font;
boolean is_hd_painting = true;

String[] people =  { 
  "_0001_Xi-Jinping",
  "_0002_Vladimir-Poutine",
  "_0003_Recep-Tayyip-Erdogan",
  "_0004_Nicolas-Maduro",
  "_0005_Kim-Jong-Un",
  "_0006_Jair-Bolsonaro",
  "_0007_Bashar-Al-Assad",
  "_0008_Donald-Trump"
};

public void settings() {
  if( is_hd_painting ) {
    size(1455, 1971);
  } else {
    size(591, 800);
  }
}
void setup() {
  
  
  config = new FloatDict();

  if( is_hd_painting ) {
    config.set("zoom",            284);
    config.set("agentMaxWeight",  2);
    config.set("agentSpeed",      4);
    config.set("particleFactor",  300);
  } else {
    config.set("zoom",            142);
    config.set("agentMaxWeight",  0.75);
    config.set("agentSpeed",      2);
    config.set("particleFactor",  300);
  }
  config.set("contrastThreshold", 150);
  config.set("noiseSpeed",        0.008);
  config.set("fieldForce",        18);
  config.set("agentMinAlpha",     10);
  config.set("agentMaxAlpha",     255);
  config.set("agentMinWeight",    0.25);
  
  
  agentsCount = floor( width * height / config.get("particleFactor")  );
  noiseZ = 0;
  selectedFacePixels = new IntList();

  reset();
}

void initAgents() {

  agents = new ArrayList<Agent>();
  for( int a = 0; a < agentsCount; a++ ) {

    Agent newAgent        = new Agent();
    newAgent.position     = new PVector(random(1)*width, random(1)*height);
    newAgent.stepSize     = config.get("agentSpeed") * random(4);
    newAgent.brightness   = floor(random(1) * 100);
    newAgent.strokeWeight = random(config.get("agentMinWeight"), config.get("agentMaxWeight"));
    agents.add(newAgent);
  }
}

void drawAgents() {
 
  int currentAgentID = 1;
  colorMode(HSB, agentsCount*3, 100, 100);

  for (Agent a : agents) {
    
    a.updatePosition();
    int coord = (int(a.position.x) + int(a.position.y) * width )-1;
    float centerIndex;
    
    if( (a.position.x + a.position.y ) < ((width + height)/2)) {
      centerIndex = (a.position.x + a.position.y ) / ((width + height)/2);
    } else {
      centerIndex = 1 - ((a.position.x + a.position.y ) - ((width + height)/2)) / (width+height/2);
    }

    if( selectedFacePixels.hasValue(coord) ) {

      if( a.brightness < config.get("agentMaxAlpha") ) {
        a.brightness += 20;
      }

      a.position.x += (random(1) - 0.5) * ( is_hd_painting ? 12 : 6);
      a.position.y += (random(1) - 0.5) * ( is_hd_painting ? 12 : 6);
      a.stepSize = 0.25;
      //a.strokeColor = lerpColor(lineColors[0], lineColors[1], centerIndex);
      a.strokeColor = color(agentsCount*2 + currentAgentID);
      a.angle = random(1) * TWO_PI;
      //selectedFacePixels.remove( selectedFacePixels.index(coord) );

    } else {

      if( a.brightness > config.get("agentMinAlpha") ) {
        a.brightness -= 20;
      }

      //a.strokeColor  =  lerpColor(lineColors[2], lineColors[3], centerIndex);
      a.strokeColor  = color(currentAgentID);      
      a.stepSize = config.get("agentSpeed");
      a.angle = getNoiseIntensity(a.position, noiseZ);
      
    }
    strokeWeight(a.strokeWeight);
    stroke(a.strokeColor);
    //stroke(colorInterpolation(a.strokeColor, a.brightness));
    line(a.previousPosition.x, a.previousPosition.y, a.position.x, a.position.y);

    currentAgentID++;
  }
  colorMode(RGB, 255, 255, 255);
}

void getSelectedPixels() {
  PImage    pg;
  pg = loadImage( 
    (is_hd_painting ? "hd/" : "ld/" ) + 
    people[paintedPeopleIndex-1] + 
    ".jpg"
  );

  pg.loadPixels();
  if( selectedFacePixels.size() > 0 ) {
    selectedFacePixels.clear();
  }
  for( int coord = 0; coord < width * height -1; coord++ ) {
    if( pg.pixels[coord] > color( config.get("contrastThreshold") ) ) {     
      selectedFacePixels.append(coord);
    }
  }
}

void reset() {
  initAgents();
  background(0);
  paintedPeopleIndex++;
  println("Painting " + people[paintedPeopleIndex-1]);
  getSelectedPixels();
}


void draw() {
  
  noiseZ += config.get("noiseSpeed");
  drawAgents();
  
  if( mousePressed == true && (mouseButton == RIGHT) ) {
    saveFrame("records/" + people[paintedPeopleIndex-1] + "-###.jpg");
  }
  if( mousePressed == true && (mouseButton == LEFT) ) {
    exit(); 
  }
  if( frameCount % ((is_hd_painting ? 800 : 1600) * paintedPeopleIndex) == 0) {
    
    saveFrame(
      "records/" + 
      people[paintedPeopleIndex-1] + 
      (is_hd_painting ? "-hd" : "-ld" ) + 
      "-###.jpg"
    );
    
    if( people.length > paintedPeopleIndex ) {
      
      reset(); 
    
    } else {
    
      exit();
    
    }
  }
}