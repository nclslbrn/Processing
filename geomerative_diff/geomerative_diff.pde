import geomerative.*;
import processing.svg.*;
Block block;

float offsetSize;
PGraphics export;
color[] buildingColor = {#F60201, #FDED01, #1F7FC9};

RShape[] roads, buildings;
int maxRoad = 46;
int roadBuiltCount = 0;

void setup() {
    size(800, 800);
    noStroke();
    offsetSize = sqrt(sq(width) + sq(height));

    RG.init(this);
    RG.ignoreStyles(false);
    RG.setPolygonizer(RG.ADAPTATIVE);

    buildings = new RShape[buildingColor.length];
    roads = new RShape[maxRoad];

    for( int c = 0; c < buildingColor.length; c++ ){
        buildings[c] = RShape.createRectangle(offsetSize, offsetSize, 1, 1);
        buildings[c].setFill(color(buildingColor[c]));
        buildings[c].setStroke(false);
    }
    String filename = (hour() + "-" + minute() + "-" + second());
    export = createGraphics(width, height, SVG, "records/"+filename+".svg");

}
void draw() {

    if( roadBuiltCount < maxRoad ) {

        Block roadProps = new Block(offsetSize, offsetSize, int(offsetSize/4), int(offsetSize), 2, 8);
        roads[roadBuiltCount] = RShape.createRectangle(
            roadProps.position.x, 
            roadProps.position.y,
            roadProps.rW, 
            roadProps.rH
        );
        roads[roadBuiltCount].setFill(color(#333333));
        roadBuiltCount++;
            
    } else {

        Block buildProps = new Block(offsetSize, offsetSize, 12, 64, 4, 32);        
        RShape newBuilding = RShape.createRectangle(
            buildProps.position.x, 
            buildProps.position.y,
            buildProps.rW,
            buildProps.rH
        );
        boolean isHoverRoad = false,
                isHoverBuilding = false;

        for( RShape road : roads ) {
            
            RPoint[] intersectedPoints = road.getIntersections(newBuilding);
            if( intersectedPoints != null ) {
                isHoverRoad = true;
            }
        }
        for( RShape building : buildings ) {
            RPoint[] intersectedPoints = building.getIntersections(newBuilding);
            if( intersectedPoints != null ) {
                isHoverBuilding = true;
            }
        } 
        if( ! isHoverRoad && ! isHoverBuilding ) {

            int colorId = int( random(1) * buildingColor.length );
            newBuilding.setFill(color(buildingColor[colorId]));
            buildings[colorId] = RG.union(buildings[colorId], newBuilding);
        }
        
    }
    if( mousePressed == true ) {
        export.beginDraw();
        export.background(255);
        export.translate(width/2, -height/2);
        export.rotate(QUARTER_PI);
        for( RShape road : roads ) {
            road.draw(export);
        }
        for( RShape building : buildings) {
            building.draw(export);
        }
        export.dispose();
        export.endDraw();
    }

    background(255);
    translate(width/2, -height/2);
    rotate(QUARTER_PI);

    
    for( RShape road : roads ) {
        if( road != null ) {
            road.draw();
        }
    }
    
    for( RShape building : buildings) {
        if( building != null ) {
            building.draw();
        }
    }
}