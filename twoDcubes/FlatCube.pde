class FlatCube {
  
  PVector center = new PVector(0,0);
  int width       = 400;
  color[] colors = {
    color(255, 0, 0),
    color(0, 255, 0),
    color(0, 0, 255)
  };
  float angle = 27;

  FlatCube(
    PVector center,
    int     width,
    color[] colors,
    float   angle
  ) {

    this.center = center;
    this.width  = width;
    this.colors = colors;
    this.angle  = angle;
  }

  void display() {
    
    PVector center = this.center;
    int width      = this.width;
    color[] colors = this.colors;
    float angle    = this.angle;

    float h = width / 2;
    float _h = sqrt( sq(width/2) + sq(h/2) );

    PVector a = new PVector(
      center.x, center.y + width/2
    );

    PVector b = new PVector(
      center.x + _h * cos(angle),
      center.y + _h * sin(angle)
    );

    PVector c = new PVector(
      center.x - _h * cos(TWO_PI - angle),
      center.y - _h * sin(TWO_PI - angle)
    );

    fill(colors[0]);
    beginShape();
    vertex(a.x, a.y);
    vertex(b.x, b.y);
    vertex(b.x, b.y - h);
    vertex(a.x, a.y - h);
    endShape();

    fill(colors[1]);
    beginShape();
    vertex(a.x, a.y - h);
    vertex(b.x, b.y - h);
    vertex(a.x, a.y - width);
    vertex(c.x, c.y - h);
    endShape();

    fill(colors[2]);
    beginShape();
    vertex(a.x, a.y);
    vertex(a.x, a.y - h);
    vertex(c.x, c.y - h);
    vertex(c.x, c.y);
    endShape();
  
  }
}