/**
 * 
 * PixelFlow | Copyright (C) 2017 Thomas Diewald - http://thomasdiewald.com
 * 
 * A Processing/Java library for high performance GPU-Computing (GLSL).
 * MIT License: https://opensource.org/licenses/MIT
 * 
 */


#version 150

#define GOLDEN_ANGLE_R 2.3999631 
precision highp float;
precision highp int;

out vec4 out_frag;

uniform sampler2D	tex_sat;
uniform sampler2D	tex_geom;
uniform sampler2D	tex_src;

uniform vec2 wh;

uniform float focus = 0.5;
uniform vec2 focus_pos = vec2(0.5);
uniform float mult_blur = 10.0;

void main(){
  ivec2 posi = ivec2(gl_FragCoord.xy);
  
  vec4 geom = texelFetch(tex_geom, posi, 0);
  float eye_z = geom.w;

  float autofocus =  texture(tex_geom, focus_pos).w;
  float depth_norm = eye_z     / 6000.0;
  float focus_norm = autofocus / 6000.0;
  float dof = depth_norm - focus_norm;

  dof = abs(dof);
  //dof = pow(dof, 0.5);
  dof -= focus_norm * 0.1;
  
  dof /= focus_norm;
  //dof = dof*dof;
  dof = clamp(dof, 0.0, 1.0);
 
  int radius = int(dof * mult_blur);
  
  vec4 sum_color = texture(tex_src, gl_FragCoord.xy / wh);

  if(radius == 0){
    out_frag = sum_color;
  } else {
  
    /*
    ivec4 bb  = ivec4(posi - radius - 1, posi + radius);
    bb = clamp(bb, ivec4(0), ivec4(wh.xyxy - 1));
    float area = float((bb.z-bb.x)*(bb.w-bb.y)); //   |      |
    vec4 A = texelFetch(tex_sat, bb.xy, 0);      // --A------B
    vec4 B = texelFetch(tex_sat, bb.zy, 0);      //   |######|
    vec4 C = texelFetch(tex_sat, bb.zw, 0);      //   |######|
    vec4 D = texelFetch(tex_sat, bb.xw, 0);      // --D------C
                                        
    out_frag = (A+C-B-D) / area;
    */
    
    //vec4  sum_color = vec4(0.0);
    float sum_weights = 1.0;
    float sample_rad = float(radius);
    int count = 1 + radius * 5; 
    for(int i = 0; i < count; i++){
      float sample_idx  = float(i);
      float sample_idxn = sample_idx / float(count);
     
      // spawn fibonacci pattern for uniform distribution over a radial area
      float radn = sqrt(sample_idxn * 0.5);
      float off_rad = sample_rad * radn;
      float off_ang = sample_idx * GOLDEN_ANGLE_R;
      vec2  off_pos = vec2(cos(off_ang), sin(off_ang)) * off_rad;
      
      vec2 fpos = (gl_FragCoord.xy + off_pos) / wh;
      
      //float frag_depth = texture(tex_geom, fpos).w;
      //if(frag_depth > autofocus)
      {
     
        vec4 rgba = texture(tex_src, fpos);
        //float weight = abs(autofocus - frag_depth) / 1000.0;
        float weight = 1.0;//1.0 - radn;
        sum_color += rgba * weight;
        sum_weights += weight;
      }
    }
    out_frag = sum_color / sum_weights;
  }
  
  //out_frag = vec4(radius * 0.01,0,0,1);
}


