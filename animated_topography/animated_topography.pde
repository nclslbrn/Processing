// Based on a work of Etienne Jacob
// https://gist.github.com/Bleuje/907dfc2da1be07fad3edc8ed9cd888ed


OpenSimplexNoise noise;

boolean recording = true;
int numFrames = 75;
int margin = 16;
float radius = 0.5;
int step = 1;
int strokeColor = 255;
int tickMargin = 12;

void setup() {

    size(800, 800);
    background(255);
    stroke(strokeColor);
    noise = new OpenSimplexNoise();
}


void draw() {

    float t = 1.0 * frameCount / numFrames;
    float scale = 0.005;

    background(0);
    loadPixels();
/*
    for( int x = margin; x <= width-margin; x+= tickMargin ) {

        for( int _y = margin; _y <= height-margin; _y++ ) {

            pixels[x+width*_y] = color( 255, 100, 100 );
        }
    }

    for( int y = margin; y <= height-margin; y+= tickMargin  ) {

        for( int _x = margin; _x <= width-margin; _x++ ) {

            pixels[_x+width*y] = color( 255, 100, 100 );
        }

    }
*/
    
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

            boolean b = (roundNoise % 0.15) == 0;

            if( b ) {

                for( int _x = 0; _x <= step; _x++ ) {
                    for( int _y = 0; _y <= step; _y++ ) {
                        
                        pixels[x +_x + width * y +_y] = color( strokeColor );

                    }
                }

            }
        }
    }

    updatePixels();

    if (frameCount <= numFrames && recording) {
        saveFrame("records/frame-###.jpg");
    }
    if (frameCount == numFrames && recording) {
        exit();
    }
}
