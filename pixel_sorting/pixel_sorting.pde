/********
Image manipulation based on Kim Asendorf ASDF Pixel Sort
Kim Asendorf | 2010 | kimasendorf.com
https://github.com/kimasendorf/ASDFPixelSort/blob/master/ASDFPixelSort.pde
*/
import controlP5.*;
PixelSortingApplet applet;
ControlP5 cp5;
Slider s1, s2;
RadioButton radioButton;
Textlabel textLabel;
Toggle willSortRowToggle, willSortColumnToggle, useNoiseDisplacementToggle;

int mode = 0; // will change on loop

String[] modes = { "white", "black", "bright", "dark" };
// image path is relative to sketch directory
String imgFileName = "Stacks-";
int edition = 5;
int editionNum = 50;
String fileType = "png";
PImage[] imgs = new PImage[editionNum];
PImage[] original = new PImage[editionNum];

// threshold values to determine sorting start and end pixels
// using the absolute rgb value
// r*g*b = 255*255*255 = 16581375
// 0 = white
// -16581375 = black
// sort all pixels whiter than the threshold
int whiteValue = -12345678;
// sort all pixels blacker than the threshold
int blackValue = -3456789;
// using the brightness value
// sort all pixels brighter than the threshold
int brightValue = 50;
// sort all pixels darker than the threshold
int darkValue = 200;

// step until we change mode 
int bandSize = 32; 
int bandBaseSize = 16;
int lastBandPos = 0;

boolean sortInverse = true;

// choose sorting type (can be both)
boolean willSortRow = true;
boolean willSortColumn = true;

// to do
boolean useNoiseDisplacement = false;
// sample spiral or polar (if both are true it will sample polar image)  
boolean willMovePixInSpiral = false;
boolean willMovePixInCircle = false;
int row = 0;
int column = 0;

boolean saved = false;

PImage polarImage;
PImage spiralImage;

void setup() {
  size(300, 440);
    
  for (int i = 0; i < editionNum; i++) {
    original[i] = loadImage("sample/" + imgFileName + i + "." + fileType);
    imgs[i] = original[i].get();
  }
  
  String[] args = {"TwoFrameTest", "Pixel Sorting"};
  applet = new PixelSortingApplet();
  PApplet.runSketch(args, applet);

  initUI();
}

void draw() {
  background(0); 
  textLabel.draw(this); 
}


void noiseDisplacement(int x, int y, color c) {
  float[] noiseScale = { 0.02, 0.5 };
  float noiseAngle = noise(x * noiseScale[0], y * noiseScale[0]) * TWO_PI;
  float dist = noise(x * noiseScale[1], y * noiseScale[1]) * 100;
  PVector pos = new PVector(x, y);
  
  for (int i = 0; i < dist; i++) {
    pos.x += cos(noiseAngle) * i;
    pos.y += sin(noiseAngle) * i;
    
    if (pos.x < 0) pos.x = imgs[edition].width - 1; 
    if (pos.y < 0) pos.y = imgs[edition].height - 1; 
    if (pos.x > imgs[edition].width - 1) pos.x = 0; 
    if (pos.y < imgs[edition].height - 1) pos.y = 0; 

    imgs[edition].pixels[x + y * imgs[edition].width] = c;
  }
}

void updateBand(int value) {
  if ((value - lastBandPos) % bandSize == 0) {
      sortInverse = !sortInverse;
      lastBandPos = value;
      bandSize = ceil(random(1, 4)) * bandBaseSize;
      //mode = (mode + 1) % 4;
  }
}
