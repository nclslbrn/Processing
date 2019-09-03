ArrayList<FlatCube> flatCubes = new ArrayList<FlatCube>();
int cubeWidth = 120;
int cols;
int rows;
int numCubes;

color[] colors = {
  color(255, 0, 0),
  color(0, 255, 0),
  color(0, 0, 255)
};

void setup() {

  size(600, 600);
  noStroke();
  ellipseMode(CENTER);
  //stroke(120);
  //strokeWeight(12);
  
  // pay attention width/cubeWidth & height/cubeWidth
  // must be an integer
  cols = ( width / cubeWidth ) + 1;
  rows = ( height / cubeWidth ) + 1;
  numCubes = cols * (rows*2);
  
  int colNum = 0;
  for( int x = 0; x < width + cubeWidth; x+= cubeWidth ) {
    
    int rowNum = 0;
    float centerX = x;

    for( int y = 0; y < height + cubeWidth; y+= cubeWidth ) {

      float centerY = y;
      
      
      if( rowNum % 2 == 0) {
        centerX = x + cubeWidth/2; 

      } else {
        centerX = x - cubeWidth;
      }
      
      FlatCube newCube = new FlatCube(
        new PVector(centerX, centerY),
        cubeWidth,
        colors,
        atan(0.5)
      );
      flatCubes.add( newCube );
      rowNum++;
    }
    colNum++;
  }  
}

void draw() {

  background(0);
  
  for( int c = 0; c < flatCubes.size(); c++ ) {

    FlatCube cube = flatCubes.get(c);
    cube.display();
  }
  noLoop();
}
