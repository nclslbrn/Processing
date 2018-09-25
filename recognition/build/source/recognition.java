import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class recognition extends PApplet {

/**
 * Recognition
 * Nicolas Lebrun - Creative Commons Licence (CC-Zero)
 */

ArrayList<Particle> particles = new ArrayList<Particle>();


String[] dissidents = {
	"Ai_Weiwei", "Bao_Tong", "Chen_Pokong",	"Gao_Zhisheng",
  "He_Depu", "Hu_Jia", "Huang_Qi", "Ilham_Tohti",
  "Jian_Tianyong", "Jiang_Yefei", "Liao_Yiwu",	"Liu_Xiaobo",
	"Tang_Baiqiao",	"Wang_Dan",	"Wei_Jingsheng", "Wu_Gan",
  "Xu_Zhiyong",	"Yuan_Hongbing", "Zeng_Jinyan"
};
PFont font;

SoundFile[] cymbals;
SoundFile yankin; // 120 bpm C# 0'32

int numCymbals = 6;
int cymbalChoosen = 0;
int dissidentIndex = 0;
String dissidentName = "";

float pixelSteps = 3;
int animBegin = 0;
int animTime = 0;

int imageBlackThreshold = color(55);
int bgColor = color(255, 247, 247, 180);
boolean drawAsPoints = false;
float particleXDisplace = 1;

PImage pic;

public void settings() {

		//fullScreen(FX2D);
		size(751, 960, FX2D);

}

public void setup() {

		font = loadFont("AlteHaasGrotesk_Bold-110.vlw");

		frameRate(25);
		background(255, 247, 247);
		
		rectMode(CORNER);
		textFont(font, 45);
		textAlign(CENTER);

		cymbals = new SoundFile[numCymbals];
		yankin = new SoundFile( this, "chinese-traditional-yanqin-trap-loop.mp3");
		for( int c = 1; c < numCymbals; c++ ) {

				cymbals[c] = new SoundFile( this, "China0"+ c + ".wav");
				cymbals[c].amp(1);
		}

		getPicture();
		yankin.loop();

}
// Picks a random position from a point's radius
public PVector generateRandomPos(int x, int y, float mag) {

	  PVector randomDir = new PVector(random(0, width), random(0, height));

	  PVector pos = new PVector(x, y);
	  pos.sub(randomDir);
	  pos.normalize();
	  pos.mult(mag);
	  pos.add(x, y);

	  return pos;
}


public void getPicture() {

	  dissidentName = dissidents[dissidentIndex];
	  pic = loadImage(dissidentName + ".jpg");
	  String[] name = split( dissidentName, "_");

	  dissidentName = name[0] + " " + name[1];

		int particleCount = particles.size();
		int particleIndex = 0;
	  int newColor = 0;
	  loadPixels();
	  pic.loadPixels();
		ArrayList<Integer> coordsIndexes = new ArrayList<Integer>();

	  for( int i = 0; i < (width * height)-1; i += pixelSteps) {

	    	coordsIndexes.add(i);
	  }

		for (int i = 0; i < coordsIndexes.size (); i++) {

		    // Pick a random coordinate
		    int randomIndex = (int)random(0, coordsIndexes.size());
		    int coordIndex = coordsIndexes.get(randomIndex);
		    coordsIndexes.remove(randomIndex);

				int x = coordIndex % width;
				int y = coordIndex / width;

				if( pic.get(x, y) < imageBlackThreshold ) {

		  			Particle newParticle;

		  			if (particleIndex < particleCount) {

			  				// Use a particle that's already on the screen
			  				newParticle = particles.get(particleIndex);
			  				newParticle.isKilled = false;
			  				particleIndex += 1;


		  			} else {

			  				// Create a new particle
			  				newParticle = new Particle();

			  				PVector randomPos = generateRandomPos(width/2, height/2, (width+height)/2);
			  				newParticle.pos.x = randomPos.x;
			  				newParticle.pos.y = randomPos.y;
								newParticle.particleXDisplace = particleXDisplace;
			  				newParticle.maxSpeed = random(2.0f, 5.0f);
			  				newParticle.maxForce = newParticle.maxSpeed*0.025f;
			  				newParticle.particleSize = random(3, 6);
			  				newParticle.colorBlendRate = random(0.0025f, 0.03f);

			  				particles.add(newParticle);

		  			}

		  			// Blend it from its current color
		  			newParticle.startColor = lerpColor(newParticle.startColor, newParticle.targetColor, newParticle.colorWeight);
		  			newParticle.targetColor = newColor;
		  			newParticle.colorWeight = 0;

		  			// Assign the particle's new target to seek
		  			newParticle.target.x = x;
		  			newParticle.target.y = y;

		  	}

  	}
		// Kill off any left over particles
		if (particleIndex < particleCount) {
			 	for (int i = particleIndex; i < particleCount; i++) {
						Particle particle = particles.get(i);
						particle.kill();
				}
		}
		animBegin = millis();
	//	animTime = (int)(particles.size() / 1.8);
		animTime = (int)(yankin.duration() * 1000);
		cymbalChoosen = (int)random( 1, numCymbals );
		cymbals[cymbalChoosen].play();

	  // println( dissidentName + " " + (dissidentIndex + 1) + "/" +  dissidents.length + " time :" + animTime);

}
public void draw() {

	  fill(bgColor);
	  noStroke();
	  rect(0, 0, width, height);

	  for (int x = particles.size()-1; x > -1; x--) {

		    // Simulate and draw pixels
		    Particle particle = particles.get(x);
				particle.particleXDisplace = particleXDisplace;
		    particle.move();
		    particle.draw();

		    // Remove any dead pixels out of bounds
		    if (particle.isKilled) {
			      if (particle.pos.x < 0 || particle.pos.x > width || particle.pos.y < 0 || particle.pos.y > height) {
			        	particles.remove(particle);
			      }
		    }

	  }

	  fill(0);
	  text( dissidentName, -1, height - 65, width, height);
	  text( dissidentName, 1, height - 65, width, height);
	  text( dissidentName, 0, height - 63, width, height);

	  fill( 255, 247, 247 );
	  text( dissidentName, 0, height - 64, width, height);

	  //fill(0);
	  //String debugg = millis() + ">" +(animBegin + animTime);
	  //text( debugg, 0, 0, width, 125 );

		if( millis() > animBegin + animTime  ) {

				cymbals[cymbalChoosen].stop();
				// yankin.stop();
		    dissidentIndex++;
				particleSize = 2.0f;

		   	if( dissidentIndex == dissidents.length ) {

						dissidentIndex = 0;
			      println("END: " + millis());
				}
				getPicture();

		} else {

				if( millis() > (animTime * 0.90f) + animBegin ) {

						particleSize+= 0.2f;

				}
				if( millis() > (animTime * 0.95f) + animBegin ) {

						particleSize-= 0.4f;

				}

		}

}
class Particle {

  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  PVector target = new PVector(0, 0);

  float closeEnoughTarget = 50;
  float maxSpeed = 3.5f;
  float maxForce = 0.1f;
  float particleSize = 2;
  boolean isKilled = false;

  int startColor = color(0);
  int targetColor = color(0);
  float colorWeight = 0;
  float colorBlendRate = 0.025f;

  public void move() {
    // Check if particle is close enough to its target to slow down
    float proximityMult = 1.0f;
    float distance = dist(this.pos.x, this.pos.y, this.target.x, this.target.y);
    if (distance < this.closeEnoughTarget) {
      proximityMult = distance/this.closeEnoughTarget;
    }

    // Add force towards target
    PVector towardsTarget = new PVector(this.target.x, this.target.y);
    towardsTarget.sub(this.pos);
    towardsTarget.normalize();
    towardsTarget.mult(this.maxSpeed*proximityMult);

    PVector steer = new PVector(towardsTarget.x, towardsTarget.y);
    steer.sub(this.vel);
    steer.normalize();
    steer.mult(this.maxForce);
    this.acc.add(steer);

    // Move particle
    this.vel.add(this.acc);
    this.pos.add(this.vel);
    this.acc.mult(0);
  }

  public void draw() {
    // Draw particle
    int currentColor = lerpColor(this.startColor, this.targetColor, this.colorWeight);
    if (drawAsPoints) {
      stroke(currentColor);
      point(this.pos.x, this.pos.y);
    } else {

      stroke(currentColor);
			line(this.pos.x, this.pos.y, this.pos.x, this.pos.y + this.particleSize  );
    //  ellipse(this.pos.x, this.pos.y, this.particleSize, this.particleSize);
    }

    // Blend towards its target color
    if (this.colorWeight < 1.0f) {
      this.colorWeight = min(this.colorWeight+this.colorBlendRate, 1.0f);
    }
  }

  public void kill() {
    if (! this.isKilled) {
      // Set its target outside the scene
      PVector randomPos = generateRandomPos(width/2, height/2, (width+height)/2);
      this.target.x = randomPos.x;
      this.target.y = randomPos.y;

      // Begin blending its color to black
      this.startColor = lerpColor(this.startColor, this.targetColor, this.colorWeight);
      this.targetColor = color(0);
      this.colorWeight = 0;

      this.isKilled = true;
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "recognition" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
