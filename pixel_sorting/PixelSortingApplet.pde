
public class PixelSortingApplet extends PApplet {
  public void settings() {
    size(1000, 1000);
    noLoop();
  }

  public void setup() {
    surface.setResizable(true);
    surface.setSize(imgs[edition].width, imgs[edition].height);
    //surface.setLocation(40, 40);
    image(imgs[edition], 0, 0, width, height);
    init();
  }

  public void draw() {
    imgs[edition] = original[edition].get();

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
    init();
  }

  public void init() {
   row = 0;
   column = 0;
   bandSize = 8;
   lastBandPos = 0;
   imgs[edition] = original[edition].get();
   saved = false;

   if (willMovePixInCircle) {
     polarImage = polarInterpolation(imgs[edition], 1.45).get();
   }
   if (willMovePixInSpiral) {
     spiralImage = spiralInterpolation(imgs[edition]).get();
   }
   if (willMovePixBitwise) {
     bitwiseImage = bitwiseInterpolation(imgs[edition]).get();
   }
   println(
      "#" + edition +
      " sort [ " + (willSortColumn ? "column " : "") + (willSortRow ? "row " : "") + "]" +
      (willMovePixInSpiral || willMovePixInCircle ? " on " : "") +
      (willMovePixInSpiral ? "spiral" : "") + (willMovePixInCircle ? "circle" : "") +
      (useNoiseDisplacement ? " - noise" : "")
   );
   redraw();
  }

  public void mousePressed() {
    if ( ! saved ) {
      String timeStamp = "-" + String.valueOf(year() + "-" + month() + "-" + day() + "-T-" + hour() + ":" + minute() + ":" + second());  
      imgs[edition].save(
        "output/" + imgFileName + edition + "-" +
        (willSortColumn ? "column-" : "") + (willSortRow ? "row-" : "") +
        (willMovePixInSpiral ? "spiral" : "") + (willMovePixInCircle ? "circle" : "") + (willMovePixBitwise ? "bitwise" : "") + timeStamp + 
        ".png"
      );
      saved = true;
      println("Saved edition " + edition);
    }
  }
}
