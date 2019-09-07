ArrayList<FlatCube> flatCubes = new ArrayList<FlatCube>();

int cubeWidth  = 60,
    animFrame  = 256,
    noiseScale = 300,
    noiseRadius = 2,
    cols,
    rows,
    numCubes;

float angle = atan(0.5);

color[] colors = {
  color(50),
  color(150),
  color(200)
};
color[] currentColor = {
  color(50,0,0),
  color(150,0,0),
  color(200,0,0)
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
boolean isCubeInCenter(int c) {
  if( c+floor(numCubes/2) % numCubes == 0 ) {
      return true;
  } else {
    return false;
  }
}

void setup() {

  size(600, 600);
  noStroke();
  
  // pay attention width/cubeWidth & height/cubeWidth
  // must be an integer
  cols = ( width / cubeWidth ) + 1;
  rows = ( height / cubeWidth ) + 2;

  int cubeNum = 0;
  for( int x = 0; x < width + cubeWidth; x+= cubeWidth ) {
        
    for( float y = -cubeWidth; y < height+cubeWidth; y+= cubeWidth*1.5 ) {
      
      FlatCube bottomCube = new FlatCube(
        new PVector(x, y),
        cubeWidth,
        colors,
        angle
      );
      
      FlatCube upperCube = new FlatCube(
        new PVector(x-cubeWidth/2, y+(cubeWidth*0.75)),
        cubeWidth,
        colors,
        angle
      );
      

      upperCube.init();
      bottomCube.init();
      
      flatCubes.add(upperCube);
      flatCubes.add(bottomCube);
      numCubes+= 2;
    }

  }
  println(cols + " * " + rows + " = " + ((rows*2) * cols) + " != " + numCubes);
}

void draw() {
  
  float t, width, r;
  int currentCubeID;
  background(0);

  if( frameCount <= animFrame ) {
    t = 1.0 * (frameCount-1) / animFrame;
  } else {
    t = (1.0* (frameCount % animFrame)) / animFrame;
  }
  currentCubeID = ceil( map(t, 0, 1, 0, flatCubes.size()));

  for( int c = 0; c < flatCubes.size(); c++ ) {
    FlatCube cube = flatCubes.get(c);
    
    //if( c == currentCubeID ) {
    if( isCubeInCenter(c) ) {
    
      FlatCube newCube = new FlatCube(
        cube.center,
        cubeWidth,
        currentColor,
        angle
      );

      newCube.init();
      newCube.display();

    } else {
      
      cube.display();

    }
  }
  if( mousePressed == true) {
     exit(); 
  }
}
