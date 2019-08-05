// Based on Etienne Jacob
// https://necessarydisorder.wordpress.com/2017/09/02/animated-stripes-gifs-from-scalar-fields/

OpenSimplexNoise noise;

boolean recording = true;
int numFrames = 75;
int step = 1;
int centerX, centerY;

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}
float scalar_field_offset(float x,float y){
  float scale = 0.01;
  float result = 40*((float)noise.eval(scale*x,scale*y));
  return result;
}
float pixel_color(float x,float y,float t){
  float result = ease(map(sin(TWO_PI*(t+scalar_field_offset(x,y))),-1,1,0,1),3.0);
  return 255*result;
}
void setup() {

    size(800, 800);

    noise = new OpenSimplexNoise();
    centerX = width / 2;
    centerY = height / 2;
}

void draw() {
    background(255);
    //loadPixels();
    float t = 1.0 * frameCount / numFrames;
    
    for( int radius = 1; radius < width; radius+=step ) {
        
        float circunference;
        if( t < 0.5 ) {
            circunference = map(t, 0.0, 1.0, (float)radius,  TWO_PI * radius);
        } else {
            circunference = map(t, 0.0, 1.0, TWO_PI * radius, (float)radius);
        }
        float angle = TWO_PI / circunference-1;

        for( int p = 0; p < circunference; p++ ) {
            
            float dist = radius+(t*step);
            float x = dist*sin(angle*p)+centerX;
            float y = dist*cos(angle*p)+centerY;
            
            stroke(pixel_color(x, y, t));
            point(x, y);

        }
    }
    saveFrame("records/frame-###.jpg");
    
    //updatePixels();
    if(frameCount == numFrames){
        exit();
    }
}