ArrayList<PVector> points = new ArrayList<PVector>();

float n_range = 1;
int step = 2;
float threshold = .9;

void setup() {

    size(960, 960);
    frameRate(12);
    strokeWeight(1);
    stroke(150);
    getNoise();
}
void getNoise() {
    
    background(255, 255, 255, 0.25);
    points = new ArrayList<PVector>();

    for( int x = 0; x < width; x+= step ) {

        for( int y = 0; y < height; y+= step ) {

            float n_x = map( x, 0, width, 0, n_range );
            float n_y = map( y, 0, height, 0, n_range );

            float n_value = noise( n_x, n_y ) * 255;

            if( n_value < 100 && random(1) > threshold ) {
                
                stroke( n_value );
                line( x, y, x+step, y+step );
                /*
                points.add( 
                    new PVector(
                        x + random(-10, 10),
                        y + random(-10, 10)
                    )
                );
                */
            }
        }
    }
    n_range = n_range + 0.1;
    println("n_range: "+n_range);
}

void draw() {

    getNoise();
/*
    for( int v = 0; v < points.size() - 2; v+= 2 ) {

        PVector first = points.get(v);
        PVector last = points.get(v+1);
        float distance = PVector.dist( first, last );
    
        if( distance < width / 6 ) {
    
            line( first.x, first.y, last.x, last.y );

        }
    }
*/
}
