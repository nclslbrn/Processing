import geomerative.*;
import processing.svg.*;

float offsetSize;
RShape initialShape, updateShape;
PGraphics export;
// tundra2 from https://kgolid.github.io/chromotome-site/
color[] buildingColor = {#5f9e93, #3d3638, #733632, #b66239, #b0a1a4, #e3dad2};
RShape[] buildings;

void setup() {
    size(800, 800);
    fill(0);
    noStroke();
    offsetSize = sqrt(sq(width) + sq(height));

    RG.init(this);
    RG.ignoreStyles(false);
    RG.setPolygonizer(RG.ADAPTATIVE);
    
    initialShape = RShape.createRectangle(offsetSize, offsetSize, 1, 1);
    initialShape.setFill(0);
    initialShape.setStroke(false);

    buildings = new RShape[buildingColor.length];
    for( int c = 0; c < buildingColor.length; c++ ){
        buildings[c] = RShape.createRectangle(offsetSize, offsetSize, 1, 1);
        buildings[c].setFill(color(buildingColor[c]));
        buildings[c].setStroke(false);
    }
    String filename = (hour() + "-" + minute() + "-" + second());
    export = createGraphics(width, height, SVG, "records/"+filename+".svg");

}

void draw() {
    // Generate road
    if( frameCount % 26 == 0 ) {

        float x = random(1) * offsetSize;
        float y = random(1) * offsetSize;
        boolean direction = random(1) < 0.5;
        float rW = direction ? random(2, 8) : random(1)*offsetSize/2;
        float rH = direction ? random(1)*offsetSize/2 : random(2, 8);
        RShape voidBlock = RShape.createRectangle(x,y,rW,rH);

        initialShape = RG.union(initialShape, voidBlock);
        for( int b = 0; b < buildings.length; b++) {
            buildings[b] = buildings[b].diff(RShape.createRectangle(x-2,y-2,rW+4,rH+4));
        }
    }
    // Generate building
    if( frameCount % 2 == 0 ) {
        int colorId = int(random(1) * buildingColor.length);
        float x = random(1) * offsetSize;
        float y = random(1) * offsetSize;
        boolean direction = random(1) < 0.5;
        float rW = direction ? random(12, 36) : random(6, 16);
        float rH = direction ? random(6, 16) : random(2, 8);

        RShape fillBlock = RShape.createRectangle(x,y,rW,rH);
        fillBlock.setFill(color(buildingColor[colorId]));
        RPoint[] intersectedPoints = initialShape.getIntersections(fillBlock);
        if( intersectedPoints == null ) {
            buildings[colorId] = RG.union(buildings[colorId], fillBlock);
        }
    }
    // Generate SVG file
    if( mousePressed == true ) {
        export.beginDraw();
        export.background(255);
        export.translate(width/2, -height/2);
        export.rotate(QUARTER_PI);
        initialShape.draw(export);
        for( RShape building : buildings) {
            building.draw(export);
        }
        export.dispose();
        export.endDraw();
    }

    background(255);
    translate(width/2, -height/2);
    rotate(QUARTER_PI);
    initialShape.draw();
    for( RShape building : buildings) {
        building.draw();
    }
}