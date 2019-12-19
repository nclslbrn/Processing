class Branch {
    PVector a;
    PVector b;
    float weight;

    Branch() {
        a = new PVector(0,0);
        b = new PVector(0,0);
        float weight = 1.0;
    }

    Branch( PVector a, PVector b, float w) {
        this();
        this.a = a;
        this.b = b;
        this.weight = w;
    }
    void show() {
        stroke(255);
        strokeWeight(weight);
        line(a.x, a.y, b.x, b.y);
    }
}