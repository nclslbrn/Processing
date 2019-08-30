class Agent {
    
    PVector position;
    PVector previousPosition;
    float   stepSize;
    float   angle;
    int     brightness;
    boolean isPositionResetWhenOutside;

    Agent() {
        position = new PVector(random(width), random(height));
        previousPosition = position.get(); 
        angle = random(1) * TWO_PI;
        stepSize = 1;
        isPositionResetWhenOutside = true;
        brightness = 150;
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
            position = new PVector(random(width), random(height));
            previousPosition = position.get();
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