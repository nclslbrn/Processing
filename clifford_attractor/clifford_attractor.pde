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
int devSize = 800;
int prodSize = 3508;
//used to find new constant (false) or to compute HD pict (true)
boolean exporting = true;

JSONArray json;
JSONArray constant;
int constantNum = 0;

float minX = -4.0;
float minY = minX * height / width;

float maxX = 4.0;
float maxY = maxX * height / width;

void settings() {
  if( exporting ) {
    size(prodSize, prodSize);
  } else { //--> find new constant
    size(devSize, devSize);
  }
}
void setup() {
  smooth(1);
  strokeWeight(0.5);
  stroke(255, exporting ? 255 : 150);
  
  iters = exporting ? 1000000 : 150000;
  if( exporting ) {
    json = loadJSONArray("constant.json");
  }
  println(
    "KEYBOARDS SHORTCUTS \n"+
    "\"n\" key to reinit constant \n" +
    "\"c\" to print a, b, c, and d values \n"+
    "\"i\" to get percentage progressiopreComputedn \n"+
    "\"s\" to save the sketch into image."
  );
  reinit();
}

void reinit() {
  if( ! exporting ) {

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
  background(0);
}

void draw() {

  if( p < iters ) { 

    float xn = sin(a * y) + c * cos(a * x);
    float yn = sin(b * x) + d * cos(b * y);
    float xi = (x - minX) * width / (maxX - minX);
    float yi = (y - minY) * height / (maxY - minY);
    if( p > 10 ) {
      point(xi, yi);
    }
    x = xn;
    y = yn;
    p++;
  
  } else {
    
    saveFrame("records/__a"+a+"__b"+b+"__c"+c+"__d"+d+".jpg");
    reinit();
  }
 
}

void keyPressed() {
  
  if(key == 'n' || key == 'N') {
    reinit();
  }
  
  if(key == 's' || key == 'S') {
    saveFrame("records/__a"+a+"__b"+b+"__c"+c+"__d"+d+"__#####.jpg");
  }
  
  if(key == 'c' || key == 'C') {
    println("{\"a\": \"" + a +"\", \"b\": \"" + b + "\", \"c\": \""+ c + "\", \"d\": \""+ d + "\"},");
  }

  if(key == 'i' || key == 'I') {

    int perCent = int(map(p, 0, iters, 0, 100));
    
    for( int done = 0; done < perCent/5; done++ ) {
      print("█");
    }
    for( int todo = int(perCent/5); todo < 20; todo++ ) {
      print("-");
    }
    print("[" + perCent + "%] ");
    println(p + "/"+ iters + " points" );
  }
}
