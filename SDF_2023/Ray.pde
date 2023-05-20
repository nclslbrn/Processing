class Ray {
  Point origin;
  Vector direction;
 
  Ray(Point origin, Vector direction) {
    this.origin=new Point(origin.x, origin.y, origin.z);
    float mag=direction.x*direction.x+direction.y*direction.y+direction.z*direction.z;
    assert(mag > 0.000001);
    mag=1.0/sqrt(mag);
    this.direction=new Vector(direction.x*mag, direction.y*mag, direction.z*mag);
  }
 
  //Get point on ray at distance t from origin
  Point get(float t) {
    return new Point(origin.x+t*direction.x, origin.y+t*direction.y, origin.z+t*direction.z);
  }
}
