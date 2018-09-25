import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import http.requests.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class chat_with_motion extends PApplet {

/**
 * Chat with motion
 * @link https://github.com/nclslbrn/chat_with_motion
 * Processing port of the initial html/js Chat Project (2017)
 * @link https://github.com/nclslbrn/CHAT
 * @link https://nicolas-lebrun.fr/fr/project/chat/
 */
// TODO: fix encoded characters



ArrayList<Particle> particles = new ArrayList<Particle>();

String[] quotes;
String[] authors;

int quotesID = 0;
int pixelSteps = 3;
int animBegin = 0;
int animTime = 0;
int textSize = 15000;
int totalQuotes = 0;
int msPerCharacter = 100;
int bgColor = color(0, 100);
boolean drawAsPoints = true;

public void settings() {
	fullScreen(FX2D);
	//size(1280, 720, FX2D);

}
public void setup() {

	background(50);
	
	rectMode(CORNER);

	getMessage();

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

public void getMessage() {

	GetRequest get = new GetRequest("https://chat.artemg.com/data/?chat=query");
	get.send();

	JSONObject response = parseJSONObject( get.getContent() );
	JSONArray themes = response.getJSONArray( "themes" );
	JSONArray texts = response.getJSONArray( "texts" );

	quotes = new String[ texts.size() ];
	authors = new String[ texts.size() ];

	for( int i=0; i < texts.size(); i++ ) {

		JSONObject data = texts.getJSONObject(i);
		String quote = data.getString("text");
		String author = data.getString("author");

		quotes[i] = quote;
		authors[i] = author;
		totalQuotes = i;

	}
	getVectorText();

}
public void getVectorText() {

	String currentText = quotes[quotesID] + "\n \n" + authors[quotesID];
	int currentTextSize = textSize / currentText.length();
	int newColor = color(random(150.0f, 255.0f), random(150.0f, 255.0f), random(150.0f, 255.0f));
	PGraphics pg = createGraphics(width, height);
	pg.beginDraw();
	pg.fill(0);
	pg.textSize( currentTextSize );
	pg.textAlign(CENTER, CENTER);
	PFont font = createFont("Geomanist-Regular.otf", currentTextSize, true);
	pg.textFont(font);
	pg.text(currentText, width/6, height/8, width*0.66666f, height*0.75f);
	pg.endDraw();
	pg.loadPixels();

	int particleCount = particles.size();
	int particleIndex = 0;

	ArrayList<Integer> coordsIndexes = new ArrayList<Integer>();

	for( int i = 0; i < (width * height)-1; i += pixelSteps) {

		coordsIndexes.add(i);
	}

	for (int i = 0; i < coordsIndexes.size (); i++) {

    // Pick a random coordinate
    int randomIndex = (int)random(0, coordsIndexes.size());
    int coordIndex = coordsIndexes.get(randomIndex);
    coordsIndexes.remove(randomIndex);

		if( pg.pixels[coordIndex] != 0) {

			int x = coordIndex % width;
			int y = coordIndex / width;

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
	animTime = currentText.length() * msPerCharacter;
}
public void draw() {

	fill(bgColor);
  noStroke();
  rect(0, 0, width*2, height*2);

  for (int x = particles.size ()-1; x > -1; x--) {
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
	if( animBegin + animTime < millis() ) {
		if( quotesID > totalQuotes ) {

			quotesID++;
			getVectorText();

		} else {

			getMessage();

		}
	}

}
class Particle {

  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  PVector target = new PVector(0, 0);

  float closeEnoughTarget = 50;
  float maxSpeed = 4.0f;
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
      noStroke();
      fill(currentColor);
      ellipse(this.pos.x, this.pos.y, this.particleSize, this.particleSize);
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
    String[] appletArgs = new String[] { "chat_with_motion" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
