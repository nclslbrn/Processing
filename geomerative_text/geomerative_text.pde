import geomerative.*;
String[] words = {"GOOD", "BAD", "UGLY", "NICE" };
RPoint[][] phrasePoints;
RPoint[][][] points;

RShape shapes;
RFont bebas;
int word_id = 0;
int num_frame = 75;

void setup(){
  size(800,800);
  noStroke();
  fill(255);

  RG.init(this);
  bebas = new RFont("BebasNeue Bold.ttf", 460, CENTER);
  createtextsPoints(words);
}

void createtextsPoints(String []texts) {
  
  phrasePoints = new RPoint[texts.length][];
  points = new RPoint[texts.length][][];

  for (int word_id = 0; word_id < texts.length; word_id++) {

    RGroup letters = bebas.toGroup(texts[word_id]);
    points = new RPoint[word_id][texts[word_id].length()][];

    letters = letters.toPolygonGroup();
    
    for( int letter_id = 0; letter_id < texts[word_id].length(); letter_id++ ) {

      char current_letter = texts[word_id].charAt(letter_id);
      RPolygon letterPoly = bebas.toPolygon(current_letter);
      RPoint[] letterPoints = letterPoly.getPoints();
      println(letterPoints.length);
      points = new RPoint[word_id][letter_id][letterPoints.length];
      
      for( int point_id = 0; point_id < letterPoints.length; point_id++ ) {
        points[word_id][letter_id][point_id] = RPoint(letterPoints, point_id);
      }
/*
      //letterPoly = letterPoly.toPolygonGroup();
      RPoint[] letterPoints = letterPoly.getPoints();
      println( letterPoly.getType() );
      points[word_id][letter_id]= letterPoints;
*/
    }
    phrasePoints[word_id] = letters.getPoints();
  
  }
}


void draw() { 

    background(0);
    translate(width/2, height/1.5);
    beginShape();


    if( frameCount != 0 && frameCount % num_frame == 0  ) {
      word_id++;
    }
    if( word_id >= phrasePoints.length) {      
      word_id = 0;
    }

    int nextWord =  word_id < phrasePoints.length-1 ? word_id+1 : 0;

    //println( nextWord + " / " + phrasePoints.length);

    float t = map(frameCount % num_frame, 0, num_frame, 0, 1);

    for( int point = 0; point < phrasePoints[word_id].length; point++ ) {

      int nextWordPoint = point < phrasePoints[nextWord].length ? point : 0;

      //println( nextWordPoint + " / " + phrasePoints[nextWord].length);
      
      PVector lerp_point = PVector.lerp(
        new PVector(
          phrasePoints[word_id][point].x, 
          phrasePoints[word_id][point].y
        ),
        new PVector(
          phrasePoints[nextWord][nextWordPoint].x, 
          phrasePoints[nextWord][nextWordPoint].y
        ),
        t
      );

      vertex(
          lerp_point.x, 
          lerp_point.y
      );
      
    }
    endShape();

    if( mousePressed == true ) {
      exit();
    }
}