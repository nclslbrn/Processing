/**
 * Based on Voronoi clipping (exemple of Toxiclibs library)
 * @link http://toxiclibs.org/
 */
import toxi.geom.*;
import toxi.geom.mesh2d.*;
import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.processing.*;


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

  record.fill(0);
  record.rect(-1, -1, width+1, height+1);
  record.stroke(255);

  for (Polygon2D poly : voronoi.getRegions()) {  
    gfx.polygon2D(clip.clipPolygon(poly));
  }
  
  record.endDraw();


  if( mousePressed == true ) {
    record.save( "records/frame-###.jpg" );  
  } 
  else if( frameCount % num_frame == 0 ) {
    voronoi.addPoint( new Vec2D(random(1)*width, random(1)*height) );
  }
}