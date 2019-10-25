import geomerative.*;
import http.requests.*;
JSONObject api_key;

String[] splitText(String text) {
  
  String[] strings;

  if( text.contains(" ") ) {
    strings = split(text, " "); // <- Caution: strings can't end with a ' '
  } else {
    strings = new String[0];
    strings[0] = text;
  }
  return strings;
}

boolean isRecording = false;
RPoint[][][] wordsPoints;
RFont rfont;
String nyt_api_key = "";
String[] titles, words;
int newsNum = 0, 
    currentTitleId = 0,
    current_word_id = 0,
    num_frame = 50,
    fontSize = 220;
    
color bgColor = color(0, 0, 0, 30);

void setup() {
  size(1280, 720);
  //fullScreen();
  smooth(50);
  noStroke();

  RG.init(this);
  RG.ignoreStyles(false);
  RG.setPolygonizer(RG.UNIFORMLENGTH);
  api_key = loadJSONObject("api_key.json");
  nyt_api_key = api_key.getString("nyt");
  rfont = new RFont("postnobillscolombo-semibold.ttf", fontSize, CENTER);
  getMessage();
}


void getMessage() {

  GetRequest get = new GetRequest("https://api.nytimes.com/svc/news/v3/content/all/all.json?api-key="+nyt_api_key);
  get.addHeader("Charset", "UTF-8");
  get.send();

  JSONObject response = parseJSONObject( get.getContent() );
  JSONArray results = response.getJSONArray( "results" );
  
  newsNum = results.size();
  titles = new String[ newsNum ];

  for( int i=0; i < newsNum; i++ ) {

    JSONObject data = results.getJSONObject(i);
    String title = data.getString("title", "UTF-8");
    String text = data.getString( "abstract", "UTF-8");
    
    titles[i] = title + " = " +text + " [...]";

  }
  loadMessage();
    
}
void loadMessage() {


  if( currentTitleId < titles.length ) {

    createTextsVectors( splitText( titles[currentTitleId]) );

  } else {
    currentTitleId = 0;
    //getMessage();
    createTextsVectors( splitText( titles[currentTitleId]) );
  }
}
void createTextsVectors(String[] texts) {
  
  colorMode(HSB, texts.length, 100, 100);
  wordsPoints = new RPoint[texts.length][][];

  for (int word_id = 0; word_id < texts.length; word_id++) {   
    RShape wordShape = rfont.toShape(texts[word_id]);
    RPoint[][] points = wordShape.getPointsInPaths();
    wordsPoints[word_id] = new RPoint[points.length][];

    for (int group_id = 0; group_id < points.length; group_id++) {

      wordsPoints[word_id][group_id] = new RPoint[points[group_id].length];

      for (int point_id = 0; point_id < points[group_id].length; point_id++) {

        wordsPoints[word_id][group_id][point_id] = new RPoint(
          points[group_id][point_id]
        );
      }
    }
  }
}


void draw() {

  background(0);
  translate(width / 2, height * 0.65);

  if (frameCount != 0 && frameCount % num_frame == 0) {
    current_word_id++;
  }
  if (current_word_id >= wordsPoints.length) {
    currentTitleId++;
    current_word_id = 0;
    isRecording = false;
    loadMessage();
  }

  int nextWordId = current_word_id < wordsPoints.length - 1 ? current_word_id + 1 : 0;

  float t = map(frameCount % num_frame, 0, num_frame, 0, 1);

  int lastGroupId = 0;
  int lastPointId = 0;
  int nextWordLastGroup_id = 0;
  int nextWordLastPoint_id = 0;

  for (int group_id = 0; group_id < wordsPoints[current_word_id].length; group_id++) {

    float light = map(
      group_id,
      0,
      wordsPoints[current_word_id].length,
      current_word_id % 2 == 0 ? 100 : 0,
      current_word_id % 2 == 0 ? 0 : 100
    );

    fill(current_word_id, light, 125);

    int nextWordGroupId = group_id < wordsPoints[nextWordId].length ? group_id : 0;
    beginShape();
    for (int point_id = 0; point_id < wordsPoints[current_word_id][group_id].length; point_id++) {

      int nextWordPointId = point_id < wordsPoints[nextWordId][nextWordGroupId].length ? point_id : 0;

      PVector lerp_point = PVector.lerp(
        new PVector(
          wordsPoints[current_word_id][group_id][point_id].x,
          wordsPoints[current_word_id][group_id][point_id].y
        ),
        new PVector(
          wordsPoints[nextWordId][nextWordGroupId][nextWordPointId].x,
          wordsPoints[nextWordId][nextWordGroupId][nextWordPointId].y
        ),
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
    int nextWordRemainingGroupId = nextWordLastGroup_id; nextWordRemainingGroupId < wordsPoints[nextWordId].length; nextWordRemainingGroupId++
  ) {
    float light = map(
      nextWordRemainingGroupId,
      0,
      wordsPoints[nextWordId].length,
      nextWordId % 2 == 0 ? 0 : 100,
      nextWordId % 2 == 0 ? 100 : 0
    );

    fill(current_word_id, light, 125);
    beginShape();

    for (
      int nextWordRemainingPointId = 0; nextWordRemainingPointId < wordsPoints[nextWordId][nextWordRemainingGroupId].length; nextWordRemainingPointId++
    ) {

      PVector remaining_lerp_point = PVector.lerp(
        new PVector(
          wordsPoints[current_word_id][lastGroupId][lastPointId].x,
          wordsPoints[current_word_id][lastGroupId][lastPointId].y
        ),
        new PVector(
          wordsPoints[nextWordId][nextWordRemainingGroupId][nextWordRemainingPointId].x,
          wordsPoints[nextWordId][nextWordRemainingGroupId][nextWordRemainingPointId].y
        ),
        sq(t)
      );
      vertex(
        remaining_lerp_point.x,
        remaining_lerp_point.y
      );

      if (lastPointId < wordsPoints[current_word_id][lastGroupId].length - 1) {
        lastPointId++;
      }
    }
    endShape(CLOSE);
  }
  if (isRecording == true) {
    saveFrame("records/frame-###.jpg");
  }

  if (mousePressed == true) {
    exit();
  }
}