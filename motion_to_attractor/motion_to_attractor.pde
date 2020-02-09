
import processing.video.*;

Capture video;
PImage prevFrame;
ArrayList<Particle> particles = new ArrayList<Particle>();

float A, B, C, D;
// Min difference in RGB value
float threshold = 150;
// Compare pixels betwwen (in pixels)
int trackingResolution = 8;
// Maximum age of particles (in moves)
int particleMaxAge = 620;
float particleMaxSize = 1;
// Upscale factor between capture and sketch size
float scaleX = 0;
float scaleY = 0;
// How many frames before change constants
int constantMaxFrame = 320;
// Print value if you want to debug
boolean debug = false;
boolean videoLaunched = false;

// Init attractor constant
void newConstant() {
  A = (random(1) * 4) -2;
  B = (random(1) * 4) -2;
  C = (random(1) * 4) -2;
  D = (random(1) * 4) -2;

  if(debug) {
    println("Living particles=" + particles.size());
    println("A=" + A + " B=" + B + " C=" + C + " D=" + D);
  }
}

// Save particle to particles
void addParticle(float xPos, float yPos, color particleColor) {
  int r = (particleColor>>16)&255;
  int g = (particleColor>>8)&255;
  int b = particleColor&255;

  Particle newParticle = new Particle(
    new PVector(xPos, yPos),   // possition
    color(r, g, b, 180),        // color
    random(0.01, particleMaxSize) // size
  );
  particles.add(newParticle);
}

// Move particles and delete oldest
void moveAndRemoveParticles() {

  IntList particlesToRemove = new IntList();

  for ( int i = 0; i < particles.size(); i++ ) {

    Particle particle = particles.get(i);
    particle.updatePosition(A, B, C, D, 0.03);
    particle.display();

    if( particle.age >= particleMaxAge || particle.isOutsideSketch() > 0) {
      particle.isLiving = false;
    }
  }
  
  for( int d = particles.size()-1; d >= 0 ; d-- ) {
    Particle particle = particles.get(d);
    if( particle.isLiving == false ) {
      particles.remove( d );
    } 
  }
}

// init and debug video object
void initCamera() {
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    video = new Capture(this, cameras[0]);
    video.start();

    prevFrame = createImage(video.width, video.height, RGB);
    scaleX = width > video.width ? width / video.width : video.width / width;
    scaleY = height > video.height ? height / video.height: video.height / height;

  }
}

void setup() {
  //size(640,480);
  size(1280, 960);
  //fullScreen();
  //colorMode(RGB, 255, 255, 255, 1);
  newConstant();
  initCamera();
  
  particleMaxSize = scaleX+scaleY;
  fill(0);
  rect(-5, -5, width+10, height+10);
  
}


void draw() {

  if( frameCount % constantMaxFrame == 0 ) {
    newConstant();
  }
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();

  for (int x = 0; x < video.width; x += trackingResolution ) {
    for (int y = 0; y < video.height; y += trackingResolution ) {
      
      int loc = x + y*video.width;            
      color current = video.pixels[loc];      
      color previous = prevFrame.pixels[loc]; 
        
      int r1 = (current>>16)&255;
      int g1 = (current>>8)&255;
      int b1 = current&255;

      int r2 = (previous>>16)&255;
      int g2 = (previous>>8)&255;
      int b2 = previous&255;
    
      float diff = dist(r1,g1,b1,r2,g2,b2);
      
      if (diff > threshold) { 
        float particlePosX  = x * scaleX;
        float particlePosY  = y * scaleY;
        color particleColor = video.pixels[loc];
        addParticle( particlePosX, particlePosY, particleColor );
      } 
    }
  }

  rect(-5, -5, width+10, height+10);
  fill(0, 0.25);
  moveAndRemoveParticles();

  if( mousePressed == true ) {
    saveFrame("records/frame-###.png");
  }

  
}

void captureEvent(Capture video) {
  
  prevFrame.copy(
    video,
    0,0,video.width,video.height,
    0,0,video.width,video.height
  ); 
  prevFrame.updatePixels();
  video.read();
}
