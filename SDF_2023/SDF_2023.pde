float emitterX, emitterY, emitterZ;
ArrayList<Tracer> tracers;
SDF sdf;
 
void setup() {
  size(900, 900, P3D);
  smooth(16);
  noCursor();
  createTracers();
  createSDF();
  trace();
}
 
void createTracers() {
  tracers=new ArrayList<Tracer>();
  float x, y;
  emitterZ=500;
  float cutoff=2*emitterZ;
  int resX=50;
  emitterX=600.0;
  int resY=50;
  emitterY=600.0;
 
  for (int i=0; i<resX; i++) {
    x=map(i, 0, resX-1, -emitterX*0.5, emitterX*0.5);
    for (int j=0; j<resY; j++) {
      y=map(j, 0, resY-1, -emitterY*0.5, emitterY*0.5);
      tracers.add(new Tracer(new Point(x, y, emitterZ),new Vector( 0, 0, -1), cutoff, 0.1));
    }
  }
}
 
void createSDF() {
  SphereSDF ssdf=new SphereSDF(120);
  sdf=ssdf;
}
 
void trace(){
  for (Tracer tracer : tracers) {
    tracer.trace(sdf);
  }
}
 
void draw() {
  background(15);
  //setup perspective
  translate(width/2, height/2, 0);
  rotateY(0.8*QUARTER_PI);
  translate(0, 0, 200);
 
  //draw sphere
  fill(0);
  noStroke();
  // sphere(119);
 
  //draw limiting plane
  pushMatrix();
    translate(0, 0, -emitterZ-1.0);
    rect(-emitterX*0.5, -emitterY*0.5, emitterX, emitterY);
  popMatrix();
 
  //draw tracers
  // strokeWeight(2);
  // stroke(240);
  
  stroke(255);
  for (int i = 0; i < tracers.size()-1; i++) { // Tracer tracer : tracers
    // println(tracer.ray.origin);
    Tracer ti = tracers.get(i);
    Tracer tin = tracers.get(i+1);
    line(ti.p.x, ti.p.y, ti.p.z, tin.p.x, tin.p.y, tin.p.z);
  }
}
