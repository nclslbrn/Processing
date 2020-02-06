
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
int numFrames = 620;
int particelCount = 120;

void addParticle(int xPos, int yPos) {
  particles.add(new Particle(new PVector(xPos, yPos)));
}

void moveParticles() {
  for (int i = 0; i < particles.size(); i++) {
    Particle part = particles.get(i);
    part.updatePosition(A, B, C, D, 0.3);
    part.display(color(255, 200));
  }
}


void setup() {
  size(640,480);
  String[] cameras = Capture.list();
  A = (random(1) * 4) -2;
  B = (random(1) * 4) -2;
  C = (random(1) * 4) -2;
  D = (random(1) * 4) -2;

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    video = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);
     video = new Capture(this, cameras[0]);
     video.start();
  }
  prevFrame = createImage(video.width,video.height,RGB);
  background(0);
  println("A: " + A + " B: " + B + " C: "+ C+" D: "+ D);
}


void draw() {
  
  //float t = 1.0 * ((frameCount < numFrames) ? frameCount : frameCount % numFrames) / numFrames;

  if (video.available()) {
    
    prevFrame.copy(video,0,0,video.width,video.height,0,0,video.width,video.height); 
    prevFrame.updatePixels();
    video.read();
  }
  
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();
  
  Mx = 0;
  My = 0;
  ave = 0;
 
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      
      int loc = x + y*video.width;            
      color current = video.pixels[loc];      
      color previous = prevFrame.pixels[loc]; 
      
     
      float r1 = red(current); float g1 = green(current); float b1 = blue(current);
      float r2 = red(previous); float g2 = green(previous); float b2 = blue(previous);
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
  //stroke(0);
  fill(0, 50);
  rect(-5, -5, width+5, height+5);

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
  }else if (My < ballY - rsp/2 && My > 50){
    ballY-= rsp;
  }
  addParticle(ballX, ballY);
  moveParticles();

/* 
  updatePixels();
  fill(200,0,0, 100);
  ellipse(ballX, ballY, 36, 36);

 */
  //println(particles.size());
    
  
}
