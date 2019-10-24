import geomerative.*;
String[] french_phrase = {
  "Jure", "Crache", "Dénature", 
  "Discrédite", "Nie", "Jase",
  "Doute", "Dénigre", "Sous-estime",
  "Applaudis"
};

String[] english_phase = {
  "Swear", "Spit", "Misrepresent", 
  "Discredit", "Deny", "Gossip",
  "Doubt", "Criticize", "Underestimate",
  "Applause"

};

PVector[][][] wordVectors;

RFont bebas;
int word_id = 0;
int num_frame = 150;
int num_letters = 0;

void setup(){
  size(800,800);
  noFill();
  stroke(255);
  strokeWeight(2);
  smooth(10);

  RG.init(this);
  RG.ignoreStyles(false);
  RG.setPolygonizer(RG.UNIFORMLENGTH);

  bebas = new RFont("BebasNeue Bold.ttf", 260, CENTER);
  String[] words = french_phrase;

  createtextsPoints(words);
}

void createtextsPoints(String []texts) {
  
  int global_letter_index = 0;
  wordVectors = new PVector[texts.length][][];

  for (int word_id = 0; word_id < texts.length; word_id++) {
    
    RGroup letters = bebas.toGroup(texts[word_id]);
    RShape wordShape = letters.toShape();
    letters = letters.toPolygonGroup();
    RPoint[][] wordPoints = wordShape.getPointsInPaths();
    wordVectors[word_id] = new PVector[wordPoints.length][];
    
    for( int group_id = 0; group_id < wordPoints.length; group_id++) {
      
      wordVectors[word_id][group_id] = new PVector[wordPoints[group_id].length];

      for( int point_id = 0; point_id < wordPoints[group_id].length; point_id++ ) {
      
        wordVectors[word_id][group_id][point_id] = new PVector( 
          wordPoints[group_id][point_id].x, 
          wordPoints[group_id][point_id].y 
        );

      } 
    }
  }
}


void draw() { 

    background(0);
    translate(width/2, height/1.5);

    if( frameCount != 0 && frameCount % num_frame == 0  ) {
      word_id++;
    }
    if( word_id >= wordVectors.length) {      
      word_id = 0;
    }

    int nextWordId =  word_id < wordVectors.length-1 ? word_id + 1 : 0;
    float t = map(frameCount % num_frame, 0, num_frame, 0, 1);
  
    for( int group_id = 0; group_id < wordVectors[word_id].length; group_id++ ) {
      
      int nextWordGroupId = group_id < wordVectors[nextWordId].length ? group_id : 0;

      beginShape();
      for( int point_id = 0; point_id < wordVectors[word_id][group_id].length; point_id++ ) {
        
        int nextWordPointId = point_id < wordVectors[nextWordId][nextWordGroupId].length ? point_id : 0;
        
        PVector lerp_point = PVector.lerp(
          wordVectors[word_id][group_id][point_id],
          wordVectors[nextWordId][nextWordGroupId][nextWordPointId],
          t
        );

        vertex(
            lerp_point.x, 
            lerp_point.y
        );
        
      }
      endShape();
    }
    if( mousePressed == true ) {
      exit();
    }
}