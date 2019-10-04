class Agent {
    
    PVector position;
    PVector previousPosition;
    float   stepSize;
    float   strokeWeight;
    color   strokeColor;
    float   angle;
    int     brightness;
    boolean isPositionResetWhenOutside;

    Agent() {
        position                   = new PVector(random(width), random(height));
        previousPosition           = position.get(); 
        angle                      = random(1) * TWO_PI;
        strokeWeight               = 1;
        strokeColor                = color(255, 255, 255);
        stepSize                   = 1;
        isPositionResetWhenOutside = true;
        brightness                 = 150;
    }

    Agent(PVector position) {
        this();
        this.position = position;
        previousPosition = position.get();
    }

    void updatePosition() {
        previousPosition = position.get();
        position.x += cos(angle) * stepSize;
        position.y += sin(angle) * stepSize;

        if (isPositionResetWhenOutside && isOutsideSketch() > 0) {
            // opposite side solution
            
            if( position.x < 0 ) {
                previousPosition.x = position.x = width;
                
            } else if( position.x > width ) {
                previousPosition.x = position.x = 0;
            } else if( position.y < 0 ) {
                previousPosition.y = position.y = height;
            } else if( position.y > height ) {
                previousPosition.y = position.y = 0;
            }
            /*
            // random solution 
            if( position.x < 0 || position.x > width || position.y < 0 || position.y > height ) {
                position = previousPosition = new PVector(random(width), random(height));
            }
            */

        }
    }


    int isOutsideSketch() {
        if (position.y < 0) {
            return 1;
        } else if (position.x > width) {
            return 2;
        } else if (position.y > height) {
            return 3;
        } else if (position.x < 0) {
            return 4;
        } else {
            return 0;
        }
    }
}