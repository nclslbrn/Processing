PImage polarInterpolation(PImage input, float factor) {
  PImage output = input;
  color black = color(0);
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