OpenSimplexNoise noise;

boolean recording = true;

void setup() {

    size(500, 500);
    background(255);
   // smooth(15);
    stroke(0);
    noFill();

    noise = new OpenSimplexNoise();
}

int numFrames = 75;

float radius = 0.1;

void draw() {

    float t = 1.0 * frameCount / numFrames;

    background(255);

    float scale = 0.0075;

    if( recording ) {
        loadPixels();
    }

    for (int x = 0; x < width; x++) {

        for (int y = 0; y < height; y++) {

            float noiseValue = (float) noise.eval(
                scale * x,
                scale * y,
                radius * cos(TWO_PI * t),
                radius * sin(TWO_PI * t)
            );
            float roundNoise = round( (noiseValue * 100 ) );
            roundNoise = roundNoise / 100;

            boolean b = (roundNoise % 0.05) == 0;

            float col = b ? 0 : 255;

            if( recording ) {
                
                pixels[x + width * y] = color(col);

            } else {
                stroke(col);
                point( x, y );

            }
        }
    }
    if( recording ) {
        updatePixels();
    }


    if (frameCount <= numFrames && recording) {
        saveFrame("records/frame-###.jpg");
    }
    if (frameCount == numFrames && recording) {
        println("finished");
        stop();
    }
}