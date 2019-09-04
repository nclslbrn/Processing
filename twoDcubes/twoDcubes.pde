ArrayList<FlatCube> flatCubes = new ArrayList<FlatCube>();

int cubeWidth = 60,
    animFrame = 512,
    cols,
    rows,
    numCubes;

float angle = atan(0.5);

color[] colors = {
  color(255, 0, 0),
  color(0, 255, 0),
  color(0, 0, 255)
};

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

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

    for( float y = 0; y < height + cubeWidth; y+= cubeWidth*1.5 ) {
      FlatCube newCube = new FlatCube(
        new PVector(x, y),
        cubeWidth,
        colors,
        angle
      );
      flatCubes.add( newCube );
    }
    for( float y = cubeWidth*0.75; y < height+cubeWidth; y+= cubeWidth*1.5 ) {
      FlatCube newCube = new FlatCube(
        new PVector(x-cubeWidth/2, y),
        cubeWidth,
        colors,
        angle
      );
      flatCubes.add( newCube );
    }
    colNum++;
  }  
}

void draw() {
  
  float t;
  background(0);

  if( frameCount < animFrame ) {
    t = frameCount / animFrame;
  } else {
    t = (frameCount % animFrame) / animFrame;
  }
  println(t);

  for( int c = 0; c < flatCubes.size(); c++ ) {

    FlatCube cube = flatCubes.get(c);
    cube.display();
  }
}
