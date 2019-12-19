class Branch {
    PVector a;
    PVector b;

    Branch() {
        a = new PVector(0,0);
        b = new PVector(0,0);
    }

    Branch( PVector a, PVector b) {
        this();
        this.a = a;
        this.b = b;
    }
    void show() {
        stroke(255);
        line(a.x, a.y, b.x, b.y);
    }
}