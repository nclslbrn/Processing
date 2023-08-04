/********
Image manipulation based on Kim Asendorf ASDF Pixel Sort
Kim Asendorf | 2010 | kimasendorf.com
https://github.com/kimasendorf/ASDFPixelSort/blob/master/ASDFPixelSort.pde
*/
import controlP5.*;
PixelSortingApplet applet;
ControlP5 cp5;
Slider s1, s2;
RadioButton r1, r2;

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
// interpolate source image
boolean toPolar = false;
boolean toSpiral = false;

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
  size(300, 600);
    
  for (int i = 0; i < editionNum; i++) {
    original[i] = loadImage("sample/" + imgFileName + i + "." + fileType);
    imgs[i] = original[i].get();
  }
  
  String[] args = {"TwoFrameTest", "Pixel Sorting"};
  applet = new PixelSortingApplet();
  PApplet.runSketch(args, applet);
  
  cp5 = new ControlP5(this);
  cp5.addSlider("brightValueSlider")
    .setPosition(20, 40)
    .setSize(200, 20)
    .setRange(0, 255)
    .setValue(50)
    .setColorCaptionLabel(color(20,20,20));
    
  cp5.addSlider("darkValueSlider")
    .setPosition(20, 80)
    .setSize(200, 20)
    .setRange(0, 255)
    .setValue(200)
    .setColorCaptionLabel(color(20,20,20));
    
  cp5.addSlider("whiteValueSlider")
    .setPosition(20, 120)
    .setSize(200, 20)
    .setRange(-12345678, 0)
    .setValue(-12345678)
    .setColorCaptionLabel(color(255));
  
  cp5.addSlider("blackValueSlider")
    .setPosition(20, 160)
    .setSize(200, 20)
    .setRange(-3456789, -12345678)
    .setValue(-3456789)
    .setColorCaptionLabel(color(255));
    
  cp5.addButton("previous")
     .setValue(0)
     .setPosition(20, 240)
     .setSize(40, 20);

  cp5.addButton("next")
     .setValue(0)
     .setPosition(180, 240)
     .setSize(40, 20);
  
  r1 = cp5.addRadioButton("radioButton")
     .setPosition(40,200)
     .setSize(40, 20)
     .setColorForeground(color(120))
     .setColorActive(color(255))
     .setColorLabel(color(255))
     .setItemsPerRow(2)
     .setSpacingColumn(50)
     .addItem("spiral", 1)
     .addItem("circle", 2);
   
  
}

void draw() {
  background(0); 
}
void brightValueSlider(int val) { brightValue = val; applet.init(); }
void darkValueSlider(int val) {  darkValue  = val; applet.init(); }
void whiteValueSlider(int val) { whiteValue = val; applet.init(); }
void blackValueSlider(int val) { blackValue = val; applet.init(); }
void previous() { 
  if (edition > 0) {
    edition--;
    applet.init();
  } 
}
void next() {
  if(edition < editionNum-1) {
    edition++;
    applet.init();
  }
}
void keyPressed() {
  switch(key) {
    case('0'): r1.deactivateAll(); break;
    case('1'): r1.activate(0); break;
    case('2'): r1.activate(1); break;
  }
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isFrom(r1)) {
    if (int(theEvent.getGroup().getValue()) == 1) {
      willMovePixInSpiral = !willMovePixInSpiral;
      applet.init();

    }
    if (int(theEvent.getGroup().getValue()) == 2) {
      willMovePixInCircle = !willMovePixInCircle;
      applet.init();
    }
  }
}

public class PixelSortingApplet extends PApplet {
  public void settings() {
    
    size(1000, 1000);
    // surface.setResizable(true);
    //surface.setSize(imgs[edition].width, imgs[edition].height);
    //image(imgs[edition], 0, 0, width, height);
    noLoop();
  }
  
  
  public void draw() {
    if (willMovePixInCircle || toPolar) polarImage = polarInterpolation(imgs[edition], 0.45).get();    
    if (willMovePixInSpiral || toSpiral) spiralImage = spiralInterpolation(imgs[edition]).get();
  
  
    if (toPolar) {
      imgs[edition] = polarImage;
      imgs[edition].updatePixels();
    }
    if (toSpiral) {
      imgs[edition] = spiralImage;
      imgs[edition].updatePixels();
    }
  
    if (willSortColumn) {
      while (column < imgs[edition].width-1) {
        imgs[edition].loadPixels();
        sortColumn();
        column++;
        mode = (mode + 1) % 4;
        imgs[edition].updatePixels();
      }
    }
    if (willSortRow) {
      while (row < imgs[edition].height-1) {
        imgs[edition].loadPixels();
        sortRow();
        row++;
        mode = (mode + 1) % 4;
        imgs[edition].updatePixels();
      }
    }  
    // load updated image onto surface and scale to fit the display width and height
    image(imgs[edition], 0, 0, width, height);
  }
  
  public void keyPressed() {
    
    if (keyCode == LEFT && edition > 0) edition--;
    if (keyCode == RIGHT && edition < editionNum-1) edition++;
    if (keyCode == UP) willSortRow = !willSortRow;
    if (keyCode == DOWN) willSortColumn = !willSortColumn;
    if (keyCode == 67) willMovePixInCircle = !willMovePixInCircle;
    if (keyCode == 83) willMovePixInSpiral = !willMovePixInSpiral;
    println(keyCode);
    println(
      "#" + edition + 
      " sort [ " + (willSortColumn ? "column " : "") + (willSortRow ? "row " : "") + "]" +
      (willMovePixInSpiral || willMovePixInCircle ? " on " : "") + 
      (willMovePixInSpiral ? "spiral" : "") + (willMovePixInCircle ? "circle" : "")
    );
    init();
  }
  
  public void init() {
   row = 0;
   column = 0;
   bandSize = 8;
   lastBandPos = 0;
    //imgs[edition].loadPixels();
   imgs[edition] = original[edition].get();
    //imgs[edition].updatePixels();
   saved = false;
    
   redraw();
  }
  
  public void mousePressed() {
    if ( ! saved ) {
      imgs[edition].save(
        "output/" + imgFileName + edition + "-" +
        (willSortColumn ? "column-" : "") + (willSortRow ? "row-" : "") +
        (willMovePixInSpiral ? "spiral" : "") + (willMovePixInCircle ? "circle" : "") + 
        ".png"
      );
      saved = true;
      println("Saved edition " + edition);
    }
  }
}

PVector noiseMove(int x, int y) {
  float noiseScale = 0.02;
  float noiseAngle = noise(x * noiseScale, y * noiseScale) * TWO_PI;
  return new PVector(
    abs(x + cos(noiseAngle)) % imgs[edition].width,
    abs(y + sin(noiseAngle)) % imgs[edition].height
  );
}

void updateBand(int value) {
  if ((value - lastBandPos) % bandSize == 0) {
      sortInverse = !sortInverse;
      lastBandPos = value;
      bandSize = ceil(random(1, 4)) * bandBaseSize;
      //mode = (mode + 1) % 4;
  }
}
