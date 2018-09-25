import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class composit extends PApplet {

PImage satelliteShot;
PVector satelliteShotAnchor;
int numParticle = 40;

public void setup() {
  satelliteShot = loadImage("satellite-shots/ISS032-E-17497-hd.JPG"); //4256 × 2832
  
  imageMode(CENTER);
  satelliteShotAnchor = new PVector( width/3, height/2);
}

public void draw() {
  satelliteShotAnchor.y += 0.5f;
  image( satelliteShot, satelliteShotAnchor.x, satelliteShotAnchor.y);

  stroke( color( random(120, 255), random(120, 255), random(120, 255) ) );

  for( int p = 0; p < numParticle; p++ ) {

      point( random( 0, width), random(0, height) );

  }
}
  public void settings() {  size( 720, 960); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "composit" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
