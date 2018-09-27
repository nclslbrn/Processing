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
  "Jian_Yanyong", "Jiang_Yefei", "Liao_Yiwu",	"Liu_Xiaobo",
	"Tang_Baiqiao",	"Wang_Dan",	"Wei_Jingsheng", "Wu_Gan",
  "Xu_Zhiyong",	"Yuan_Hongbing", "Zeng_Jinyan"
};
String [] dissidentsName = {
	"艾未未", "鮑彤", "陳破空", "高智晟",
	"何德普", "胡佳", "黃琦", "伊力哈木",
	"蔣彥永", "蔣葉菲", "廖亦武", "刘晓波",
	"唐柏桥", "王丹", "魏京生", "吴淦",
	"许志永", "袁红冰", "曾金燕"
};
PFont font;
PFont cnFont;

SoundFile[] cymbals;
SoundFile yankin; // 120 bpm C# 0'32

int numCymbals = 6;
int cymbalChoosen = 0;
int dissidentIndex = 0;
String dissidentNameRoman = "";

float pixelSteps = 5;
int animBegin = 0;
int animTime = 0;

int newColor;
int imageBlackThreshold = color(55);
int bgColor = 0;
int alphaBack = 245;
boolean drawAsPoints = false;

PImage pic;

public void settings() {

		//fullScreen(FX2D);
		size(751, 960, FX2D);

}

public void setup() {

	//	font = loadFont("AlteHaasGrotesk_Bold-110.vlw");
		cnFont = createFont("NotoSansCJKtc-Regular.otf", 45);
		frameRate(25);
		background(0);
		
		rectMode(CORNER);
		textFont(cnFont, 45);
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

	  dissidentNameRoman = dissidents[dissidentIndex];
	  pic = loadImage(dissidentNameRoman + ".jpg");
	  String[] name = split( dissidentNameRoman, "_");

	  dissidentNameRoman = name[0] + " " + name[1];

		int particleCount = particles.size();
		int particleIndex = 0;
	  newColor = randomColor();
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

				if( pic.get(x, y) > imageBlackThreshold ) {

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
			  				newParticle.maxSpeed = random(2.0f, 8.0f);
			  				newParticle.maxForce = newParticle.maxSpeed*0.025f;
			  				newParticle.size = random(1, 2);
			  				particles.add(newParticle);

		  			}

		  			// Blend it from its current color
		  			newParticle.startColor = lerpColor(newParticle.startColor, newParticle.targetColor, newParticle.colorWeight);
		  			newParticle.targetColor = newColor;

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

	  println( dissidentNameRoman + " " + (dissidentIndex + 1) + "/" +  dissidents.length);

}
public void draw() {

    if( millis() > animBegin + animTime  ) {

        cymbals[cymbalChoosen].stop();
        // yankin.stop();
        dissidentIndex++;
        alphaBack = 245;

         if( dissidentIndex == dissidents.length ) {

            dissidentIndex = 0;
            println("END: " + millis());
        }
        getPicture();

    } else {


        if( millis() > (animTime * 0.90f) + animBegin) {

            if( millis() > (animTime * 0.90f) + animBegin ) {
               alphaBack--;
            }
            if( millis() > (animTime * 0.95f) + animBegin ) {
               alphaBack--;
            }
            background(pic);
        }
        fill(color( bgColor, alphaBack));
        noStroke();
        rect(0, 0, width, height);

				fill( newColor );
				text( dissidentsName[dissidentIndex] + " / " + dissidentNameRoman , 0, 0, width, height );
    }
	  for (int x = particles.size()-1; x > -1; x--) {

		    // Simulate and draw pixels
		    Particle particle = particles.get(x);
		    particle.move();
		    particle.draw();

		    // Remove any dead pixels out of bounds
		    if (particle.isKilled) {
			      if (particle.pos.x < 0 || particle.pos.x > width || particle.pos.y < 0 || particle.pos.y > height) {
			        	particles.remove(particle);
			      }
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
  float size = 2;
  boolean isKilled = false;

  int startColor = color(random(0, 255), random(0, 255), random(0, 255));
  int targetColor = color(random(0, 255), random(0, 255), random(0, 255));
  float colorWeight = 0.01f;
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
			line(this.pos.x , this.pos.y, this.pos.x, this.pos.y+ this.size );
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
public int randomColor() {

  int[] colors = {
    0xff1abc9c,
    0xff16a085,
    0xff2ecc71,
    0xff27ae60,
    0xff3498db,
    0xff2980b9,
    0xff9b59b6,
    0xff8e44ad,
    0xff34495e,
    0xff2c3e50,
    0xfff1c40f,
    0xfff39c12,
    0xffe67e22,
    0xffd35400,
    0xffe74c3c,
    0xffc0392b,
    0xffecf0f1,
    0xffbdc3c7,
    0xff95a5a6,
    0xff7f8c8d
  };

  int colorID = (int)random( 0, colors.length );
  println( colorID );
  int choosenColor = color( colors[ colorID ] );

  return choosenColor;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "recognition" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
