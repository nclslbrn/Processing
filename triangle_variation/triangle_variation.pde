/* 
Copyright (c) 2013 Nicolas Lebrun- Creative Commons license .
*/
import processing.pdf.*;
boolean savePDF = true;
int rH, rW;
color[] myColors;


void setup() {
	size(600, 600);
	noStroke();
	noLoop();
	
	rH = height/6;
	rW = width/6;
	
	 myColors= new color[5];
	 myColors[0] = color (175, 183, 237);
	 myColors[1] = color (7, 4, 33);
	 myColors[2] = color (17, 39, 62);
	 myColors[3] = color (190, 19, 38);
	 myColors[4] = color (68, 10, 25);
}


void draw() {
  
background(0);
   if ( savePDF ) {
    beginRecord( PDF, "pdf/triangle_variation-############.pdf" );
    println("saving picture ...");
 }
 for (int y = 0; y < 8; y++) {
  for (int x = 0; x < 6; x++) {
    int c= int(random(myColors.length));
    int c2= int(random(myColors.length));
    stroke(myColors[c]);
    fill(myColors[c]);
    triangle( x*rW, y*rH, x*rW, (y*rH)+(rH), (x*rW)+(rW), (y*rH)+rH);
    
    stroke(myColors[c2]);
    fill(myColors[c2]);
    triangle( x*rW, y*rH, (x*rW)+(rW), y*rH, (x*rW)+(rW), (y*rH)+rH);
    }
  }
 if ( savePDF ) {
  endRecord();
  savePDF = false;
  println("picture saved");
 }

}

void mousePressed()
{
  if (mousePressed && (mouseButton == LEFT)){
    savePDF = false;
    redraw();
    savePDF = true;
    saveFrame("records/frame-###.jpg");
  }
}
