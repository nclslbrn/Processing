//import processing.javafx.*;
import processing.pdf.*;
import javax.swing.*;

PGraphics canvas;

int numTrianglePerCircle = 7;
int drawStartTime = 0;
int drawDuration = 20000;
int alphaValue = 126;
int innerMargin = 10;
int pdfCount = 10;
Grid grid;
ArrayList < Point_in_triangle > points = new ArrayList < Point_in_triangle > ();
int loopCount = 0;

void setup() {
    // 2250 × 3000 pixels / 2.5
    size(3000, 2250);
    surface.setVisible(false);
    init();
}

void init() {
      
    canvas = createGraphics(3000, 2250, PDF, "records/" + loopCount + ".pdf");
    canvas.beginDraw();
    
    // canvas.background(0);
    canvas.strokeWeight(0.5);
    
    grid = new Grid();
    points.clear();
    grid.cellMargin = innerMargin * 2;
    grid.cellWidth = 900; //(int) random(400, 600);
    grid.init();

    for (int x = 0; x < grid.cols; x++) {

        for (int y = 0; y < grid.rows; y++) {

            int _x = x * (grid.cellWidth + grid.cellMargin);
            int _y = y * (grid.cellWidth + grid.cellMargin);
            
            for (int t = 0; t < numTrianglePerCircle; t++) {
               
                Point_in_triangle newPoint;
                newPoint = new Point_in_triangle(
                    getRandomPoints(_x, _y, (grid.cellWidth-grid.cellMargin) / 2),
                    color((255 / numTrianglePerCircle) * t),
                    alphaValue
                );
                points.add(newPoint);

            }
            canvas.stroke(50);
            canvas.fill(0);
            canvas.rect(
                grid.outer_x_margin + _x,  
                grid.outer_y_margin + _y, 
                grid.cellWidth - innerMargin, 
                grid.cellWidth - innerMargin
            );
        }
    }
    drawStartTime = millis();

    
}

void draw() {

    canvas.pushMatrix();
    canvas.translate(
        grid.outer_x_margin + (grid.cellWidth / 2) + innerMargin, 
        grid.outer_y_margin + (grid.cellWidth / 2) + innerMargin
    );
    for (int p = 0; p < points.size() - 1; p++) {

        Point_in_triangle point = points.get(p);
        point.display(canvas);

    }
    canvas.popMatrix();

    if (millis() > drawStartTime + drawDuration) {
      
        canvas.dispose();
        canvas.endDraw();
        println("PDF saved : " + loopCount + ".pdf");
        
        if( loopCount == pdfCount ) {
            exit();
        }
        
        loopCount++;
        init();
    }

}
