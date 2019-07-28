OpenSimplexNoise noise;

boolean recording = false;
int numFrames = 75;
int margin = 16;
float radius = 0.05;
int step = 2;

void setup() {

    size(800, 800);
    background(255);
    frameRate(25);
    stroke(0);
    noFill();

    noise = new OpenSimplexNoise();
}




void draw() {

    float t = 1.0 * frameCount / numFrames;

    background(255);

    float scale = 0.005;

    loadPixels();


    for (int x = margin; x < width - margin; x+=step ) {
        
        for (int y = margin; y < height - margin; y+=step ) {

            float noiseValue = (float) noise.eval(
                scale * x,
                scale * y,
                radius * cos(TWO_PI * t),
                radius * sin(TWO_PI * t)
            );
            float roundNoise = round( (noiseValue * 100 ) );
            roundNoise = roundNoise / 100;

            boolean b = (roundNoise % 0.01) == 0;

            if( b ) {
                
                color col = color( b ? 0 : 255 );
                pixels[x + width * y] = color(col);
                   
            }
        }
    }

    updatePixels();


    if (frameCount <= numFrames && recording) {
        saveFrame("records/frame-###.jpg");
    }
    if (frameCount == numFrames && recording) {
        println("finished");
        stop();
    }
}
