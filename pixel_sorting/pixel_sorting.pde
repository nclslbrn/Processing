
/********

 ASDF Pixel Sort
 Kim Asendorf | 2010 | kimasendorf.com
 
 Sorting modes
 0 = white
 1 = black
 2 = bright
 3 = dark
 
 */

int mode = 0;

// image path is relative to sketch directory
String imgFileName = "Stacks-";
int edition = 1;
int editionNum = 50;
String fileType = "png";
PImage[] imgs = new PImage[editionNum];

int loops = 1;

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
int bandSize = 32;
int lastBandPos = 0;
boolean sortInverse = false;

int row = 0;
int column = 0;

boolean saved = false;

void setup() {
  for (int i = 0; i < editionNum; i++) { 
    imgs[i] = loadImage("sample/" + imgFileName + i + "." + fileType);
    // println("sample/" + imgFileName + i + "." + fileType + " loaded");
  }
  // use only numbers (not variables) for the size() command, Processing 3
  size(1, 1);
  surface.setResizable(true);
  surface.setSize(imgs[edition].width, imgs[edition].height);
  image(imgs[edition], 0, 0, width, height);
}


void draw() {
  
  if (frameCount <= loops) {
    // loop through columns
    println("Sorting Columns");
    while (column < imgs[edition].width-1) {
      imgs[edition].loadPixels();
      sortColumn();
      column++;
      imgs[edition].updatePixels();
      mode = column % 4; // floor(random(4));
    }
    
    // loop through rows
    println("Sorting Rows");
    while (row < imgs[edition].height-1) {
      imgs[edition].loadPixels();
      sortRow();
      row++;
      imgs[edition].updatePixels();
      mode = row % 4; // floor(random(4));
    }
    println( "edition #" + edition + " sorted" );
  }
  
  // load updated image onto surface and scale to fit the display width and height
  image(imgs[edition], 0, 0, width, height);
}

void keyPressed() {
   if (keyCode == LEFT) {
      if (edition > 0)  edition--;
    }
    
    if(keyCode == RIGHT) {
      if (edition < editionNum-1) edition++;
    }
    loops = frameCount + 1;
    row = 0;
    column = 0;
    image(imgs[edition], 0, 0, width, height);
    saved = false;
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
  
  while (xEnd < imgs[edition].width-1) {
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
      unsorted[i] = imgs[edition].pixels[x + i + y * imgs[edition].width];
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
  
  while (yEnd < imgs[edition].height-1) {
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
      unsorted[i] = imgs[edition].pixels[x + (y+i) * imgs[edition].width];
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
      bandSize = ceil(random(1, 8)) * 32;
  }
}

// white x
int getFirstNoneWhiteX(int x, int y) {
  while (imgs[edition].pixels[x + y * imgs[edition].width] < whiteValue) {
    x++;
    if (x >= imgs[edition].width) return -1;
  }
  return x;
}

int getNextWhiteX(int x, int y) {
  x++;
  while (imgs[edition].pixels[x + y * imgs[edition].width] > whiteValue) {
    x++;
    if (x >= imgs[edition].width) return imgs[edition].width-1;
  }
  return x-1;
}

// black x
int getFirstNoneBlackX(int x, int y) {
  while (imgs[edition].pixels[x + y * imgs[edition].width] > blackValue) {
    x++;
    if (x >= imgs[edition].width) return -1;
  }
  return x;
}

int getNextBlackX(int x, int y) {
  x++;
  while (imgs[edition].pixels[x + y * imgs[edition].width] < blackValue) {
    x++;
    if (x >= imgs[edition].width) return imgs[edition].width-1;
  }
  return x-1;
}

// bright x
int getFirstNoneBrightX(int x, int y) {
  while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) < brightValue) {
    x++;
    if (x >= imgs[edition].width) return -1;
  }
  return x;
}

int getNextBrightX(int x, int y) {
  x++;
  while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) > brightValue) {
    x++;
    if (x >= imgs[edition].width) return imgs[edition].width-1;
  }
  return x-1;
}

// dark x
int getFirstNoneDarkX(int x, int y) {
  while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) > darkValue) {
    x++;
    if (x >= imgs[edition].width) return -1;
  }
  return x;
}

int getNextDarkX(int x, int y) {
  x++;
  while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) < darkValue) {
    x++;
    if (x >= imgs[edition].width) return imgs[edition].width-1;
  }
  return x-1;
}

// white y
int getFirstNoneWhiteY(int x, int y) {
  if (y < imgs[edition].height) {
    while (imgs[edition].pixels[x + y * imgs[edition].width] < whiteValue) {
      y++;
      if (y >= imgs[edition].height) return -1;
    }
  }
  return y;
}

int getNextWhiteY(int x, int y) {
  y++;
  if (y < imgs[edition].height) {
    while (imgs[edition].pixels[x + y * imgs[edition].width] > whiteValue) {
      y++;
      if (y >= imgs[edition].height) return imgs[edition].height-1;
    }
  }
  return y-1;
}


// black y
int getFirstNoneBlackY(int x, int y) {
  if (y < imgs[edition].height) {
    while (imgs[edition].pixels[x + y * imgs[edition].width] > blackValue) {
      y++;
      if (y >= imgs[edition].height) return -1;
    }
  }
  return y;
}

int getNextBlackY(int x, int y) {
  y++;
  if (y < imgs[edition].height) {
    while (imgs[edition].pixels[x + y * imgs[edition].width] < blackValue) {
      y++;
      if (y >= imgs[edition].height) return imgs[edition].height-1;
    }
  }
  return y-1;
}

// bright y
int getFirstNoneBrightY(int x, int y) {
  if (y < imgs[edition].height) {
    while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) < brightValue) {
      y++;
      if (y >= imgs[edition].height) return -1;
    }
  }
  return y;
}

int getNextBrightY(int x, int y) {
  y++;
  if (y < imgs[edition].height) {
    while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) > brightValue) {
      y++;
      if (y >= imgs[edition].height) return imgs[edition].height-1;
    }
  }
  return y-1;
}

// dark y
int getFirstNoneDarkY(int x, int y) {
  if (y < imgs[edition].height) {
    while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) > darkValue) {
      y++;
      if (y >= imgs[edition].height) return -1;
    }
  }
  return y;
}

int getNextDarkY(int x, int y) {
  y++;
  if (y < imgs[edition].height) {
    while (brightness(imgs[edition].pixels[x + y * imgs[edition].width]) < darkValue) {
      y++;
      if (y >= imgs[edition].height) return imgs[edition].height-1;
    }
  }
  return y-1;
}
