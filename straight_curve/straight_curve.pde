/**
 * Straight Curve (Software version: Processing 3.4)
 * Based on Straight Curve by Bridget Riley, 1963,
 * acrylic on board 24 x 28 in. (61 x 71.1 cm)
 *
 * © Nicolas Lebrun 2018 - All Right Reserverd
 */

import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioSample kick;

int columns = 27;
int rows = 40;

int initCellsHeight, initCellsWidth, cellSizeVariation;
float xIncrement, yIncrement;

float xIncrementFactor, yIncrementFactor, initStep;

float xIncrementStep, yIncrementStep;

float cellWidth, cellHeight, xPos, yPos;

int totalTriangles;

int prec, pasT, bd;


void setup() {

  size(869, 1010);
	smooth(10);
	noStroke();
	textSize(8);

	pasT = 100;
	minim = new Minim(this);
	kick = minim.loadSample( "BD.mp3", 2048 );

	initStep = -1;
	cellSizeVariation = 4;

	init();
}

void init() {

	initCellsHeight = height / rows;
	initCellsWidth = width / columns;

	xIncrement = -cellSizeVariation;
	yIncrement = -cellSizeVariation;

	xIncrementFactor = (width / 2) / (columns * cellSizeVariation);
	yIncrementFactor = (height / 5) / (rows * cellSizeVariation);

	xIncrementStep = initStep * xIncrementFactor;
	yIncrementStep = initStep * yIncrementFactor;

	xPos = 0;
	yPos = 0;

	totalTriangles = 0;

	cellHeight = initCellsHeight + yIncrement;
	cellWidth = initCellsWidth + xIncrementStep;

	bd = pasT;
	prec = 1;
	background(220);

}

void draw() {

		if( prec == 1 ) {

				kick.trigger();

		}

    if( (xPos + cellWidth < width) || (((xPos * 3) / initCellsWidth) < columns) ) {

        if( (yPos + cellHeight < height) || (( yPos / initCellsHeight) < rows) ) {

						if( prec != millis()/ bd % 2 && prec == 0 ) {

								if( yIncrement > cellSizeVariation ) {

										yIncrementStep--;
										 bd -= pasT;
								}

								if( yIncrement < -cellSizeVariation ) {

										yIncrementStep++;
										bd += pasT;
								}

								yIncrement += yIncrementStep;

								cellHeight = initCellsHeight + yIncrement;

								fill(0);
		            triangle(
			              xPos, yPos,
			              xPos + cellWidth, yPos + cellHeight,
			              xPos, yPos + cellHeight
		            );

		            yPos = yPos + cellHeight;
		            totalTriangles++;


							/* DEBUGG
								fill(255,0,0);
								text( totalTriangles, xPos, yPos );
							 */
						}
						prec = millis() / bd % 2;

        } else {
						//println("xPos =" + xPos );

						yIncrementStep = initStep * yIncrementFactor;
            yIncrement = -cellSizeVariation;
            yPos = 0;

            if( xIncrement > cellSizeVariation ) {

                xIncrementStep--;

            }

            if( xIncrement < -cellSizeVariation ) {

                xIncrementStep++;
            }

            xIncrement += xIncrementStep;
            cellWidth = initCellsWidth + xIncrement;
            xPos = xPos + cellWidth;

        }

    } else { // last cell of the column

				//noLoop();
				init();

		 }

}
void stop() {

	  kick.close();
	  minim.stop();

	  super.stop();

}
