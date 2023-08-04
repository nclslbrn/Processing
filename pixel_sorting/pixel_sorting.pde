
/********
Image manipulation based on Kim Asendorf ASDF Pixel Sort
Kim Asendorf | 2010 | kimasendorf.com
https://github.com/kimasendorf/ASDFPixelSort/blob/master/ASDFPixelSort.pde
*/

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
int brightValue = 200;
// sort all pixels darker than the threshold
int darkValue = 50;

// step until we change mode 
int bandSize = 8; 
int bandBaseSize = 4;
int lastBandPos = 0;

boolean sortInverse = true;
// interpolate source image
boolean toPolar = false;
boolean toSpiral = true;

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
  for (int i = 0; i < editionNum; i++) {
    original[i] = loadImage("sample/" + imgFileName + i + "." + fileType);
    imgs[i] = original[i].get();
  }
  size(1, 1);
  surface.setResizable(true);
  surface.setSize(imgs[edition].width, imgs[edition].height);

  //image(imgs[edition], 0, 0, width, height);
  noLoop();
}


void draw() {
  if (willMovePixInCircle || toPolar) polarImage = polarInterpolation(imgs[edition], 0.45);    
  if (willMovePixInSpiral || toSpiral) spiralImage = spiralInterpolation(imgs[edition]);


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
      //mode = (mode + 1) % 4;
      imgs[edition].updatePixels();
    }
  }
  if (willSortRow) {
    while (row < imgs[edition].height-1) {
      imgs[edition].loadPixels();
      sortRow();
      row++;
      //mode = (mode + 1) % 4;
      imgs[edition].updatePixels();
    }
  }  
  // load updated image onto surface and scale to fit the display width and height
  image(imgs[edition], 0, 0, width, height);
}

void keyPressed() {
  
  if (keyCode == LEFT && edition > 0) edition--;
  if(keyCode == RIGHT && edition < editionNum-1) edition++;

  if (keyCode == UP) willSortRow = !willSortRow;
  if (keyCode == DOWN) willSortColumn = ! willSortColumn;

  row = 0;
  column = 0;
  bandSize = 8;
  lastBandPos = 0;
  imgs[edition].loadPixels();
  imgs[edition] = original[edition].get();
  imgs[edition].updatePixels();
  //image(imgs[edition], 0, 0, width, height);
  saved = false;
  redraw();
  println(
    "#" + edition + 
    " sort [ " + (willSortColumn ? "column " : "") + (willSortRow ? "row " : "") + "]" );
}

void mousePressed() {
  if ( ! saved ) {
    imgs[edition].save("output/" + imgFileName + edition + ".png");
    saved = true;
    println("Saved edition " + edition);
  }
}


void sortRow() {
  // current row
  int y = row;
  
  // where to start sorting
  int x = 0;
  
  // where to stop sorting
  int xEnd = 0;
  
  while (xEnd < imgs[edition].width - 1) {
    switch (mode) {
      case 0:
        x = getFirstNoneWhiteX(x, y);
        xEnd = getNextWhiteX(x, y);
        break;
      case 1:
        x = getFirstNoneBlackX(x, y);
        xEnd = getNextBlackX(x, y);
        break;
      case 2:
        x = getFirstNoneBrightX(x, y);
        xEnd = getNextBrightX(x, y);
        break;
      case 3:
        x = getFirstNoneDarkX(x, y);
        xEnd = getNextDarkX(x, y);
        break;
      default:
        break;
    }
    
    if (x < 0) break;
    
    int sortingLength = xEnd-x;
    
    color[] unsorted = new color[sortingLength];
    color[] sorted = new color[sortingLength];
    
    for (int i = 0; i < sortingLength; i++) {
      if( willMovePixInSpiral) {
        unsorted[i] = spiralImage.pixels[x + i + y * imgs[edition].width];
      } else if (willMovePixInCircle) {
        unsorted[i] = polarImage.pixels[x + i + y * imgs[edition].width];
      } else {
        unsorted[i] = imgs[edition].pixels[x + i + y * imgs[edition].width];
      }
    }
    
    sorted = sort(unsorted);
    
    if(sortInverse) {
      sorted = reverse(sorted);
    }

    for (int i = 0; i < sortingLength; i++) {
      imgs[edition].pixels[x + i + y * imgs[edition].width] = sorted[i];      
    }
    
    x = xEnd+1;
    updateBand(x);
  }
}


void sortColumn() {
  // current column
  int x = column;
  
  // where to start sorting
  int y = 0;
  
  // where to stop sorting
  int yEnd = 0;
  
  while (yEnd < imgs[edition].height - 1) {
    switch (mode) {
      case 0:
        y = getFirstNoneWhiteY(x, y);
        yEnd = getNextWhiteY(x, y);
        break;
      case 1:
        y = getFirstNoneBlackY(x, y);
        yEnd = getNextBlackY(x, y);
        break;
      case 2:
        y = getFirstNoneBrightY(x, y);
        yEnd = getNextBrightY(x, y);
        break;
      case 3:
        y = getFirstNoneDarkY(x, y);
        yEnd = getNextDarkY(x, y);
        break;
      default:
        break;
    }
    
    if (y < 0) break;
    
    int sortingLength = yEnd-y;
    
    color[] unsorted = new color[sortingLength];
    color[] sorted = new color[sortingLength];
    
    for (int i = 0; i < sortingLength; i++) {
      if (willMovePixInSpiral) { 
        unsorted[i] = spiralImage.pixels[x + (y+i) * imgs[edition].width];
      } else if (willMovePixInCircle) {
        unsorted[i] = polarImage.pixels[x + (y+i) * imgs[edition].width];
      } else {
        unsorted[i] = imgs[edition].pixels[x + (y+i) * imgs[edition].width];
      }
    }
    
    sorted = sort(unsorted);
    if(sortInverse) {
      sorted = reverse(sorted);
    }

    for (int i = 0; i < sortingLength; i++) {
      imgs[edition].pixels[x + (y+i) * imgs[edition].width] = sorted[i];
    }
    
    y = yEnd+1;
    updateBand(y);
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

PVector noiseMove(int x, int y) {
  float noiseScale = 0.02;
  float noiseAngle = noise(x * noiseScale, y * noiseScale) * TWO_PI;
  return new PVector(
    abs(x + cos(noiseAngle)) % imgs[edition].width,
    abs(y + sin(noiseAngle)) % imgs[edition].height
  );
}
