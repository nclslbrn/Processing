
//Interface that implements a signed distance function
interface SDF {
  float signedDistance(Point p);
}

class SphereSDF implements SDF {
  float radius;
 
  SphereSDF(float r) {
    radius=r;
  }
 
  float signedDistance(Point p) {
    return sqrt(sq(p.x)+sq(p.y)+sq(p.z))-radius;
  }
}

class BoxSDF implements SDF {
  float X, Y, Z;
 
  BoxSDF(float x, float y, float z) {
    X=x;
    Y=y;
    Z=z;
  }
 
  float signedDistance(Point p) {
    float qx=abs(p.x)-X;
    float qy=abs(p.y)-Y;
    float qz=abs(p.z)-Z;
    return sqrt(sq(max(qx,0.0))+sq(max(qy,0.0))+sq(max(qz,0.0)))+min(max(qx, qy, qz), 0.0);
  }
}
