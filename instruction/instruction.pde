import geomerative.*;

boolean isGroupHasPointToTrack(int current_group) {
  boolean in_group = false;
  for (int g = 0; g < groupToTrack[current_word_id].length; g++) {
    if (g == current_group) {
      in_group = true;
    }
  }
  return in_group;
}

float c01(float g) {
  return constrain(g, 0, 1);
}

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}
/////////////////////////////////////////////////////////////

boolean isRecording = false;
boolean isCapturing = false;
boolean isMultiline = true;

String[] words = { "vérité",  "relative"};
//JSONArray data;
PVector[][][] wordsPoints;
RFont rfont;

int current_word_id = 0,
  pointsToTracksPerWord = 126,
  num_frame = 125,
  fontSize = 320;

int[][] groupToTrack,
  pointToTrack,
  trackDirection,
  trackShapeSize;

color strokeColor = color(75);

void setup() {
  size(1080, 1080);
  //fullScreen();
  smooth(50);
  noStroke();
  fill(255);
  
 // data = loadJSONArray("words.json");
  //words = data.getStringArray();

  RG.init(this);
  RG.ignoreStyles(false);
  rfont = new RFont("postnobillscolombo-semibold.ttf", fontSize, CENTER);
  createTextsVectors(words);
  colorMode(HSB, words.length, 100, 100);
}

void createTextsVectors(String[] texts) {

  wordsPoints = new PVector[texts.length][][];

  for (int word_id = 0; word_id < texts.length; word_id++) {

    RShape wordShape = new RShape();
    
    if( ! isMultiline ) {

      wordShape = rfont.toShape(texts[word_id]);
      wordShape.translate(0, fontSize*0.25);

    } else {

      RShape[] lines = new RShape[2];
      int split = ceil(texts[word_id].length() / 2);
      int remainder = texts[word_id].length() - split;
      lines[0] = rfont.toShape(texts[word_id].substring(0, remainder));
      lines[1] = rfont.toShape(texts[word_id].substring(remainder, split + remainder));
      lines[1].translate(0, fontSize / 1.45);
      wordShape.addChild(lines[0]);
      wordShape.addChild(lines[1]);
    }
    /* multiple line
    RShape wordShape = new RShape();
    
    */

    RPoint[][] points = wordShape.getPointsInPaths();
    wordsPoints[word_id] = new PVector[points.length][];

    for (int group_id = 0; group_id < points.length; group_id++) {

      wordsPoints[word_id][group_id] = new PVector[points[group_id].length];

      for (int point_id = 0; point_id < points[group_id].length; point_id++) {

        wordsPoints[word_id][group_id][point_id] = new PVector(
          points[group_id][point_id].x,
          points[group_id][point_id].y
        );
      }
    }
  }

  
  pointToTrack = groupToTrack = trackDirection = trackShapeSize = new int[wordsPoints.length][pointsToTracksPerWord];

  for (int w = 0; w < wordsPoints.length; w++) {
    
    for (int rp = 0; rp < pointsToTracksPerWord; rp++) {

      int randomGroup = int(random(1) * wordsPoints[w].length);
      int randomPoint = int(random(1) * wordsPoints[w][randomGroup].length);
      int randomDirection = random(1) > 0.5 ? 0 : 1;

      groupToTrack[w][rp] = randomGroup;
      pointToTrack[w][rp] = randomPoint;
      trackDirection[w][rp] = randomDirection;
      trackShapeSize[w][rp] = int(random(0, 7)) * 100;

    }
  }
} // createTextsVectors()


void draw() {
  background(0,0,0,.5);
  translate(width / 2, height / 2);

  if (frameCount != 0 && frameCount % num_frame == 0) {
    current_word_id++;
  }
  if (current_word_id >= wordsPoints.length) {
    current_word_id = 0;
    isRecording = false;
  }

  int nextWordId = current_word_id < wordsPoints.length - 1 ? current_word_id + 1 : 0;

  float t = map(frameCount % num_frame, 0, num_frame, 0, 1);

  int maxGroup = max(wordsPoints[current_word_id].length, wordsPoints[nextWordId].length);

  PVector[][] interpolate_points;
  interpolate_points = new PVector[maxGroup][];
  pushStyle();
  fill(strokeColor, 100);
  stroke(strokeColor);
  strokeWeight(1.5);

  for (int group_id = 0; group_id < maxGroup; group_id++) {

    boolean pointToTrackInGroup = isGroupHasPointToTrack(group_id);
    boolean currentWordGroupExist = group_id < wordsPoints[current_word_id].length;
    boolean nextWordGroupExist = group_id < wordsPoints[nextWordId].length;

    int maxPoint = max(

      currentWordGroupExist ?
        wordsPoints[current_word_id][group_id].length : 
        wordsPoints[current_word_id][wordsPoints[current_word_id].length - 1].length,

      nextWordGroupExist ?
        wordsPoints[nextWordId][group_id].length : 
        wordsPoints[nextWordId][wordsPoints[nextWordId].length - 1].length
    );

    interpolate_points[group_id] = new PVector[maxPoint];

    for (int point_id = 0; point_id < maxPoint; point_id++) {

      PVector first_point;
      PVector last_point;

      if (currentWordGroupExist) {

        first_point = point_id < wordsPoints[current_word_id][group_id].length - 1 ?
          wordsPoints[current_word_id][group_id][point_id] :
          wordsPoints[current_word_id][group_id][wordsPoints[current_word_id][group_id].length - 1];

      } else {

        int lastGroupId = wordsPoints[current_word_id].length - 1;
        first_point = wordsPoints[current_word_id][lastGroupId][wordsPoints[current_word_id][lastGroupId].length - 1];
      }

      if (nextWordGroupExist) {

        last_point = point_id < wordsPoints[nextWordId][group_id].length - 1 ?
          wordsPoints[nextWordId][group_id][point_id] :
          wordsPoints[nextWordId][group_id][wordsPoints[nextWordId][group_id].length - 1];

      } else {

        int lastGroupId = wordsPoints[nextWordId].length - 1;
        last_point = wordsPoints[nextWordId][lastGroupId][wordsPoints[nextWordId][lastGroupId].length - 1];
      }


      PVector lerp_point = PVector.lerp(
        first_point,
        last_point,
        ease(c01(1.1*t-0.1))
      );

      if (pointToTrackInGroup && pointToTrack[current_word_id][group_id] == point_id) {
               
        if (trackDirection[current_word_id][group_id] == 0) {
          
          line(
            lerp_point.x,
            -height / 2,
            lerp_point.x,
            height / 2
          );

          polygon(
            0,
            lerp_point.y,
            trackShapeSize[current_word_id][group_id],
            6,
            ease(t)
          );
        
        } else {
        
          line(
            -width / 2,
            lerp_point.y,
            width / 2,
            lerp_point.y
          );

          polygon(
            lerp_point.x,
            0,
            trackShapeSize[current_word_id][group_id],
            6,
            ease(t)
          );

        }
        
        ellipse(
          lerp_point.x,
          lerp_point.y,
          trackShapeSize[current_word_id][group_id],
          trackShapeSize[current_word_id][group_id]
        );
      }
      interpolate_points[group_id][point_id] = lerp_point;
    }
  }
  popStyle();
  /**
   * Draw letters
  */
  
  pushMatrix();
  for( int g = 0; g < interpolate_points.length; g++ ) {

    float light = map(
      g,
      0,
      wordsPoints[current_word_id].length,
      current_word_id % 2 == 0 ? 100 : 0,
      current_word_id % 2 == 0 ? 0 : 100
    );
    fill(current_word_id, light, 125);
    beginShape();

    for (int l = 0; l < interpolate_points[g].length; l++) {
      vertex(
        interpolate_points[g][l].x,
        interpolate_points[g][l].y
      );
    }
    endShape();
  }
  popMatrix();

  if (isCapturing == true && t > 0.495 && t < 0.51) {
    saveFrame("records/captures/frame-###.jpg");
  }
  if (isRecording == true) {
    saveFrame("records/video/frame-###.jpg");
  }
  if (mousePressed == true) {
    exit();
  }
}

void polygon( float x, float y, int radius, int npoints, float rotation ) {
  float angle = TWO_PI / npoints;
  float rotAngle = PI * rotation;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a+rotAngle) * radius;
    float sy = y + sin(a+rotAngle) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}