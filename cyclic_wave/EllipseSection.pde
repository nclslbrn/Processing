class EllipseSection {

  float     radius       = 0;
  float     initialAngle = 0;
  FloatList angles       = new FloatList();
  PVector   center       = new PVector(0, 0);


  EllipseSection( 
    float     radius,
    float     initialAngle,
    FloatList angles,
    PVector   center
  ) {

    this.radius       = radius;
    this.initialAngle = initialAngle;
    this.angles       = angles;
    this.center       = center;
  
  }
  void init() {
    FloatList angles       = new FloatList();
    float     initialAngle = 0;
    float     newAngle     = 0;

    while( initialAngle <= TWO_PI ) {

      newAngle = random( TWO_PI / 12 );

      angles.append( newAngle );

      initialAngle += newAngle;

    }
    this.angles       = angles;
    this.initialAngle = random(TWO_PI);
  }
}