import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

int metronome;
Minim minim;
AudioSample kick;

// graphic
int pasBase, pas, y1, y2, x;
// sound
int pasT, bd;

int prec;

void setup() {
  size (840,840);
  minim = new Minim(this);
  kick = minim.loadSample("BD.mp3", 2048);
  
  pasBase = 3; //constant
  
  pas = pasBase;
  x = pasBase;
  y1 = 0;
  y2 = pasBase;
  
  pasT = 100;//constant
  
  bd = pasT; 
  
  prec = 1;
  background(255);
}

void draw() {

  
  if(prec == 1) {
    kick.trigger();
  }
  
  if(prec != millis()/bd%2 && prec == 0) {

    line(x,y1,x,y2);
    x += pas;
    
    if(x > width) {

      pas += pasBase;
      y1 = y2;
      y2 += pas;
      x = pas;
      bd += pasT;

    }
    
  }
  
  prec = millis()/bd%2;
 
  if( y1 > height) {
    saveFrame("records/frame-###.jpg");

    background(255);
    pas = pasBase;
    x = pasBase;
    y1 = 0;
    y2 = pasBase;
    bd = 500;
  }
 
}

void stop() {
  kick.close();
  minim.stop();
  
  super.stop();
}
