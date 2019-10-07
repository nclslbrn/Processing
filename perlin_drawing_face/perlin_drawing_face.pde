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

int size   = 8,
    paintedPeopleIndex = 0,
    agentsCount;

float noiseZ,
      phase,
      seed;

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

String[] people =  { 
  "Jair-Bolsonaro",
  "Recep-Tayyip-Erdogan",
  "Vladimir-Poutine",  
  "Donald-Trump"
};

void setup() {
  size(800, 800);
  agentsCount = floor( width * height / 400 );
  noiseZ = 0;
  selectedFacePixels = new IntList();

  config = new FloatDict();
  config.set("zoom",            142);
  config.set("noiseSpeed",      0.08);
  config.set("fieldForce",      18);
  config.set("agentSpeed",      2);
  config.set("agentMinAlpha",   40);
  config.set("agentMaxAlpha",   255);
  config.set("agentMinWeight",  0.25);
  config.set("agentMaxWeight",  0.75);
  
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

      a.position.x += (random(1) - 0.5) * 6;
      a.position.y += (random(1) - 0.5) * 6;
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
  pg = loadImage(people[paintedPeopleIndex-1] + ".jpg");
  pg.loadPixels();
  if( selectedFacePixels.size() > 0 ) {
    selectedFacePixels.clear();
  }
  for( int coord = 0; coord < width * height -1; coord++ ) {
    if( pg.pixels[coord] > color(230) ) {     
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

  phase += 0.1;
  seed  += 0.005;
  
  if( mousePressed == true && (mouseButton == RIGHT) ) {
    saveFrame("records/" + people[paintedPeopleIndex-1] + "-###.jpg");
  }
  if( mousePressed == true && (mouseButton == LEFT) ) {
    exit(); 
  }
  if( frameCount % (1200*paintedPeopleIndex) == 0) {
    
    saveFrame("records/" + people[paintedPeopleIndex-1] + "-a-###.jpg");
    
    if( people.length > paintedPeopleIndex ) {
      
      reset(); 
    
    } else {
    
      exit();
    
    }
  }
}