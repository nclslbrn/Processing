import geomerative.*;

boolean isRecording = false;
String[] english_words = {
  "fall",
  "find",
  "push",
  "come",
  "turn",
  "grow",
  "stay",
  "stop",
  "jump",
  "move",
  "hurt",
  "hold"
};

PVector[][][] wordVectors;
String[] words;
color bgColor = color(0, 0, 0, 30);
RFont rfont;
int current_word_id = 0;
int num_frame = 30;


void setup() {
  size(1080, 1080);
  //fullScreen();
  smooth(50);
  noStroke();

  RG.init(this);
  RG.ignoreStyles(false);
  RG.setPolygonizer(RG.UNIFORMLENGTH);

  rfont = new RFont("postnobillscolombo-semibold.ttf", 450, CENTER);

  words = english_words;

  colorMode(HSB, words.length, 100, 100);
  println( words.length);
  createTextsVectors(words);
}

void createTextsVectors(String[] texts) {

  wordVectors = new PVector[texts.length][][];

  for (int word_id = 0; word_id < texts.length; word_id++) {

    RShape wordShape = rfont.toShape(texts[word_id]);
    RPoint[][] wordPoints = wordShape.getPointsInPaths();
    wordVectors[word_id] = new PVector[wordPoints.length][];

    for (int group_id = 0; group_id < wordPoints.length; group_id++) {

      wordVectors[word_id][group_id] = new PVector[wordPoints[group_id].length];

      for (int point_id = 0; point_id < wordPoints[group_id].length; point_id++) {

        wordVectors[word_id][group_id][point_id] = new PVector(
          wordPoints[group_id][point_id].x,
          wordPoints[group_id][point_id].y
        );
      }
    }
  }
}


void draw() {
/*
  fill(bgColor);
  rect(-1, -1, width+1, height+1);
*/
  background(0);
  translate(width / 2, height*0.65);

  if (frameCount != 0 && frameCount % num_frame == 0) {
    current_word_id++;
  }
  if (current_word_id >= wordVectors.length) {
    current_word_id = 0;
    isRecording = false;
  }

  int nextWordId = current_word_id < wordVectors.length - 1 ? current_word_id + 1 : 0;
  
  float t = map(frameCount % num_frame, 0, num_frame, 0, 1);

  int lastGroupId = 0;
  int lastPointId = 0;
  int nextWordLastGroup_id = 0;
  int nextWordLastPoint_id = 0;

  for (int group_id = 0; group_id < wordVectors[current_word_id].length; group_id++) {

    float light = map( 
      group_id,
      0, 
      wordVectors[current_word_id].length, 
      current_word_id % 2 == 0 ? 100 : 0,
      current_word_id % 2 == 0 ? 0 : 100
    );
    
    fill( current_word_id, light, 125  );
    println( group_id / wordVectors[current_word_id].length);

    int nextWordGroupId = group_id < wordVectors[nextWordId].length ? group_id : 0;
    beginShape();
    for (int point_id = 0; point_id < wordVectors[current_word_id][group_id].length; point_id++) {

      int nextWordPointId = point_id < wordVectors[nextWordId][nextWordGroupId].length ? point_id : 0;

      PVector lerp_point = PVector.lerp(
        wordVectors[current_word_id][group_id][point_id],
        wordVectors[nextWordId][nextWordGroupId][nextWordPointId],
        sq(t)
      );

      vertex(
        lerp_point.x,
        lerp_point.y
      );
      lastPointId = point_id;
      nextWordLastPoint_id = nextWordPointId;
    }
    endShape(CLOSE);
    lastGroupId = group_id;
    nextWordLastGroup_id = nextWordGroupId;
  }
  
  for (
    int nextWordRemainingGroupId = nextWordLastGroup_id; nextWordRemainingGroupId < wordVectors[nextWordId].length; nextWordRemainingGroupId++
  ) {
    float light = map( 
      nextWordRemainingGroupId,
      0, 
      wordVectors[nextWordId].length, 
      nextWordId % 2 == 0 ? 0 : 100,
      nextWordId % 2 == 0 ? 100 : 0
    );
    
    fill( current_word_id, light, 125  );
    beginShape();

    for (
      int nextWordRemainingPointId = 0; nextWordRemainingPointId < wordVectors[nextWordId][nextWordRemainingGroupId].length; nextWordRemainingPointId++
    ) {

      PVector remaining_lerp_point = PVector.lerp(
        wordVectors[current_word_id][lastGroupId][lastPointId],
        wordVectors[nextWordId][nextWordRemainingGroupId][nextWordRemainingPointId],
        sq(t)
      );

      vertex(
        remaining_lerp_point.x,
        remaining_lerp_point.y
      );

      if (lastPointId > 0) {
        lastPointId--;
      }
    }
    endShape(CLOSE);
    
     if( lastGroupId > 0 ) {
    //  lastGroupId--;
    //  println(words[current_word_id] + " -> " + nextWordRemainingGroupId );

    }
    
   
  }
  if( isRecording == true ) {
    saveFrame("records/frame-###.jpg");
  }
  
  if (mousePressed == true) {
    exit();
  }
}