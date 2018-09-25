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

uniform vec2 clip_nf = vec2(1.0, 6000.0);

void main(){
  ivec2 posi = ivec2(gl_FragCoord.xy);
  
  vec4 frag_geom  = texelFetch(tex_geom, posi, 0);
  vec4 focus_geom = texture(tex_geom, focus_pos);
  
  float frag_z  = frag_geom.w  / clip_nf.y;
  float focus_z = focus_geom.w / clip_nf.y;
  
  float z_diff = frag_z - focus_z;
  z_diff = abs(z_diff);
  z_diff -= focus_z * 0.1;
  z_diff /= focus_z;
  z_diff = clamp(z_diff, 0.0, 1.0);


  vec4  sum_color = texture(tex_src, gl_FragCoord.xy / wh);
  float sum_weights = 1.0;
  
  int radius = int(z_diff * mult_blur);
  if(radius > 0){
  
    sum_color = vec4(0.0);
    sum_weights = 0.0; 

    float sample_rad = float(radius);
    int count = 1 + radius * 5; 
    for(int i = 0; i < count; i++){
      float sample_idx  = float(i);
      float sample_idxn = sample_idx / float(count-1);
     
      // spawn fibonacci pattern for uniform distribution over a radial area
      float radn = sqrt(sample_idxn * 0.5);
      float off_rad = sample_rad * radn;
      float off_ang = sample_idx * GOLDEN_ANGLE_R;
      vec2  off_pos = vec2(cos(off_ang), sin(off_ang)) * off_rad;
      
      vec2  sample_fpos = (gl_FragCoord.xy + off_pos) / wh;
      vec4  sample_geom = texture(tex_geom, sample_fpos);
      
      float sample_z = sample_geom.w  / clip_nf.y;
      vec4  sample_col = texture(tex_src, sample_fpos);
      //if(sample_z <= frag_z)
      {
        float z_diff_sample_frag = sample_z - frag_z;
        z_diff_sample_frag = abs(z_diff_sample_frag);
        z_diff_sample_frag = min(z_diff_sample_frag, z_diff);
        z_diff_sample_frag = 1.0 - z_diff_sample_frag;
        
        float z_diff_sample_focus = sample_z - focus_z;
        z_diff_sample_focus = abs(z_diff_sample_focus);
                
        float sample_weight = (z_diff) * z_diff_sample_frag * z_diff_sample_focus * (1.0 - radn*radn);

        sum_color   += sample_weight * sample_col;
        sum_weights += sample_weight;
      }
    }
  }
  
  out_frag = sum_color / sum_weights;
  
  // out_frag = vec4(1.0-z_diff,0,0,1);
}


