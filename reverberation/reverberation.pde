import ddf.minim.*;
import ddf.minim.analysis.*;
AudioRecorder recorder;

Minim minim;
AudioInput in;
AudioPlayer player;

StringList sample;
int r;

// audio data
AudioInput audiostream;
FFT fft;
int specsize=0;
int strid;
float ostrid;

//astriday data
int ax=128;
int az=64;
float astriday[][] = new float[ax][az];

//scene
float fov = radians(70.);
float cx = 200.;
float target= cx;

int om=1;
int dom=1;


float R_y = 0;
int S_y = 1;

String ext = ".mp3";

void setup() {
  //size ( 1280 , 800, P3D);
   size ( displayWidth, displayHeight, P3D);
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2, height/2.0, 0, 0, 1, 0);
  minim = new Minim(this);
  audiostream = minim.getLineIn();
  fft = new FFT(audiostream.bufferSize(),audiostream.sampleRate());
  float cameraZ = (height/2.0) / tan(PI * fov / 360.0);
  perspective(fov, (float)width/(float)height, 0.01, cameraZ*10000.0);
  specsize = fft.specSize();
  strid = (int)((float)specsize / ax);
  ostrid=1.0f/strid;
  frameRate(25);
  noCursor();
  
  textFont(createFont("Arial", 12));
  
  sample = new StringList();
  sample.append("break");                      //1
  sample.append("feynmann-in-the-begining");   //2
  sample.append("foule");                      //3
  sample.append("hawking");                    //4
  sample.append("master-piece-frieder-nake");  //5
  sample.append("morellet-bataille-naval");    //6
  sample.append("hoover");                     //7
  sample.append("basson");                     //8
  sample.append("brass-and-piano");            //9
  sample.append("casey-reas");                 //10
  sample.append("feynman-real-world");         //11
  sample.append("richard-feynman");            //12
  sample.append("extreme-riff");               //13
  sample.append("orchestral");                 //14
  sample.append("orchestral-rise");            //15
  sample.append("string-and-choir");           //16
  sample.append("string-and-trumpet");         //17
  

  choisis();
}

void draw() {
  fft.forward(audiostream.mix);

  background(0);
  //camera(cx,-25.,700.,  cx, 0., -100.,0.,1.,0.);
  //camera(cx,-25.,700.,  0., 0., -100.,0.,1.,0.);
  translate(width/2, height/4, 20);
  rotateX(-QUARTER_PI/2);
  
  float sum=0.;
  int index=0;
  
   if ( S_y == 1) {
    R_y += 0.0001;
  }
  else if (S_y == -1) {
    R_y -= 0.0001;
  }
  if ((R_y > QUARTER_PI/2 ) || (R_y < -QUARTER_PI/2)) {
    S_y =- S_y;
  }
  rotateY(R_y);
  
  if(om>0) {
  //copy to firstline
  for(int i=0; i < specsize;i++) {    
    sum+=(fft.getBand(i)*50);
    if(i%strid==0&&i!=0) {
      astriday[index++][0]= sum * ostrid;
      sum=0;
    }
  }

  //fifo ter
    for (int j =az-1; j>0;j--)
      for (int i =0; i<ax;i++)
        astriday[i][j] = astriday[i][j-1]; 
        
  }
  
  
  stroke(0,0,255,150);
    //draw

  if(dom==0) {
    for (int j =0; j<az;j++) {
      beginShape(LINES);

      for (int i =0; i<ax-1;i++) {
        vertex((i-ax/2)*3, -(astriday[i][j]), j*10);
        vertex((i-ax/2)*3, -(astriday[i+1][j]), j*10);
      }
      endShape();
    }
  } else {
    
    for (int j =0; j<az;j++) {
      noFill();  beginShape();
      for (int i =0; i<ax-1;i++) {
        stroke(i * 3, j * 4, 255, 150);   
        vertex((i-ax/2)*3, -(astriday[i][j]), j*10);
        vertex((i-ax/2)*3, -(astriday[i+1][j]), j*10);
      }
      endShape();
    }
    
  }

  if (player.isPlaying() )
  {
    //GREAT
  }else{
    choisis();
  }
    
}
void choisis(){

  r = int(random(0, 17));
  samplePlay(); 

}

void samplePlay(){
 String rSample = 'sample/' + sample.get(r) + ext;
 if( rSample == null){
   println( " null = " + r);
   choisis();
 }else if(rSample != null){
 player = minim.loadFile(rSample);
 player.play();
  println(" [ "+r+ " ] - "+ sample.get(r) +" -");
  
// for( int i = 0; i < player.position(); i++){
  
 //  if( i >= player.length()-0.001){
 //   println("sound will change");
 //   choisis(); 
    
  // }
 }
   
}
void stop()
{
  // always close Minim audio classes when you are done with them
  player.close();
  // always stop Minim before exiting.
  minim.stop(); 
  super.stop();
}

