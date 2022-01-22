float t, c;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

void push() {
  pushMatrix();
  pushStyle();
}

void pop() {
  popStyle();
  popMatrix();
}

void draw() {
  if (recording) {
    result = new int[width*height][3];
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    c = 0;
    for (int sa=0; sa<samplesPerFrame; sa++) {
      t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
      draw_();
      loadPixels();
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += pixels[i] >> 16 & 0xff;
        result[i][1] += pixels[i] >> 8 & 0xff;
        result[i][2] += pixels[i] & 0xff;
      }
    }

    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = 0xff << 24 | 
        int(result[i][0]*1.0/samplesPerFrame) << 16 | 
        int(result[i][1]*1.0/samplesPerFrame) << 8 | 
        int(result[i][2]*1.0/samplesPerFrame);
    updatePixels();

    saveFrame("records/frame-###.jpg");
    if (frameCount==numFrames)
      exit();
  } else if (preview) {
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    t = (millis()/(20.0*numFrames))%1;
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
int[][] result;
int samplesPerFrame = 2,
    numFrames       = 60;     

float shutterAngle = .8;
boolean recording = false,
        preview = true;

float cellH, cellW, minCellW;
int rows = 12;

void setup() {
  size(800, 800);
  noStroke();
  cellH = 800.0 / rows;
  minCellW = cellH * 0.03;
  cellW = cellH;
}

void draw_() {
  float tt = t < 0.5 ? t : 1 - t;
  float dx = -width * (0.5 + t);
  float x = 0;

   cellW = cellH;
   background(245);
   
   while (dx < width * 1.5) {
     float tx = ease(map(dx, 0, width, -1, 1));

     if (tx > tt) {
       cellW *= 1.2;
     } else {
       cellW *= 0.8;
     }
     // cast value
     cellW = max(minCellW, cellW);
     cellW = min(cellW, cellH);

     for (int y = 0; y < rows; y++) {
       if ((x % 2 == 0 && y % 2 != 0) || (x % 2 != 0 && y % 2 == 0)) {
          fill(40);
       } else {
          fill(245);
       }

        rect(dx, y * cellH, cellW, cellH);
     }
     dx += cellW;
     x++;
   }
}
