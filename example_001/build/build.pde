/**
 * Processing to 360 video
 * 
 * This sketch renders a cubemap to an equirectangular image that can be captured to create 360 videos.
 *
 * example_001 - renders a single static image
 * 
 * The code is a modification of the DomeProjection Processing example sketch, and an equirectangular GLSL shader by BeRo, on ShaderToy: 
 * https://www.shadertoy.com/view/XsBSDR#
 * https://www.shadertoy.com/user/BeRo
 */
 
import java.nio.IntBuffer;

PShader cubemapShader;
PShape myRect;

IntBuffer fbo;
IntBuffer rbo;
IntBuffer envMapTextureID;

int envMapSize = 1024;

//set record to true if you want to save frames to make a video
boolean record = false;

void setup() {
  //we'll be using the saved frames to create a 2048 x 1024 video, 
  size(2048, 1024, P3D);

  //for testing, you might want to work at a smaller resolution, but for export, the above is preferred
  //size(1024, 512, P3D);

  smooth();
  background(0);

  //For now, if you're on Retina screens, you have to suffer a little. 
  //Turning the pixelDensity on, stuff gets weird. It's best you leave it off.
  //pixelDensity(2);

  initCubeMap();
}

/*
  It's best to leave draw() alone and do all your updates and drawing in the methods at the bottom of this file
  - animationPreUpdate()
  - animationPostUpdate()
  - drawScene()
*/
void draw() {
  background(0);
  strokeWeight(0);
  noStroke();

  //upate pre render call
  animationPreUpdate();

  drawCubeMap();

  //upate post render call
  animationPostUpdate();

  //record frame
  if (record == true) {
    saveFrame("frames/frame-####.png");
  }

  surface.setTitle("FPS: " + (int) frameRate);
}



/*
  Put any input processing or pre render updates here
*/
void animationPreUpdate() {
}


/*
  Put any post render updates here
*/
void animationPostUpdate() {
}


/*
  Put your shapes/objects and lights here to be drawn to the screen
*/
void drawScene() {  
  background(0);
  lights();
  
  //front
  pushMatrix();
    translate(width/2, height/2, 250);
    fill(255, 0, 0);
    box(75);
  popMatrix();

  //right
  pushMatrix();
    translate(width/2 + 250, height/2, 0);
    fill(0, 255, 0);
    box(75);
  popMatrix();

  //back
  pushMatrix();
    translate(width/2, height/2, -250);
    fill(0, 0, 255);
    box(75);
  popMatrix();

  //left
  pushMatrix();
    translate(width/2 - 250, height/2, 0);
    fill(255, 255, 0);
    box(75);
  popMatrix();

  //top
  pushMatrix();
    translate(width/2, height/2 - 250, 0);
    fill(0, 255, 255);
    box(75);
  popMatrix();

  //bottom
  pushMatrix();
    translate(width/2, height/2 + 250, 0);
    fill(255, 0, 255);
    box(75);
  popMatrix();
}
