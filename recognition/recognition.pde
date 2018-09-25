/**
 * Recognition
 * Nicolas Lebrun - Creative Commons Licence (CC-Zero)
 */
import processing.sound.*;
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

float pixelSteps = 5;
int animBegin = 0;
int animTime = 0;

color newColor;
color imageBlackThreshold = color(55);
int bgColor = 0;
int alphaBack = 245;
boolean drawAsPoints = false;

PImage pic;

void settings() {

		//fullScreen(FX2D);
		size(751, 960, FX2D);

}

void setup() {

		font = loadFont("AlteHaasGrotesk_Bold-110.vlw");

		frameRate(25);
		background(0);
		smooth(4);
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
PVector generateRandomPos(int x, int y, float mag) {

	  PVector randomDir = new PVector(random(0, width), random(0, height));

	  PVector pos = new PVector(x, y);
	  pos.sub(randomDir);
	  pos.normalize();
	  pos.mult(mag);
	  pos.add(x, y);

	  return pos;
}


void getPicture() {

	  dissidentName = dissidents[dissidentIndex];
	  pic = loadImage(dissidentName + ".jpg");
	  String[] name = split( dissidentName, "_");

	  dissidentName = name[0] + " " + name[1];

		int particleCount = particles.size();
		int particleIndex = 0;
	  newColor = color( random(75, 255), random(75, 255), random(75, 255));
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
			  				newParticle.maxSpeed = random(2.0, 8.0);
			  				newParticle.maxForce = newParticle.maxSpeed*0.025;
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

	  println( dissidentName + " " + (dissidentIndex + 1) + "/" +  dissidents.length);

}
void draw() {

	  

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
       
            
        if( millis() > (animTime * 0.90) + animBegin) {
          
            if( millis() > (animTime * 0.90) + animBegin ) {
               alphaBack--;
            }
            if( millis() > (animTime * 0.95) + animBegin ) {    
                alphaBack--;
            }
            background(pic);
        }
        fill(color( bgColor, alphaBack));
        noStroke();
        rect(0, 0, width, height);
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
