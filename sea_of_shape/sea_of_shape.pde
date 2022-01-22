// https://gist.github.com/beesandbombs/835bf55089be6599fe77e30f4f678df3
// by dave
float[][] result;
float t, c;

float ease(float p) {
  p = c01(p);
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  p = c01(p);
  if (p < 0.5)
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float mn = .5*sqrt(3), ia = atan(sqrt(.5));

float c01(float g) {
  return constrain(g, 0, 1);
}

float millisFrame1;

void draw() {
  if (recording) {
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    c = 0;
    for (int sa=0; sa<samplesPerFrame; sa++) {
      t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
      t %= 1;
      draw_();
      loadPixels();
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += sq(red(pixels[i])/255.0);
        result[i][1] += sq(green(pixels[i])/255.0);
        result[i][2] += sq(blue(pixels[i])/255.0);
      }
    }
    
    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = color(255*sqrt(result[i][0]/samplesPerFrame),
        255*sqrt(result[i][1]/samplesPerFrame),
        255*sqrt(result[i][2]/samplesPerFrame));
    updatePixels();
    

    saveFrame("animations/f-###.gif");
    if (frameCount==numFrames)
      exit();
  } else if (preview) {
    if (frameCount==1)
      millisFrame1 = millis();
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    t = ((millis()-millisFrame1)/(20.0*numFrames))%1;
    draw_();
  } else {
    t = mouseX*1.0/width;
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    draw_();
  }
}

//////////////////////////////////////////////////////////////////////////////


int samplesPerFrame = 12;
int numFrames = 100;
float shutterAngle = .9;

boolean recording = true,
  preview = true;
  
float spacing = 0.1,
      seaSize = 3.0,
      noiseScale = 0.007,
      turbulence = 5,
      r = 14.0,
      letterSpacing = 6.0;
      
PVector ctr;
PFont azkindenz;
OpenSimplexNoise noise;
char[] chars = { 'S', 'H', 'A', 'P', 'E' };

void setup() {
  size(800, 800, P3D);
  pixelDensity(recording ? 1 : 2);
  
  result = new float[width*height][3];
  ctr = new PVector(width/2, height/2);
  
  azkindenz = loadFont("AkzidenzGrotesk-Black-126.vlw");
  textFont(azkindenz, 10);
  textAlign(CENTER);
  
  fill(255);
  noise = new OpenSimplexNoise();
}

void draw_() {
  background(40);

  //text(t, 15, 15, 0);
  
  pushMatrix();
  translate(ctr.x, ctr.y + 50);
  rotateX(PI * -0.1);
  
  
  for( float x = -seaSize; x <= seaSize; x += spacing ) {
    
    int i = 0;
    for( float z = -seaSize; z <= seaSize; z += spacing / 3 ) {
      
      float depth = map(z, -seaSize, seaSize, 1.0f, 0.0f);
      
      PVector pos = new PVector(
        ctr.x *  ( x + ( i % 2 == 0 ? spacing / 6 : -spacing / 6 )), 
        0, 
        ctr.y * z
      );
      
      for (int l = 0; l < chars.length; l++) {
         
         pos.x += letterSpacing;
         
         float n1 = turbulence * (float) noise.eval(
           pos.x * noiseScale, 
           pos.z * noiseScale, 
           cos(t * TWO_PI),
           sin(t * TWO_PI)
         );
         float n2 = turbulence * (float) noise.eval(x, z, cos(t * TWO_PI), sin(t * TWO_PI));
         
         
         text(
           chars[l],
           pos.x + r * depth * cos(n1) + r * depth * sin(n2),
           r * depth * sin(n2),
           pos.z + r * depth * sin(n1) + r * depth * cos(n2)
         );
       
      }
      i++;
    }
  }
  popMatrix();
  
}
