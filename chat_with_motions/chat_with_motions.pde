/**
 * Chat with motion
 * @link https://github.com/nclslbrn/chat_with_motion
 * Processing port of the initial html/js Chat Project (2017)
 * @link https://github.com/nclslbrn/CHAT
 * @link https://nicolas-lebrun.fr/fr/project/chat/
 * @libray HTTP requests for Processing https://github.com/runemadsen/HTTP-Requests-for-Processing
 */

import http.requests.*;

ArrayList<Particle> particles = new ArrayList<Particle>();

String[] quotes;
String[] authors;

int quotesID = 0;
int pixelSteps = 3;
int animBegin = 0;
int animTime = 0;
int textSizeInit = 64;
int totalQuotes = 0;
int msPerCharacter = 75;
color bgColor = color(0, 100);
boolean drawAsPoints = true;

void settings() {
	//fullScreen(FX2D);
	size(1000, 1000, FX2D);

}
void setup() {

	background(50);
	//smooth();
	rectMode(CORNER);

	getMessage();

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

void getMessage() {

		GetRequest get = new GetRequest("https://chat.artemg.com/data/?chat=query");
		get.addHeader("Charset", "UTF-8");
		get.send();

		JSONObject response = parseJSONObject( get.getContent() );
		JSONArray themes = response.getJSONArray( "themes" );
		JSONArray texts = response.getJSONArray( "texts" );

		totalQuotes = texts.size();

		quotes = new String[ totalQuotes ];
		authors = new String[ totalQuotes ];

		for( int i=0; i < totalQuotes; i++ ) {

				JSONObject data = texts.getJSONObject(i);
				String quote = data.getString("text", "UTF-8");
				String author = data.getString("author", "UTF-8");
				
				author = author.replace("&eacute;", "é");
				author = author.replace("&apos;", "'");
				author = author.replace("&egrave;", "è");
				
				quotes[i] = quote;
				authors[i] = author;

		}
		getVectorText();

}
void getVectorText() {

		String currentText = new String(quotes[quotesID]+ "\n\n" + authors[quotesID]);
		int textLength =  currentText.length();
		int textSize = textSizeInit;

		if( textLength > 400 ) {
				textSize = int( textSize / 1.8 );
		}

		if( textLength < 400 && textLength > 320 ) {
				textSize = int( textSize / 1.6 );
		}

		if( textLength < 320 && textLength > 260 ) {
				textSize = int( textSize / 1.5 );
		}

		if( textLength < 260 && textLength > 130 ) {
				textSize = int( textSize / 1.2 );
		}

		if( textLength < 130 ) {
				textSize = int( textSize * 1.1 );
		}

		
		color newColor = color(random(150.0, 255.0), random(150.0, 255.0), random(150.0, 255.0));
		PGraphics pg = createGraphics(width, height);
		pg.beginDraw();
		pg.fill(0);
		pg.textSize( textSize );
		pg.textAlign(CENTER, CENTER);
		PFont font = createFont("Geomanist-Regular.otf", textSize, true);
		pg.textFont(font);
		pg.text(currentText, width/6, height/8, width*0.66666, height*0.75);
		pg.endDraw();
		pg.loadPixels();

		println("string length : " + textLength + " text size " + textSize );

		int particleCount = particles.size();
		int particleIndex = 0;

		ArrayList<Integer> coordsIndexes = new ArrayList<Integer>();

		for( int i = 0; i < (width * height)-1; i += pixelSteps) {

				coordsIndexes.add(i);
		}

		for (int i = 0; i < coordsIndexes.size(); i++) {

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

								PVector randomPos = generateRandomPos(
										width/2, 
										height/2, 
										(width+height)/2
								);

								newParticle.pos.x = randomPos.x;
								newParticle.pos.y = randomPos.y;

								newParticle.maxSpeed = random(2.0, 5.0);
								newParticle.maxForce = newParticle.maxSpeed*0.025;
								newParticle.particleSize = random(3, 6);
								newParticle.colorBlendRate = random(0.0025, 0.03);

								particles.add(newParticle);
						}

						// Blend it from its current color
						newParticle.startColor = lerpColor(
								newParticle.startColor, 
								newParticle.targetColor,
								newParticle.colorWeight
						);

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
void draw() {

		fill(bgColor);
		noStroke();
		rect(0, 0, width, height);

		for (int x = particles.size ()-1; x > -1; x--) {
				// Simulate and draw pixels
				Particle particle = particles.get(x);
				particle.move();
				particle.draw();

				// Remove any dead pixels out of bounds
				if (particle.isKilled) {

						if (
								 particle.pos.x < 0
							|| particle.pos.x > width
							|| particle.pos.y < 0
							|| particle.pos.y > height
						) {
								particles.remove(particle);
						}
				}
		}
		if( animBegin + animTime < millis() ) {

				if( quotesID < totalQuotes - 1 ) {

						quotesID++;
						getVectorText();

				} else {
						quotesID = 0;
						println( "Get new themes and quotes" );
						getMessage();

				}
		}

}
