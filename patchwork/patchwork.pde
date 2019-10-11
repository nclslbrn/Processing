/**
 * Based on Voronoi clipping (exemple of Toxiclibs library)
 * @link http://toxiclibs.org/
 */
import toxi.geom.*;
import toxi.geom.mesh2d.*;
import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.processing.*;

//color[] ducci_x = {#dd614a, #f5cedb, #1a1e4f};
color[] urban_scheme = {#A9C2C2, #1D1A11, #82B1B9, #A39A88, #2C3D25, #D53F18, #D7D8D0, #1F5D52, #738480, #596242,#48453D, #24A8BA};
ToxiclibsSupport gfx;
Voronoi voronoi = new Voronoi();
PolygonClipper2D clip;

PGraphics record;
int num_frame = 24;

void setup() {

  size(800, 800);

  clip=new ConvexPolygonClipper(
    new Circle(width*0.35).toPolygon2D(8).translate(
      new Vec2D(width/2,height/2)
    )
  );

  gfx = new ToxiclibsSupport(this, record = createGraphics(width, height));
  

}

void draw() {
  
  record.beginDraw();
  //record.noStroke();

  int poly_id = 0;

  for (Polygon2D poly : voronoi.getRegions()) {  

    int color_id;
  
    if( poly_id < urban_scheme.length-1 ) {
      color_id = poly_id;
    } else{
      color_id = poly_id % urban_scheme.length;
    }

    record.fill( urban_scheme[color_id] );
    record.beginShape();

    for (int p = 0; p < poly.vertices.size(); p++) {
      
      Vec2D v = poly.vertices.get(p);
      record.vertex( v.x, v.y);
    }
    record.endShape(CLOSE);
    poly_id++;
  }
  
  record.endDraw();

  image(record, 0, 0);


  if( mousePressed == true ) {
    record.save( "records/frame-###.jpg" );  
  } 
  else if( frameCount % num_frame == 0 ) {
    voronoi.addPoint( new Vec2D(random(1)*width, random(1)*height) );
  }
}