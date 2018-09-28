/**
 * Recognition
 * Nicolas Lebrun - Creative Commons Licence (CC-Zero)
 */
import processing.sound.*;

// debugg
//import controlP5.*;
//ControlP5 cp5;

PerlinNoiseField field;
ArrayList<Particle> particles = new ArrayList<Particle>();

float fieldIntensity = 250;
float noiseScale = 100;

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

color newColor;
color imageBlackThreshold = color(55);
int bgColor = 0;
int alphaBlackInit = 100;
int alphaBack = alphaBlackInit;
boolean drawAsPoints = false;

PImage pic;

void settings() {

		//fullScreen(FX2D);
		size(751, 960, P3D);

}

void setup() {

	//	font = loadFont("AlteHaasGrotesk_Bold-110.vlw");
		cnFont = createFont("NotoSansCJKtc-Regular.otf", 45);
		frameRate(25);
    noCursor();
		background(0);
		smooth(12);
		rectMode(CORNER);
		textFont(cnFont, 45);
		textAlign(CENTER);
/*
		cp5 = new ControlP5(this);
		cp5.addSlider("fieldIntensity")
			.setPosition( 0, height - 40)
			.setSize( width, 15)
			.setRange( 0, 300)
			.setValue( 10 )
			.setColorCaptionLabel( color( 20, 20, 20) );

		cp5.addSlider("alphaBack")
			.setPosition( 0, height - 20)
			.setSize( width, 15)
			.setRange( 0, 255)
			.setValue( 150 )
			.setColorCaptionLabel( color( 20, 20, 20) );
*/
		cymbals = new SoundFile[numCymbals];
		yankin = new SoundFile( this, "chinese-traditional-yanqin-trap-loop.mp3");
		for( int c = 1; c < numCymbals; c++ ) {

				cymbals[c] = new SoundFile( this, "China0"+ c + ".wav");
				cymbals[c].amp(1);
		}

		getPicture();
		yankin.loop();
		initForceFieldPerlinNoise();
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
void initForceFieldPerlinNoise() {

		field = new PerlinNoiseField(fieldIntensity, noiseScale);

}

void getPicture() {

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


}
void draw() {

    if( millis() > animBegin + animTime  ) {

        cymbals[cymbalChoosen].stop();
        // yankin.stop();
        dissidentIndex++;
        alphaBack = alphaBlackInit;

         if( dissidentIndex == dissidents.length ) {

            dissidentIndex = 0;
            println("END: " + millis());
        }
				field.fieldIntensity = fieldIntensity;
				getPicture();

    } else {


        if( millis() > (animTime * 0.90) + animBegin) {

            if( millis() > (animTime * 0.90) + animBegin ) {
							 field.fieldIntensity = field.fieldIntensity - 2;
            }
            if( millis() > (animTime * 0.95) + animBegin ) {
               alphaBack--;
            }
            //background(pic);
        }
        fill(color( bgColor, alphaBack));
        noStroke();
        rect(0, 0, width, height);

				fill( newColor );
				text( dissidentsName[dissidentIndex] + " / " + dissidentNameRoman , 0, height-60, width, height);
    }
	  for (int x = particles.size()-1; x > -1; x--) {

		    // Simulate and draw pixels
		    Particle particle = particles.get(x);
				PVector position = particle.pos;
				float angle = field.getNoiseValue( particle.pos );

				particle.move();
				particle.pos = new PVector(
						particle.pos.x += cos( angle ) * (particle.pos.x - position.x),
						particle.pos.y += sin( angle ) * (particle.pos.y - position.y)
				);
		    particle.draw();

		    // Remove any dead pixels out of bounds
		    if (particle.isKilled) {
			      if (particle.pos.x < 0 || particle.pos.x > width || particle.pos.y < 0 || particle.pos.y > height) {
			        	particles.remove(particle);
			      }
		    }

	  }

}
