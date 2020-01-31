import processing.opengl.*;

float R_y = 0;
int S_y = 1;


import processing.video.*;

int nDelayFrames = 01; // 90 = about 3 seconds
int currentFrame = nDelayFrames-1;
int m = millis();
Capture video;
PImage frames[];

int steps = 32;

StringList quotes;

int time;
int wait = 3000;

int randomCount;
int a = 0;

PFont console;

public void setup() {
  size(1366, 768, P3D);
  //size(displayWidth, displayHeight, OPENGL);
  //frameRate(30);
  camera(width/2 ,height/2 ,(height/2)/tan(PI*30/180), width/2, height/2, 0, 0, 1, 0);
  video = new Capture(this, 640, 480, 30);
  frames = new PImage[nDelayFrames];
  frame.setBackground(new java.awt.Color(0, 0, 0));
  video.start();
  
  quotes = new StringList();
  quotes.append("Le temps met tout en lumière.\n\n -Thalès");
  quotes.append("On ne se baigne jamais deux fois dans le même fleuve.\n\n -Héraclite d'Ephèse");
  quotes.append("Nous apprécions le mouvement  par le temps, mais aussi le temps par le mouvement, car ils se définissent réciproquement. Le temps indique le mouvement et le mouvement le temps.\n\n -Aristote, Physique");
  quotes.append("Nous piétinerons éternellement aux frontières de l'Inconnu, cherchant à comprendre ce qui restera toujours incompréhensible. Et c'est précisément cela qui fait de nous des hommes.\n\n -Isaac Asimov, Les cavernes d'acier");
  quotes.append("Si je veux me préparer un verre d'eau sucrée, j'ai beau faire, je dois attendre que le sucre fonde. Ce petit fait est gros d'enseignements. Car le temps que j'ai à attendre n'est plus ce temps mathématique qui s'appliquerait aussi bien le long de l'histoire entière du monde matériel, lors même qu'elle serait étalée tout d'un coup dans l'espace.\n\n -Henri Bergson, L’Evolution Créatrice");
  quotes.append("Le problème changerait de sens si nous considérions la construction réelle du temps à partir des instants, au lieu de sa division toujours factice à partir de la durée. Nous verrions alors que le temps se multiplie sur le schème des correspondances numériques, loin de se diviser sur le schème du morcelage d’un continu.\n\n -Gaston Bachelard, L’Intuition de l’instant");
  quotes.append("L'eau est infinie car elle est en liberté.\n\n -Floriant & Bilal");
  quotes.append("Je cours dans l'univers car je suis libre. \n\n -Tommy & Justine");
  quotes.append("Le son c'est le sens de l'univers. \n\n -Fabiana & Morgane");
  quotes.append("La vitesse de l'éclair m'emporte à tel point que je ne peux me rattraper. \n\n -Steacy & Lya");
  quotes.append("L'éclair traverse l'univers avec un son infini. \n\n -Samia & Aya");
  quotes.append("Le son est la mémoire de la tête. \n\n -Fatine & Léa");
  quotes.append("Plus je cours, plus ma mémoire s'éclaire. \n\n -Medhi & Rochelle");
  quotes.append("Dans ma mémoire, il y a une infinité de moments importants. \n\n -Sanna & Sam");
  quotes.append("Le vent m'emporte et l'éclair me traverse. \n\n -Shawn & Quentin");
  quotes.append("La vitesse de la lumière a un son énorme. \n\n -Yassine & Fatine");
  quotes.append("La vitesse de la lumière emporte les étoiles. \n\n -Fabiana & Morgane");
  quotes.append("L'éclair est libre de ses mouvements. \n\n -Steacy & Lya");
  quotes.append("Dans mon coeur, j'écris une histoire infinie. \n\n -Floriant & Bilal");
  

  console = loadFont("Consolas-48.vlw");
  
  time = millis();
  
  for (int i=0; i<nDelayFrames; i++) {
    frames[i] = createImage(800, 600, ARGB);
  }
}

public void draw() {
  background(0);
  lights();
      
  if ( S_y == 1) {
    R_y += 0.001;
  }
  else if (S_y == -1) {
    R_y -= 0.001;
  }
  if ((R_y > QUARTER_PI ) || (R_y < -QUARTER_PI)) {
    S_y =- S_y;
  }
   
    if (video.available() == true) {
    video.read();
    
    frames[currentFrame].loadPixels();
    arrayCopy (video.pixels, frames[currentFrame].pixels);
    frames[currentFrame].updatePixels();
    currentFrame = (currentFrame-1 + nDelayFrames) % nDelayFrames;
    
    translate(width/3.7 ,height/1.7, -200);
    scale(-1, 1, 1);
    
        if (millis() - time >= wait){
          
            randomCount = int(random(0, 35));
            a = int(random(0, 19));
            R_y = random( -QUARTER_PI, QUARTER_PI);
            time = millis();//also update the stored time
        } 
    
        if (randomCount <= 2){                
            displayQuotes();            
        }
        if((randomCount > 2) && (randomCount < 19)){
            displayCube(); 
        }
        if(randomCount >= 19){
            displayVariable();
        }
    }
  }
  void displayCube(){
 
  rotateY(R_y);//-PIE);
  //println("R_y : " + R_y);
  loadPixels();
  video.loadPixels();
  for (int i = 0; i < width/steps; i++) {
    for (int j = 0; j < height/steps; j++) {
      pushMatrix();
      translate(-width/2, -height/2);  

      color c = frames[currentFrame].get(i*steps, j*steps);

      float z = brightness(c);
      fill(c);
      noStroke();
      translate(i*steps, j*steps, z/2 );
      box(steps-2, steps-2, steps - (z*2));
      popMatrix();
    }
  }
  //saveFrame("capturedFrame/reflexion-test-#########.png");
  updatePixels();
  wait = 7500;

}

void displayQuotes(){
  background(0);
   
  String item = quotes.get(a);
  fill(255);
  textFont(console);
  rotateY(PI);
  text(item, -width/10, -height/3 , width/1.33, height/1.33);
  wait = item.length()*100 ;
}

void displayVariable(){
  background(0);
  fill(255);
  textFont(console);
  rotateY(PI);
  translate(0, 0, -R_y *850);
  text("Time = " + time +" | random = "+ randomCount + " | R = "+ R_y + " | STR.length = " + a, -width/10, -height/7 , width/1.33, height/1.33);
  wait = 1000;
  
  
}
