/**
* Attributed to Cliff Pickover
* Based on works/contribution by Paul Richards
* http://paulbourke.net/fractals/clifford/
*/
float a, b, c, d;
float x = 0;
float y = 0;
int step = 20;
int p = 0;
int iters;
ArrayList<PVector> points = new ArrayList<PVector>();

boolean preComputed = true;
JSONArray json;
JSONArray constant;
int constantNum = 0;

float minX = -4.0;
float minY = minX * height / width;

float maxX = 4.0;
float maxY = maxX * height / width;

void setup() {
  //size(800, 800); --> find new constant
  size(3508, 3508); // --> export for printing on A3 (width)
  noFill();
  strokeWeight(0.05);
  stroke(255, 25);
  
  iters = width * height; //= 15000000; //5000000;
  if( preComputed ) {
    json = loadJSONArray("constant.json");
  }
  println("Press \"n\" key to reinit constant,\n \"i\" to get the point draw count and \n \"s\" to save the sketch into image.");
  reinit();
}

void reinit() {
  if( ! preComputed ) {

    a = random(-2, 2);
    b = random(-2, 2);
    c = random(-2, 2);
    d = random(-2, 2);

  } else {
    
    if( constantNum < json.size()) {

      JSONObject currentConstant = json.getJSONObject(constantNum);      
      a = float( currentConstant.getString("a"));
      b = float( currentConstant.getString("b"));
      c = float( currentConstant.getString("c"));
      d = float( currentConstant.getString("d"));
      constantNum++;

    } else {
      println("Every constants has been read one time, we loop to the first value of the JSON file.");
      constantNum = 0;

    }
  }

  x = 0;
  y = 0;
  p = 0;
  points.clear();

  for( int i = 0; i < iters; i++) {
    
    float xn = sin(a * y) + c * cos(a * x);
    float yn = sin(b * x) + d * cos(b * y);
    float xi = (x - minX) * width / (maxX - minX);
    float yi = (y - minY) * height / (maxY - minY);
    points.add(new PVector(xi, yi));
    x = xn;
    y = yn;
  }

  background(0);
  println("{\"a\": \"" + a +"\", \"b\": \"" + b + "\", \"c\": \""+ c + "\", \"d\": \""+ d + "\"},");
}

void draw() {

  if( p < points.size() / step ) { 


    for( int s = 0; s < step; s++ ) {

      int point = p * s;
      point(points.get(point).x, points.get(point).y);
      
    }
    p++;
  
  } else {
    
    saveFrame("records/__a"+a+"__b"+b+"__c"+c+"__d"+d+".jpg");
    reinit();
  }
 
}

void keyPressed() {
  if( key == 'n' || key == 'N' ) {
    reinit();
  }
  if( key == 's' || key == 'S') {
    saveFrame("records/__a"+a+"__b"+b+"__c"+c+"__d"+d+"#####.jpg");
  }
  if( key == 'i' || key == 'I' ) {

    int perCent = int(map(p*step, 0, points.size(), 0, 100));
    
    print("[");
    for( int done = 0; done < perCent/10; done++ ) {
      print("#");
    }
    for( int todo = int(perCent/10); todo < 10; todo++ ) {
      print(" ");
    }
    print("][" + perCent + "%] ");
    println((p*step)+"/"+points.size() + "points" );
  }
}
