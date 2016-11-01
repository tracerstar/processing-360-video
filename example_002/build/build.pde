/**
 * Processing to 360 video
 * 
 * This sketch renders a cubemap to an equirectangular image that can be captured to create 360 videos.
 *
 * example_002 - renders an animated sequence of frames to use for 360 video
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

//some variables to handle the animations
PVector[] rotations = new PVector[6];
PVector[] oscillations = new PVector[6];

void setup() {
  //we'll be using the saved frames to create a 2048 x 1024 video, 
  //2050 wide is necessary to clip the black edges off in the video editor.
  size(2048, 1024, P3D);

  //for testing, you might want to work at a smaller resolution, but for export, the above is preferred
  //size(1024, 512, P3D);

  smooth();
  background(0);

  //For now, if you're on Retina screens, you have to suffer a little. 
  //Turning the pixelDensity on, stuff gets weird. It's best you leave it off.
  //pixelDensity(2);

  initCubeMap();

  //set up animation vars
  for (int i = 0; i < 6; i++) {
    rotations[i] = new PVector(radians(random(0, 360)), radians(random(0, 360)), radians(random(0, 360)));
    oscillations[i] = new PVector(0,0,0);
  }
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

  //record 900 frames for a 30 second 30 fps video
  if (record == true && frameCount < 901) {
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
  for (int i = 0; i < 6; i++) {
    rotations[i].x += radians(0.5);
    rotations[i].y += radians(1);
    rotations[i].z += radians(2);

    //because we're rendering each frame for video, we will use frameCount as 1 frame = 1 degree
    float r = radians(frameCount);

    oscillations[i].x = sin(r * 0.7) * 150;
    oscillations[i].y = sin(r * 0.5) * 150;
    oscillations[i].z = sin(r) * 300;
  }
}


/*
  Put your shapes/objects and lights here to be drawn to the screen
*/
void drawScene() {  
  background(0);
  lights();
  
  //front
  pushMatrix();
    translate(width/2 + oscillations[0].x, height/2, 250);
    rotateX(rotations[0].x);
    fill(255, 0, 0);
    box(75);
  popMatrix();

  //right
  pushMatrix();
    translate(width/2 + 250, height/2, oscillations[1].z);
    rotateZ(rotations[1].z);
    fill(0, 255, 0);
    box(75);
  popMatrix();

  //back
  pushMatrix();
    translate(width/2, height/2 + oscillations[2].y, -250);
    rotateY(rotations[2].y);
    fill(0, 0, 255);
    box(75);
  popMatrix();

  //left
  pushMatrix();
    translate(width/2 - 250, height/2, 0);
    rotateY(rotations[3].y);
    rotateZ(rotations[3].z);
    fill(255, 255, 0);
    box(75);
  popMatrix();

  //top
  pushMatrix();
    translate(width/2, height/2 - 250, 0);
    rotateY(rotations[4].y);
    rotateZ(rotations[4].z);
    fill(0, 255, 255);
    box(75);
  popMatrix();

  //bottom
  pushMatrix();
    translate(width/2, height/2 + 250, 0);
    rotateY(rotations[5].y);
    rotateX(rotations[5].x);
    fill(255, 0, 255);
    box(75);
  popMatrix();
}
