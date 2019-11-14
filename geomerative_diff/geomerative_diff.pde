import geomerative.*;
import processing.svg.*;
Block block;

float offsetSize;
PGraphics export;
color[] buildingColor = {#F60201, #FDED01, #1F7FC9};
RShape[] roads, buildings;
PShape[] extrudedBuilding;
int[] buildingColorsId;
int maxRoad = 46;
int maxBuilding = 300;


boolean debug = true;

void setup() {

    size(800, 800, P3D);
    lights();
    //noStroke();
    
    offsetSize = sqrt(sq(width) + sq(height));

    RG.init(this);
    RG.ignoreStyles(false);
    RG.setPolygonizer(RG.ADAPTATIVE);

    roads = new RShape[maxRoad];
    buildings = new RShape[maxBuilding];
    buildingColorsId = new int[maxBuilding];
    extrudedBuilding = new PShape[maxBuilding];
    String filename = (hour() + "-" + minute() + "-" + second());
    export = createGraphics(width, height, SVG, "records/"+filename+".svg");
    initCity();
}

PShape twoDShapeToThreeD(RShape shape, int depth, int index) {

    RPoint[] points = shape.getPoints();
    PShape currentExtrudedBuilding = createShape();
    currentExtrudedBuilding.beginShape(QUAD_STRIP);

    for( RPoint point : points ) {
        currentExtrudedBuilding.vertex( point.x, point.y, 0);
    }
    for( RPoint point : points ) {
        currentExtrudedBuilding.vertex( point.x, point.y, -depth);
    }
    currentExtrudedBuilding.endShape(CLOSE);

    return currentExtrudedBuilding;

}


void initCity() {

    int roadBuiltCount = 0;
    int buildingBuiltCount = 0;

    while( roadBuiltCount < maxRoad && buildingBuiltCount < maxBuilding ) {

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
                
        } else if( buildingBuiltCount < maxBuilding ) {

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

                if( building != null ) {

                    RPoint[] intersectedPoints = building.getIntersections(newBuilding);

                    if( intersectedPoints != null ) {
                        isHoverBuilding = true;
                    }
                }
            }
            
            if( ! isHoverRoad && ! isHoverBuilding ) {

                int colorId = int( random(1) * buildingColor.length );
                int buildingHeight = int( random( 2, 15) );

                newBuilding.setFill(color(buildingColor[colorId]));
                buildings[buildingBuiltCount] = newBuilding;
                buildingColorsId[buildingBuiltCount] = colorId;
                PShape threeDBuilding = twoDShapeToThreeD( newBuilding, buildingHeight, buildingBuiltCount);
                println(threeDBuilding);
                extrudedBuilding[buildingBuiltCount] = threeDBuilding;
                buildingBuiltCount++;
            }
            
        }

    }
}

void draw() {
/*
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
*/
    background(255);
    translate(width/2, -height/2);
    rotate(QUARTER_PI);

    
    for( RShape road : roads ) {
        if( road != null ) {
            road.draw();
        }
    }
    for(int b =  0; b < maxBuilding; b++ ) {
        if( extrudedBuilding[b] != null ) {

            fill(buildingColor[buildingColorsId[b]]);
            shape(extrudedBuilding[b]);
        }
    }
    /*
    for( int b = 0; b < maxBuilding; b++ ) {

        if( extrudedBuilding[b] != null ) {
            //building.draw();
            shape(extrudedBuilding[b]);
        }
    }
    */
}