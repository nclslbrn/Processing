import geomerative.*;
String[] words = {"GOOD", "BAD" };
RPoint[][] phrasePoints;
RShape shapes;
RFont bebas;

int num_frame = 75;

void setup(){
    size(800,800);

    stroke(255);
    noFill();
    RG.init(this);
    bebas = new RFont("BebasNeue Bold.ttf", 460, CENTER);
    createPhrasesPoints(words);
}

  void createPhrasesPoints(String []phrases) {
    phrasePoints = new RPoint[phrases.length][];
    for (int i =0; i<phrases.length; i++) {
      RGroup myGroup = bebas.toGroup(phrases[i]);
      myGroup = myGroup.toPolygonGroup();
      phrasePoints[i] = myGroup.getPoints();
    }
  }


void draw() {

    float t = map(frameCount % num_frame, 0, num_frame, 0, 1);
    int word_id = (frameCount / num_frame % 2 == 0 ) ? 0 : 1;

    background(0);
    translate(width/2, height/1.5);
    beginShape();
    
    int x = 0;
    int y = 0; 

    for( int point = 0; point < phrasePoints[word_id].length; point++ ) {

        if( point < phrasePoints[word_id == 0 ? 1 : 0].length ) {
          PVector lerp_point = PVector.lerp(
            new PVector(
              phrasePoints[word_id][point].x, 
              phrasePoints[word_id][point].y
            ),
            new PVector(
              phrasePoints[word_id == 0 ? 1 : 0][point].x, 
              phrasePoints[word_id == 0 ? 1 : 0][point].y
            ),
            t
          );

          vertex(
              lerp_point.x, 
              lerp_point.y
          );
        } else {
          vertex(
            phrasePoints[word_id][point].x, 
            phrasePoints[word_id][point].y
          );
        }
    }
    endShape();
}