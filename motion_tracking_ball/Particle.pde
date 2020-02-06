class Particle {
    
    PVector position;
    PVector previousPosition;
    float   stepSize;
    int     brightness;
    int     age;
    boolean isPositionResetWhenOutside;

    Particle() {
        position = new PVector(random(width), random(height));
        previousPosition = position.get(); 
        stepSize = 1;
        isPositionResetWhenOutside = true;
        brightness = 150;
        age = 0;
    }

    Particle(PVector position) {
        this();
        this.position = position;
        previousPosition = position.get();
    }

    void updatePosition(float A, float B, float C, float D, float magnitude) {
        // Based on Clifford A. Pickover formula
        float x = (position.x - width/2) * 0.005;
        float y = (position.y - height/2) * 0.005;
        float x1 = sin(A * y) + C * cos(A * x);
        float y1 = sin(B * x) + D * cos(B * y);

        float angle = atan2(y1 - y, x1 - x);
        previousPosition = position;

        position.x += cos(angle) * magnitude;
        position.y += sin(angle) * magnitude;
        age++;

        if (isPositionResetWhenOutside && isOutsideSketch() > 0) {
            position = new PVector(random(width), random(height));
            previousPosition = position.get();
        }
    }

    void display(color particleColor) {
        stroke(particleColor);
        line(previousPosition.x, previousPosition.y, position.x, position.y);
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