/*
Chromatic Aberration by Stef Tervelde
Set blursize to control the size of the blur
Set wrap pixels to enable/disable pixel bleeding, if it is a really big problem, please render extra pixels on the sides
*/

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform int blurSize;
uniform int wrapPixels;   
float range(float x);

void main(void) {
  float totalSamples = 0.0;
  for(float i = 1.0; i<=float(blurSize); i++){
    totalSamples+= i;
  }
  float part = 1.0/totalSamples;


  vec4 red = vec4(0,0,0,0);
  for(int i = 0; i<=blurSize; i++){
    vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s * float(i),0);
    tc0.x = range(tc0.x);
    vec4 col = texture2D(texture, tc0);
    red += col*(part*float(blurSize-i));
  }
  vec4 blue = vec4(0,0,0,0);
  for(int i = 0; i<=blurSize; i++){
    vec2 tc0 = vertTexCoord.st + vec2(texOffset.s * float(i),0);
    tc0.x = range(tc0.x);
    vec4 col = texture2D(texture, tc0);
    blue += col*(part*float(blurSize-i));
  }
  vec4 green = vec4(0,0,0,0);
  for(int i = 0; i<=blurSize; i++){
    int index =0;
    if(int(mod(float(i),2.0)) == 0){
      index = i/2;
    }else{
      index = -i/2+1;
    }
    vec2 tc0 = vertTexCoord.st + vec2(texOffset.s *float(index),0);
    tc0.x = range(tc0.x);
    vec4 col = texture2D(texture, tc0);
    green += col*part*float(blurSize-i);
  }
  gl_FragColor = vec4(red.r,green.g,blue.b,1);
}

float range(float x){
  if(wrapPixels == 0){
    return fract(x);
  }else{
    return x;
  }
}
