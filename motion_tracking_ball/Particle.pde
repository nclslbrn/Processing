class Particle {
    
    PVector position;
    PVector previousPosition;
    PVector vector;
    float   stepSize;
    int     brightness;
    int     age;
    color   particleColor;
    boolean isPositionResetWhenOutside;

    Particle() {
        position = new PVector(random(width), random(height));
        previousPosition = position.get();
        vector = new PVector(0, 0);
        particleColor = color(0);
        stepSize = 1;
        isPositionResetWhenOutside = true;
        brightness = 150;
        age = 0;
    }

    Particle(PVector position, color particleColor) {
        this();
        this.position = position;
        previousPosition = position.get();
        particleColor = particleColor;
    }

    void updatePosition(float A, float B, float C, float D, float magnitude) {
        // Based on Clifford A. Pickover formula
        float scale = 0.005;
        float x = (position.x - width/2) * scale;
        float y = (position.y - height/2) * scale;
        float x1 = sin(A * y) + C * cos(A * x);
        float y1 = sin(B * x) + D * cos(B * y);

        float angle = atan2(y1 - y, x1 - x);

        vector.x += cos(angle) * magnitude;
        vector.y += sin(angle) * magnitude;

        display();
        position.x += vector.x;
        position.y += vector.y;

        vector.x *= 0.99;
        vector.y *= 0.99;
        
        previousPosition = position;


        age++;

        if (isPositionResetWhenOutside && isOutsideSketch() > 0) {
            position = new PVector(random(width), random(height));
            previousPosition = position.get();
        }
    }

    void display() {
        stroke(particleColor);
        line(
            previousPosition.x, 
            previousPosition.y, 
            position.x, 
            position.y
        );
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