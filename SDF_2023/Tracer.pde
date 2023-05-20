class Tracer {
  Ray ray;
  float cutoff;
  float precision;
  float t;
  float closestDistance;
  int steps;
  int MAXSTEPS=10000;
  Point p;
 
  Tracer(Point origin, Vector direction, float cutoff, float precision) {
    ray=new Ray(origin, direction);
    this.cutoff=cutoff;
    this.precision=precision;
    initialize();
  }
 
  void initialize(){
    closestDistance= Float.POSITIVE_INFINITY;
    t=0;
    steps=0;
    p=ray.get(0);
  }
 
  void trace(SDF sdf) {
    p=null;
    t=0.0;
    steps=0;
    do {
      traceStep(sdf);
      steps++;
    } while (!onSurface() && t<cutoff && steps<MAXSTEPS);
    if (t>cutoff) t=cutoff;
    p=ray.get(t);
  }
 
  void traceStep(SDF sdf){
    float d=sdf.signedDistance(ray.get(t));
    if (d<closestDistance) closestDistance=d;
    t+=d;
  }
 
  boolean onSurface(){
    return closestDistance<=precision;
  }
 
  void reset() {
    initialize();
  }
}
