int t;
float[] x, y, z, xPrev, yPrev, zPrev;
int radius = 200;
void setup() {
 size(600, 600, P3D);
}

void draw() {
 background(255);
 pushMatrix();
 translate(300, 300);
 rotateX(HALF_PI * 1.5);
 rotateZ(radians(t));
 
 //rotate mobius strip
 t = (t+1) % 360;
 
 //run through 360 degrees
 for(int u=0; u<361; u++) {
   
   //uu is radian translation of degrees
   float uu = radians(u);
   
   //arrays to store 5 points per perpendicular line on strip  
   x = new float[5];
   y = new float[5];
   z = new float[5];
   int index = 0;
   for (float v=-1; v<=1; v+=0.5) {
     //calculate coordinates, following parametrization (from wikipedia)
     float xCoord = radius*(1+(v/2)*cos(uu/2))*cos(uu);
     float yCoord = radius*(1+(v/2)*cos(uu/2))*sin(uu);
     float zCoord = radius*(v/2)*sin(uu/2);
     x[index] = xCoord;
     y[index] = yCoord;
     z[index] = zCoord;
     index++;
   }
   
   //if there is more than 1 point start drawing
   if(u>0) {
     for(int i=0; i<5; i++) {
       line(x[i], y[i], z[i], xPrev[i], yPrev[i], zPrev[i]);
       if(u%10 == 0 && i>0 ) {
         line(x[i-1], y[i-1], z[i-1], x[i], y[i], z[i]);
       }
     }
   }

   xPrev = x;
   yPrev = y;
   zPrev = z;
 }
 popMatrix();

}
