IntList trngl_x;
IntList trngl_y;
IntList trngl_width;
IntList trngl_height;

// Create a grid
int sketchWidth = 720;
int sketchHeight = 860;

int cells = 25;
int regularSize = sketchWidth / cells;
int cellSizeVariation = regularSize / cells;
float xIncrement = -cellSizeVariation;
float yIncrement = -cellSizeVariation;

float xIncrementFactor = regularSize / 10;
float yIncrementFactor = regularSize / 10;
float initStep = (cellSizeVariation / cells) * regularSize - 1;
float xIncrementStep = initStep * xIncrementFactor;
float yIncrementStep = initStep * yIncrementFactor;

float cellWidth = regularSize + xIncrement;
float cellHeight = regularSize + yIncrement;
float xPos = 0;
float yPos = 0;
int totalTriangles = 0;


void setup() {
  
  size( 720, 860 );
  background(255);
    
}


void draw() {

    fill(0);

      if( xPos + cellWidth < sketchWidth ) {
        
        // DRAW
        
        if( yPos + cellHeight < sketchHeight ) {

            if( yIncrement > cellSizeVariation ) {
              
                yIncrementStep--;
            }
            
            if( yIncrement < -cellSizeVariation ) {
              
                yIncrementStep++;
            }
            
            yIncrement += yIncrementStep;

            cellHeight = regularSize + yIncrement;
            
            triangle(
              xPos, yPos,
              xPos + cellWidth, yPos + cellHeight,
              xPos, yPos + cellHeight
            );
     
            yPos = yPos + cellHeight;
            totalTriangles++;
      
       
        } else { 

            yIncrementStep = initStep * yIncrementFactor;
            yIncrement = -cellSizeVariation;
            yPos = 0;

            if( xIncrement > cellSizeVariation ) {
              
                xIncrementStep--;
            }
            
            if( xIncrement < -cellSizeVariation ) {
              
                xIncrementStep++;
            }
            
            xIncrement += xIncrementStep;
            cellWidth = regularSize + xIncrement;
            xPos = xPos + cellWidth;

        }
      
    } else { // last cell of the column


        background(255);
        totalTriangles = 0;
        xPos = yPos = 0;
        cells -= 3;
    }
    
}
