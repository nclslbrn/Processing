import geomerative.*;
float offsetSize;
RShape initialShape, updateShape;
PImage export;

void setup() {
    size(800, 800);
    fill(255);
    noStroke();
    offsetSize = sqrt(sq(width) + sq(height));

    RG.init(this);
    RG.ignoreStyles(false);
    RG.setPolygonizer(RG.ADAPTATIVE);
    initialShape = RShape.createRectangle(0, 0, offsetSize, offsetSize);
    export = createImage(width, height, RGB);

}

void draw() {

    background(0);
    fill(255);
    rect(-10,-10,width+20,height+20);

    if( frameCount % 12 == 0 ) {

        float x = random(1) * offsetSize;
        float y = random(1) * offsetSize;
        boolean direction = random(1) < 0.5;
        float rW = direction ? random(2, 8) : random(1)*offsetSize/2;
        float rH = direction ? random(1)*offsetSize/2 : random(2, 8);

        RShape voidBlock = RShape.createRectangle(x,y,rW,rH);

        initialShape = RG.diff(initialShape, voidBlock);
    }
    if( frameCount % 2 == 0 ) {

        float x = random(1) * offsetSize;
        float y = random(1) * offsetSize;
        boolean direction = random(1) < 0.5;
        float rW = direction ? random(12, 36) : random(4, 12);
        float rH = direction ? random(4, 12) : random(2, 8);

        RShape voidBlock = RShape.createRectangle(x-2,y-2,rW+4,rH+4);
        RShape fillBlock = RShape.createRectangle(x,y,rW,rH);

        initialShape = RG.diff(initialShape, voidBlock);
        initialShape = RG.union(initialShape, fillBlock);
    }
    background(0);
    translate(width/2, -height/2);
    rotate(QUARTER_PI);
    fill(255);
    initialShape.draw();
    loadPixels();
    export.pixels = pixels;
    export.updatePixels();

    if( mousePressed == true ) {
        export.save("records/frame###.png");
    }

}