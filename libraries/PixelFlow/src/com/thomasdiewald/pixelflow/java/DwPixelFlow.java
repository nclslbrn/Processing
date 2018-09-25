/**
 * 
 * PixelFlow | Copyright (C) 2017 Thomas Diewald - www.thomasdiewald.com
 * 
 * https://github.com/diwi/PixelFlow.git
 * 
 * A Processing/Java library for high performance GPU-Computing.
 * MIT License: https://opensource.org/licenses/MIT
 * 
 */



package com.thomasdiewald.pixelflow.java;


import java.util.HashMap;
import java.util.Stack;

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL2ES2;
import com.jogamp.opengl.GLContext;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLFrameBuffer;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLRenderSettingsCallback;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLSLProgram;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLTexture;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLTexture3D;
import com.thomasdiewald.pixelflow.java.utils.DwUtils;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLError;

import processing.core.PApplet;
import processing.opengl.FrameBuffer;
import processing.opengl.PGraphicsOpenGL;
import processing.opengl.PJOGL;


public class DwPixelFlow{
                                     
  static public class PixelFlowInfo{
    
    static public final String version = "1.3.0";
    static public final String name    = "PixelFlow";
    static public final String author  = "Thomas Diewald";
    static public final String web     = "www.thomasdiewald.com";
    static public final String git     = "github.com/diwi/PixelFlow.git";
    
    public String toString(){
      return "[-] "+name+" v"+version +" - "+web+"";
    }
  }

  static public final PixelFlowInfo INFO;
  
  static {
    INFO = new PixelFlowInfo();
  }
  
  
  public static final String SHADER_DIR = "/com/thomasdiewald/pixelflow/glsl/";
//  public static final String SHADER_DIR = "D:/data/__Eclipse/workspace/WORKSPACE_FLUID/PixelFlow/src/com/thomasdiewald/pixelflow/glsl/";
  
  public PApplet papplet;
  public PJOGL   pjogl;
  public GL2ES2  gl;
  
  public final DwUtils utils = new DwUtils(this);
  
  private int scope_depth = 0;
  
  public final DwGLFrameBuffer framebuffer = new DwGLFrameBuffer();
  
  
  private HashMap<String, DwGLSLProgram> shader_cache = new HashMap<String, DwGLSLProgram>();
  
  
  public DwPixelFlow(PApplet papplet){
    this.papplet = papplet;
    this.papplet.registerMethod("dispose", this);
    
    begin(); 
    pjogl.enableFBOLayer();
    end();
  }
  

  public void dispose(){
    release();
  }
  
  
  public void release(){

    // release shader
//    int count = 0;
    for(String key : shader_cache.keySet()){
      DwGLSLProgram shader = shader_cache.get(key);
      shader.release();
//      System.out.printf("released Shader: [%2d] %s\n", count, key);
//      count++;
    }
    shader_cache.clear();
        
    framebuffer.release();

  }
  
  
  
//  GLSL  |  OpenGL 
// -------|---------  
//  1.10  |   2.0
//  1.20  |   2.1
//  1.30  |   3.0
//  1.40  |   3.1
//  1.50  |   3.2
//  3.30  |   3.3
//  4.00  |   4.0
//  4.10  |   4.1
//  4.20  |   4.2
//  4.30  |   4.3
//  4.40  |   4.4


  // https://github.com/processing/processing/wiki/Advanced-OpenGL
  // PJOGL.profile = 3;

  public GL2ES2 begin(){
//    System.out.printf("%"+(scope_depth*2+1)+"s GLScope.begin %d\n", " ", scope_depth);
    if(scope_depth == 0){
      pjogl = (PJOGL) papplet.beginPGL(); 
      gl = pjogl.gl.getGL2ES2();
      framebuffer.allocate(gl);
    }
    scope_depth++;
    return gl;
  }
  
  public void end(){
    endDraw(); // just in case, a framebuffer is still bound

    scope_depth--;
//    System.out.printf("%"+(scope_depth*2+1)+"s GLScope.end   %d\n", " ", scope_depth);
    if(scope_depth == 0){
      papplet.endPGL();
    }
    scope_depth = Math.max(scope_depth, 0);
  }
  
  public void end(String error_msg){
    errorCheck(error_msg);
    end();
  }
  

  
  
  
  
  
  public boolean ACTIVE_FRAMEBUFFER = false;
  

  public void beginDraw(DwGLTexture ... dst){
//    if(ACTIVE_FRAMEBUFFER) return;
    ACTIVE_FRAMEBUFFER = true;
    framebuffer.bind(dst);
    defaultRenderSettings(0, 0, dst[0].w, dst[0].h);
  }
  
  
  public void beginDraw(DwGLTexture3D[] dst, int[] layer){
  //  if(ACTIVE_FRAMEBUFFER) return;
    ACTIVE_FRAMEBUFFER = true;
    framebuffer.bind(dst, layer);
    defaultRenderSettings(0, 0, dst[0].w, dst[0].h);
  }
  
  public void beginDraw(DwGLTexture3D dst, int ... layer){
  //  if(ACTIVE_FRAMEBUFFER) return;
    ACTIVE_FRAMEBUFFER = true;
    framebuffer.bind(dst, layer);
    defaultRenderSettings(0, 0, dst.w, dst.h);
  }

  public void beginDraw(DwGLTexture3D dst, int layer){
  //  if(ACTIVE_FRAMEBUFFER) return;
    ACTIVE_FRAMEBUFFER = true;
    framebuffer.bind(new DwGLTexture3D[]{dst}, new int[]{layer});
    defaultRenderSettings(0, 0, dst.w, dst.h);
  }
  

  
  PGraphicsOpenGL pgl_dst = null;
  public void beginDraw(PGraphicsOpenGL dst){
    beginDraw(dst, dst.smooth != 0);
  }
  
  public void beginDraw(PGraphicsOpenGL dst, boolean multisample){
    // in case dst is the primary papplet graphics buffer, dont mess with the fbo
    if(dst == dst.parent.g){
//      defaultRenderSettings(0, 0, dst.width, dst.height); // TODO, need this?
      return;
    }
    
    // 1) first try, multisample could be true, else try without multisample
    FrameBuffer fbo = dst.getFrameBuffer(multisample);
    if(fbo == null){
      fbo = dst.getFrameBuffer(false);
    }
    
    // 2) try again, but explicitly load the texture now
    if(fbo == null){
      end();
      dst.loadTexture();
      begin();

      fbo = dst.getFrameBuffer(multisample);
      if(fbo == null){
        fbo = dst.getFrameBuffer(false);
      }
    }
    
    if(fbo == null){
      System.out.println("DwPixelFlow.beginDraw(PGraphicsOpenGL) ERROR: Texture not initialized");
      return;
    }
    
    multisample = (fbo == dst.getFrameBuffer(true));
  
    fbo.bind();
    defaultRenderSettings(0, 0, fbo.width, fbo.height);
    if(multisample){
      gl.glEnable(GL.GL_MULTISAMPLE);
    }
    pgl_dst = dst;
    ACTIVE_FRAMEBUFFER = true;
  }
  
  public void endDraw(){
    if(ACTIVE_FRAMEBUFFER){
      if(framebuffer != null && framebuffer.isActive()){
        framebuffer.unbind();
      } else {
        gl.glBindFramebuffer(GL2ES2.GL_FRAMEBUFFER, 0);
      }
   
      if(pgl_dst != null){
        updateFBO(pgl_dst);
        pgl_dst = null;
      }
    }
    ACTIVE_FRAMEBUFFER = false;
  }
  
  public void endDraw(String error_msg){
    endDraw();
    errorCheck(error_msg);
  }
  
  // apparently this needs to be done. 
  // instead, loadTexture() needs to be called, ...i guess
  private void updateFBO(PGraphicsOpenGL pg){
    FrameBuffer mfb = pg.getFrameBuffer(true);
    FrameBuffer ofb = pg.getFrameBuffer(false);
    if (ofb != null && mfb != null) {
      mfb.copyColor(ofb);
    }
    // errorCheck("DwPixelFlow.updateFBO(PGraphicsOpenGL pg)");
  }
  
  
 
  public void defaultRenderSettings(int x, int y, int w, int h){
    rendersettings_default.set(this, 0, 0, w, h);
    if(!rendersettings_user.isEmpty()){
      rendersettings_user.peek().set(this, 0, 0, w, h);
    }
  }
  
  private static class DefaultRenderSettings implements DwGLRenderSettingsCallback{
    @Override
    public void set(DwPixelFlow context, int x, int y, int w, int h) {
      GL2ES2 gl = context.gl;
      gl.glViewport(x, y, w, h);
      gl.glColorMask(true, true, true, true);
      gl.glDepthMask(false);
      gl.glDisable(GL.GL_DEPTH_TEST);
      gl.glDisable(GL.GL_SCISSOR_TEST);
      gl.glDisable(GL.GL_STENCIL_TEST);
      gl.glDisable(GL.GL_BLEND);
      gl.glDisable(GL.GL_MULTISAMPLE);
    }
  }
  
  final private DwGLRenderSettingsCallback rendersettings_default = new DefaultRenderSettings();

  Stack<DwGLRenderSettingsCallback> rendersettings_user = new Stack<DwGLRenderSettingsCallback>();
  
  public void pushRenderSettings(DwGLRenderSettingsCallback rendersettings){
    rendersettings_user.push(rendersettings);
  }
  public void popRenderSettings(){
    rendersettings_user.pop();
  }
  
  
  
  
  //////////////////////////////////////////////////////////////////////////////
  //
  // SHADER FACTORY
  //
  //////////////////////////////////////////////////////////////////////////////
  
  public DwGLSLProgram createShader(String path_fragmentshader){
    return createShader((Object)null, path_fragmentshader);
  }
  
  public DwGLSLProgram createShader(Object o, String path_fragmentshader){
    return createShader(o, null, path_fragmentshader);
  }
  
  public DwGLSLProgram createShader(String path_vertexshader, String path_fragmentshader){
    return createShader((Object) null, path_vertexshader, path_fragmentshader);
  }
  
  public DwGLSLProgram createShader(Object o, String path_vertexshader, String path_fragmentshader){

    // TODO: this might be a source for problems. 
    // given paths, when relative, could cause collisions.
    // to avoid this, pass "this" as the first argument
    String key = "";
//    if(o != null) key += "["+o.getClass().getCanonicalName()+"]";
    if(o != null) key += "["+o.hashCode()+"]";
    if(path_vertexshader != null) key += ""+path_vertexshader+"[]";
    key += ""+path_fragmentshader+"";
    
     
    DwGLSLProgram shader = shader_cache.get(key);
    if(shader == null){
      shader = new DwGLSLProgram(this, path_vertexshader, path_fragmentshader);
      shader_cache.put(key, shader);
    } 
    return shader;
  }
   

  
  
  
  

  // TODO: DwGLTextureUtils
  public void getGLTextureHandle(PGraphicsOpenGL pg, int[] tex_handle){
    int fbo_handle = pg.getFrameBuffer().glFbo;
    int target     = GL2ES2.GL_FRAMEBUFFER;
    int attachment = GL2ES2.GL_COLOR_ATTACHMENT0;
    int[] params   = new int[1]; 
    gl.glBindFramebuffer(target, fbo_handle);
    gl.glGetFramebufferAttachmentParameteriv(target, attachment, GL2ES2.GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE, params, 0);
    if( params[0] == GL2ES2.GL_TEXTURE){
      gl.glGetFramebufferAttachmentParameteriv(target, attachment, GL2ES2.GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME, params, 0);
      tex_handle[0] = params[0];
    } else {
      tex_handle[0] = -1;
    }
    gl.glBindFramebuffer(target, 0);
  }
  
  
  
  
  
  public void errorCheck(String msg){
    DwGLError.debug(gl, msg);
  }
  
  
  
  
  
  
  
  
  
  
  
  
  //////////////////////////////////////////////////////////////////////////////
  //
  // GL/GLSL Info
  //
  //////////////////////////////////////////////////////////////////////////////

  
  
  public void printGL(){
    GLContext glcontext = gl.getContext();
    
//    String opengl_version    = gl.glGetString(GL2ES2.GL_VERSION).trim();
//    String opengl_vendor     = gl.glGetString(GL2ES2.GL_VENDOR).trim();
    String opengl_renderer   = gl.glGetString(GL2ES2.GL_RENDERER).trim();
//    String opengl_extensions = gl.glGetString(GL2ES2.GL_EXTENSIONS).trim();
//    String glsl_version      = gl.glGetString(GL2ES2.GL_SHADING_LANGUAGE_VERSION).trim();
    
    String GLSLVersionString = glcontext.getGLSLVersionString().trim();
    String GLSLVersionNumber = glcontext.getGLSLVersionNumber()+"";
    String GLVersion         = glcontext.getGLVersion().trim();
//    System.out.println("    OPENGL_VENDOR:         "+opengl_vendor);
//    System.out.println("    OPENGL_RENDERER:       "+opengl_renderer);
//    System.out.println("    OPENGL_VERSION:        "+opengl_version);
//    System.out.println("    OPENGL_EXTENSIONS:     "+opengl_extensions);
//    System.out.println("    GLSL_VERSION:          "+glsl_version);
//    System.out.println("    GLSLVersionString:     "+ GLSLVersionString);
//    System.out.println("    GLSLVersionNumber:     "+ GLSLVersionNumber);
//    System.out.println("    GLVersion:             "+ glcontext.getGLVersion().trim());
//    System.out.println("    GLVendorVersionNumber: "+ glcontext.getGLVendorVersionNumber());
//    System.out.println("    GLVersionNumber:       "+ glcontext.getGLVersionNumber());
    
    System.out.println();
    System.out.println("[-] DEVICE ... " + opengl_renderer);
    System.out.println("[-] GLSL ..... " + GLSLVersionString + " / "+ GLSLVersionNumber);
    System.out.println("[-] GL ....... " + GLVersion);
    System.out.println();
  }

  
  
  public void printGL_Extensions(){
    String gl_extensions = gl.glGetString(GL2ES2.GL_EXTENSIONS).trim();
    String[] list = gl_extensions.split(" ");
    
    System.out.println();
    System.out.printf("[-] %d extensions\n", list.length);
    for(int i = 0; i < list.length; i++){
      System.out.printf("  [-] %d - %s\n", i, list[i].trim());
    }
    System.out.println();
  }
  
  
  public void print(){
    System.out.println(INFO);
  }
  
  
  // https://www.khronos.org/registry/OpenGL/extensions/NVX/NVX_gpu_memory_info.txt
  static public final String  GL_NVX_gpu_memory_info                       = "GL_NVX_gpu_memory_info";
  static public final int     GPU_MEMORY_INFO_DEDICATED_VIDMEM_NVX         = 0x9047;
  static public final int     GPU_MEMORY_INFO_TOTAL_AVAILABLE_MEMORY_NVX   = 0x9048;
  static public final int     GPU_MEMORY_INFO_CURRENT_AVAILABLE_VIDMEM_NVX = 0x9049;
  static public final int     GPU_MEMORY_INFO_EVICTION_COUNT_NVX           = 0x904A;
  static public final int     GPU_MEMORY_INFO_EVICTED_MEMORY_NVX           = 0x904B;
  
  // https://www.khronos.org/registry/OpenGL/extensions/ATI/ATI_meminfo.txt
  //    [0] - total memory free in the pool
  //    [1] - largest available free block in the pool
  //    [2] - total auxiliary memory free
  //    [3] - largest auxiliary free block
  static public final String  ATI_meminfo                  = "ATI_meminfo";
  static public final int     VBO_FREE_MEMORY_ATI          = 0x87FB;
  static public final int     TEXTURE_FREE_MEMORY_ATI      = 0x87FC;
  static public final int     RENDERBUFFER_FREE_MEMORY_ATI = 0x87FD;
  
  
  static public boolean       VAL_GL_NVX_gpu_memory_info                       = false;
  static public int[]         VAL_GPU_MEMORY_INFO_DEDICATED_VIDMEM_NVX         = {0};
  static public int[]         VAL_GPU_MEMORY_INFO_TOTAL_AVAILABLE_MEMORY_NVX   = {0};
  static public int[]         VAL_GPU_MEMORY_INFO_CURRENT_AVAILABLE_VIDMEM_NVX = {0};
  static public int[]         VAL_GPU_MEMORY_INFO_EVICTION_COUNT_NVX           = {0};
  static public int[]         VAL_GPU_MEMORY_INFO_EVICTED_MEMORY_NVX           = {0};
  
  static public boolean       VAL_ATI_meminfo                  = false;
  static public int[]         VAL_VBO_FREE_MEMORY_ATI          = {0,0,0,0};
  static public int[]         VAL_TEXTURE_FREE_MEMORY_ATI      = {0,0,0,0};
  static public int[]         VAL_RENDERBUFFER_FREE_MEMORY_ATI = {0,0,0,0};
  
  

  public void updateGL_MemoryInfo(){
    VAL_GL_NVX_gpu_memory_info = gl.isExtensionAvailable(GL_NVX_gpu_memory_info);
    if(VAL_GL_NVX_gpu_memory_info){
      gl.glGetIntegerv(GPU_MEMORY_INFO_DEDICATED_VIDMEM_NVX        , VAL_GPU_MEMORY_INFO_DEDICATED_VIDMEM_NVX        , 0);
      gl.glGetIntegerv(GPU_MEMORY_INFO_TOTAL_AVAILABLE_MEMORY_NVX  , VAL_GPU_MEMORY_INFO_TOTAL_AVAILABLE_MEMORY_NVX  , 0);
      gl.glGetIntegerv(GPU_MEMORY_INFO_CURRENT_AVAILABLE_VIDMEM_NVX, VAL_GPU_MEMORY_INFO_CURRENT_AVAILABLE_VIDMEM_NVX, 0);
      gl.glGetIntegerv(GPU_MEMORY_INFO_EVICTION_COUNT_NVX          , VAL_GPU_MEMORY_INFO_EVICTION_COUNT_NVX          , 0);
      gl.glGetIntegerv(GPU_MEMORY_INFO_EVICTED_MEMORY_NVX          , VAL_GPU_MEMORY_INFO_EVICTED_MEMORY_NVX          , 0);
    }
    
    VAL_ATI_meminfo = gl.isExtensionAvailable(ATI_meminfo);
    if(VAL_ATI_meminfo){
      gl.glGetIntegerv(VBO_FREE_MEMORY_ATI         , VAL_VBO_FREE_MEMORY_ATI         , 0);
      gl.glGetIntegerv(TEXTURE_FREE_MEMORY_ATI     , VAL_TEXTURE_FREE_MEMORY_ATI     , 0);
      gl.glGetIntegerv(RENDERBUFFER_FREE_MEMORY_ATI, VAL_RENDERBUFFER_FREE_MEMORY_ATI, 0);
    }
  }
  
  
  public void printGL_MemoryInfo(){
    
    updateGL_MemoryInfo();

    if(VAL_GL_NVX_gpu_memory_info)
    {
      System.out.printf("[-] %s\n", GL_NVX_gpu_memory_info);
      System.out.printf("  [-] GPU_MEMORY_INFO_DEDICATED_VIDMEM_NVX         (MB) = %d\n", (VAL_GPU_MEMORY_INFO_DEDICATED_VIDMEM_NVX        [0] >> 10));
      System.out.printf("  [-] GPU_MEMORY_INFO_TOTAL_AVAILABLE_MEMORY_NVX   (MB) = %d\n", (VAL_GPU_MEMORY_INFO_TOTAL_AVAILABLE_MEMORY_NVX  [0] >> 10));
      System.out.printf("  [-] GPU_MEMORY_INFO_CURRENT_AVAILABLE_VIDMEM_NVX (MB) = %d\n", (VAL_GPU_MEMORY_INFO_CURRENT_AVAILABLE_VIDMEM_NVX[0] >> 10));
      System.out.printf("  [-] GPU_MEMORY_INFO_EVICTION_COUNT_NVX                = %d\n", (VAL_GPU_MEMORY_INFO_EVICTION_COUNT_NVX          [0]      ));
      System.out.printf("  [-] GPU_MEMORY_INFO_EVICTED_MEMORY_NVX           (MB) = %d\n", (VAL_GPU_MEMORY_INFO_EVICTED_MEMORY_NVX          [0] >> 10));
      System.out.printf("\n");
    }
     
    if(VAL_ATI_meminfo)
    {
      System.out.printf("[-] %s\n", ATI_meminfo);
      System.out.printf("  [-] VBO_FREE_MEMORY_ATI          (MB) = %d\n", (VAL_VBO_FREE_MEMORY_ATI         [0] >> 10)
                                                                        , (VAL_VBO_FREE_MEMORY_ATI         [1] >> 10)
                                                                        , (VAL_VBO_FREE_MEMORY_ATI         [2] >> 10)
                                                                        , (VAL_VBO_FREE_MEMORY_ATI         [3] >> 10));
      System.out.printf("  [-] TEXTURE_FREE_MEMORY_ATI      (MB) = %d\n", (VAL_TEXTURE_FREE_MEMORY_ATI     [0] >> 10)
                                                                        , (VAL_TEXTURE_FREE_MEMORY_ATI     [1] >> 10)
                                                                        , (VAL_TEXTURE_FREE_MEMORY_ATI     [2] >> 10)
                                                                        , (VAL_TEXTURE_FREE_MEMORY_ATI     [3] >> 10));
      System.out.printf("  [-] RENDERBUFFER_FREE_MEMORY_ATI (MB) = %d\n", (VAL_RENDERBUFFER_FREE_MEMORY_ATI[0] >> 10)
                                                                        , (VAL_RENDERBUFFER_FREE_MEMORY_ATI[1] >> 10)
                                                                        , (VAL_RENDERBUFFER_FREE_MEMORY_ATI[2] >> 10)
                                                                        , (VAL_RENDERBUFFER_FREE_MEMORY_ATI[3] >> 10));
    }
  }
  
  


}
