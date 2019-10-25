import geomerative.*;

boolean isRecording = false;
boolean isCapturing = false;

String[] words = {
  "follow",
  "watch",
  "buy",
  "find",
  "fall",
  "push",
  "come",
  "turn",
  "grow",
  "stay",
  "stop",
  "jump",
  "move",
  "hurt",
  "hold",
  "help",
  "bring",
  "meet",
  "walk",
  "wait",
  "kill",
  "keep",
  "serve",
  "solve",
  "stand",
  "leave",
  "build"
};

PVector[][][] wordsPoints;

int[][] groupToTrack,
  pointToTrack,
  trackDirection;


RFont rfont;

int current_word_id = 0,
  pointsToTracksPerWord = 4,
  num_frame = 125,
  fontSize = 480;


boolean isGroupHasPointToTrack(int current_group) {
  boolean in_group = false;
  for (int g = 0; g < groupToTrack[current_word_id].length; g++) {
    if (g == current_group) {
      in_group = true;
    }
  }
  return in_group;
}

void setup() {
  size(1080, 1080);
  //fullScreen();
  smooth(50);
  fill(255);
  strokeWeight(2);

  RG.init(this);
  RG.ignoreStyles(false);
  RG.setPolygonizer(RG.ADAPTATIVE);
  RG.setPolygonizerAngle(0.065);
  rfont = new RFont("postnobillscolombo-semibold.ttf", fontSize, CENTER);
  createTextsVectors(words);
}

void createTextsVectors(String[] texts) {

  wordsPoints = new PVector[texts.length][][];

  for (int word_id = 0; word_id < texts.length; word_id++) {

    RShape wordShape = new RShape();
    RShape[] lines = new RShape[2];

    int split = ceil(texts[word_id].length() / 2);
    int remainder = texts[word_id].length() - split;
    lines[0] = rfont.toShape(texts[word_id].substring(0, remainder));
    lines[1] = rfont.toShape(texts[word_id].substring(remainder, split + remainder));
    lines[1].translate(0, fontSize / 1.45);
    wordShape.addChild(lines[0]);
    wordShape.addChild(lines[1]);

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

  pointToTrack = groupToTrack = trackDirection = new int[wordsPoints.length][pointsToTracksPerWord];

  for (int w = 0; w < wordsPoints.length; w++) {

    for (int rp = 0; rp < pointsToTracksPerWord; rp++) {

      int randomGroup = floor(random(1) * wordsPoints[w].length);
      int randomPoint = floor(random(1) * wordsPoints[w][randomGroup].length);
      int randomDirection = random(1) > 0.5 ? 0 : 1;

      groupToTrack[w][rp] = randomGroup;
      pointToTrack[w][rp] = randomPoint;
      trackDirection[w][rp] = randomDirection;
    }
  }
} // createTextsVectors()


void draw() {
  background(0);
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

  for (int group_id = 0; group_id < maxGroup; group_id++) {

    boolean pointToTrackInGroup = isGroupHasPointToTrack(group_id);
    boolean currentWordGroupExist = group_id < wordsPoints[current_word_id].length;
    boolean nextWordGroupExist = group_id < wordsPoints[nextWordId].length;

    int maxPoint = max(
      currentWordGroupExist ? wordsPoints[current_word_id][group_id].length : wordsPoints[current_word_id][wordsPoints[current_word_id].length - 1].length,
      nextWordGroupExist ? wordsPoints[nextWordId][group_id].length : wordsPoints[nextWordId][wordsPoints[nextWordId].length - 1].length
    );

    PVector[] interpolate_points = new PVector[maxPoint];
    stroke(44, 62, 80);

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
        sq(t)
      );

      if (pointToTrackInGroup && pointToTrack[current_word_id][group_id] == point_id) {
        if (trackDirection[current_word_id][group_id] == 0) {
          line(lerp_point.x, -height / 2, lerp_point.x, height / 2);
        } else {
          line(-width / 2, lerp_point.y, width / 2, lerp_point.y);
        }
      }
      interpolate_points[point_id] = lerp_point;
    }
    pushMatrix();
    noStroke();
    beginShape();

    for (int l = 0; l < interpolate_points.length; l++) {
      vertex(
        interpolate_points[l].x,
        interpolate_points[l].y
      );
    }
    endShape();
    popMatrix();
  }

  if (isCapturing == true && t > 0.495 && t < 0.51) {
    saveFrame("records/captures/frame-###.jpg");
  }
  if (isRecording == true) {
    saveFrame("records/frame-###.jpg");
  }

  if (mousePressed == true) {
    exit();
  }
}