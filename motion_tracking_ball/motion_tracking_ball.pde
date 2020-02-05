
import processing.video.*;

Capture video;

PImage prevFrame;

float threshold = 150;
int Mx = 0;
int My = 0;
int ave = 0;
float A, B, C, D;
int ballX = width/2;
int ballY = height/2;
int rsp = 25;
int numFrames = 620;

float cliffordAttractor(float x, float y)  {
  // clifford attractor
  // http://paulbourke.net/fractals/clifford/
  float scale = 0.005;
  x = (x - width / 2) * scale;
  y = (y - height / 2) * scale;
  float x1 = sin(A * y) + C * cos(A * x);
  float y1 = sin(B * x) + D * cos(B * y);

  return atan2(y1 - y, x1 - x);
}

void setup() {
  size(640,480);
  String[] cameras = Capture.list();
  A = random(1) * 4 -2;
  B = random(1) * 4 -2;
  C = random(1) * 4 -2;
  D = random(1) * 4 -2;

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
}


void draw() {
  
  float t = 1.0 * ((frameCount < numFrames) ? frameCount : frameCount % numFrames) / numFrames;

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
  stroke(0);
  fill(255, 10);
  rect(0,0, width, height);

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
  for( int n = 0; n < 120; n++ ) {


    float nx = ballX + (random(1) * 12 - 24);
    float ny = ballY + (random(1) * 12 - 24);
    float nx_ = nx;
    float ny_ = ny;

    if( t < 1 ) {

      float angle = cliffordAttractor(nx, ny);
      nx_ += cos(angle) * 0.3;
      ny_ += cos(angle) * 0.3;
      stroke(0);
      line(nx, ny, nx_, ny_);
      
      nx = nx_;
      ny = ny_;
    }
    
  }
  println(t);

  //updatePixels();
  fill(200,0,0, 100);
  ellipse(ballX, ballY, 36, 36);
    
  
}
