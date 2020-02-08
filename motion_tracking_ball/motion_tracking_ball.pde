
import processing.video.*;

Capture video;

PImage prevFrame;
ArrayList<Particle> particles = new ArrayList<Particle>();

float threshold = 150;
int Mx = 0;
int My = 0;
int ave = 0;
float A, B, C, D;
int ballX = width/2;
int ballY = height/2;
int rsp = 25;
int trackingResolution = 1;
int particleMaxAge = 620;
float scaleX = 1;
float scaleY = 1;
int constantMaxFrame = particleMaxAge * 2;

// Init attractor constant
void newConstant() {
  A = (random(1) * 4) -2;
  B = (random(1) * 4) -2;
  C = (random(1) * 4) -2;
  D = (random(1) * 4) -2;

  // Debug attractor constants
  println("A: " + A + " B: " + B + " C: "+ C+" D: "+ D);
}

// Save particle to particles
void addParticle(float xPos, float yPos, color particleColor) {
  int r = (particleColor>>16)&255;
  int g = (particleColor>>8)&255;
  int b = particleColor&255;
  color partCol = color(r, g, b);
  particles.add(new Particle(new PVector(xPos, yPos), particleColor));
}

// Move particles and delete oldest
void moveAndRemoveParticles() {
  IntList particlesToRemove = new IntList();
  for ( int i = 0; i < particles.size(); i++ ) {
    Particle particle = particles.get(i);
    particle.updatePosition(A, B, C, D, 0.05);
    particle.display();

    if( particle.age >= particleMaxAge || particle.isOutsideSketch() > 0) {
      particlesToRemove.append(i);
    }
  }
  for( int i = 0; i < particlesToRemove.size(); i++ ) {
    particles.remove( particlesToRemove.get(i) );
  }
}

// init and debug video object
void initCamera() {
  String[] cameras = Capture.list();
  int camWidth = 0;
  int camHeight = 0;
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
  }
}

void setup() {
  //size(640,480);
  size(1280, 960);
  //fullScreen();
  newConstant();
  initCamera();
  scaleX = width / video.width;
  scaleY = height / video.height;
  prevFrame = createImage(video.width,video.height, RGB);
  strokeWeight(1.5);
  background(0);
}


void draw() {

  if( frameCount % constantMaxFrame == 0 ) {
    newConstant();
  }
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();  
  fill(0, 1.5);
  rect(-5, -5, width+10, height+10);
/* 

  tint(255, 10);
  image(video, 0, 0, width, height);
 */  //updatePixels();
  //fill(200,0,0, 100);
  //ellipse(ballX*scaleX, ballY*scaleY, 36, 36);

  //println(particles.size());
  addParticle(
    ballX*scaleX, 
    ballY*scaleY, 
    video.get(ballX, ballY)
  );
  moveAndRemoveParticles();
}

void captureEvent(Capture video) {
  prevFrame.copy(
    video,
    0,0,video.width,video.height,
    0,0,video.width,video.height
  ); 
  prevFrame.updatePixels();
  video.read();
  Mx = 0;
  My = 0;
  ave = 0;
 
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
        pixels[loc] = video.pixels[loc];
        Mx += x;
        My += y;
        ave++;
      } else {
        pixels[loc] = video.pixels[loc];
      }
    }
  }

  if(ave != 0){ 
    Mx = Mx/ave;
    My = My/ave;
  }
  if (Mx > ballX + rsp/2 && Mx > 50){
    ballX+= rsp;
  }else if (Mx < ballX - rsp/2 && Mx > 50){
    ballX-= rsp;
  }
  if (My > ballY + rsp/2 && My > 50){
    ballY+= rsp;
  } else if (My < ballY - rsp/2 && My > 50){
    ballY-= rsp;
  }
}