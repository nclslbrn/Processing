//import processing.javafx.*;
import processing.pdf.*;
import javax.swing.*;

PGraphics canvas;

int numTrianglePerCircle = 7;
int drawStartTime = 0;
int drawDuration = 30000;
int alphaValue = 75;
int loopCount = 1;
int pdfCount = 10;
Grid grid;
ArrayList < Point_in_triangle > points = new ArrayList < Point_in_triangle > ();

void setup() {
    // 2250 × 3000 pixels
    // 72 to 300 dpi = *4,166666667
    // 9375 * 12500
    size(2250, 3000);
    init();
}

void init() {
      
    canvas = createGraphics(2250, 3000, PDF, "records/" + loopCount + ".pdf");
    canvas.beginDraw();
    
    //canvas.background(5);
    
    grid = new Grid(
        560, // cellWidth
        20 // cellPadding
    );
    points.clear();
    canvas.stroke(20);
    canvas.fill(0);

    for (int x = 0; x < grid.cols; x++) {

        for (int y = 0; y < grid.rows; y++) {

            int _x = x * grid.cellWidth;
            int _y = y * grid.cellWidth;
            
            for (int t = 0; t < numTrianglePerCircle; t++) {
               
                Point_in_triangle newPoint;
                newPoint = new Point_in_triangle(
                    getRandomPoints(
                        _x, 
                        _y, 
                        floor((grid.cellWidth-(grid.cellPadding*2.1)) / 2)
                    ),
                    color((255 / (numTrianglePerCircle+1)) * t+1),
                    alphaValue
                );
                points.add(newPoint);

            }
            canvas.rect(
                _x + grid.outer_x_margin + grid.cellPadding,  
                _y + grid.outer_y_margin + grid.cellPadding, 
                grid.cellWidth - (grid.cellPadding*2), 
                grid.cellWidth - (grid.cellPadding*2)
            );
        }
    }
    drawStartTime = millis();

    
}

void draw() {

    canvas.pushMatrix();
    canvas.translate(
        grid.outer_x_margin + (grid.cellWidth + grid.cellPadding) / 2, 
        grid.outer_y_margin + (grid.cellWidth + grid.cellPadding) / 2
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
