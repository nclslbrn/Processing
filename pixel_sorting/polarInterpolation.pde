PImage polarInterpolation(PImage input, float factor) {
  PImage output = input;

  for (int y=0; y<output.height; y++) {
    for (int x=0; x<output.width; x++) {
      int my = y-output.height/2;
      int mx = x-output.width/2;
      float angle = atan2(my, mx) - HALF_PI ;
      float radius = sqrt(mx*mx+my*my) / factor;
      float ix = map(angle,-PI,PI,input.width,0);
      float iy = map(radius,0,height,0,input.height);
      int inputIndex = int(ix) + int(iy) * input.width;
      int outputIndex = x + y * output.width;
      if (inputIndex <= input.pixels.length-1) {
        output.pixels[outputIndex] = input.pixels[inputIndex];
      }
    }
  }
  return output;
}

PImage spiralInterpolation(PImage input) {
  PImage output = input;
  int x=0, y=0, dx = 0, dy = -1;
  int t = Math.max(input.width, input.height);
  int maxI = t*t;

  for (int i=0; i < maxI-1; i++){
    if (
      (-input.width/2 <= x) && 
      (x <= input.width/2) && 
      (-input.height/2 <= y) && 
      (y <= input.height/2)
    ) {
        int outputIndex = (x+(input.width-1)/2) + (y+(input.height-1)/2) * output.width;
        output.pixels[outputIndex] = input.pixels[i];
    }

    if( (x == y) || ((x < 0) && (x == -y)) || ((x > 0) && (x == 1-y))) {
        t=dx; dx=-dy; dy=t;
    }   
    x+=dx; y+=dy;
  }
  return output;
}
