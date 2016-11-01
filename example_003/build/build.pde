/**
 * Processing to 360 video
 * 
 * This sketch renders a cubemap to an equirectangular image that can be captured to create 360 videos.
 *
 * example_003 - integration with HYPE Framework
 * 
 * The code is a modification of the DomeProjection Processing example sketch, and an equirectangular GLSL shader by BeRo, on ShaderToy: 
 * https://www.shadertoy.com/view/XsBSDR#
 * https://www.shadertoy.com/user/BeRo
 */

import hype.*;
import hype.extended.behavior.HOrbiter3D;
import hype.extended.colorist.HColorPool;
 
import java.nio.IntBuffer;

PShader cubemapShader;
PShape myRect;

IntBuffer fbo;
IntBuffer rbo;
IntBuffer envMapTextureID;

int envMapSize = 1024;

//set record to true if you want to save frames to make a video
boolean record = false;

//HYPE specific
HDrawablePool pool;

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

  //HYPE stuff
  H.init(this).background(#242424).use3D(true);

  pool = new HDrawablePool(100);
  pool.autoAddToStage()
    .add(new HSphere())
    .colorist( new HColorPool(#333333,#494949,#5F5F5F,#707070,#7D7D7D,#888888,#949494,#A2A2A2,#B1B1B1,#C3C3C3,#D6D6D6,#EBEBEB,#FFFFFF).fillOnly() )
    .onCreate(
      new HCallback() {
        public void run(Object obj) {
          HSphere d = (HSphere) obj;
          int ranSize = 10 + ( (int)random(3)*7 );

          d.size(ranSize).strokeWeight(0).noStroke().anchorAt(H.CENTER);

          HOrbiter3D orb = new HOrbiter3D(width/2, height/2, 0)
            .target(d)
            .zSpeed(random(-1.5, 1.5))
            .ySpeed(random(-0.5, 0.5))
            .radius(195)
            .zAngle( (int)random(360) )
            .yAngle( (int)random(360) )
          ;
        }
      }
    )
    .requestAll()
  ;

  //I like to advance a couple frames in to get all the Drawables initialised and on their way
  H.drawStage();
  H.drawStage();
  background(0);
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
  H.updateBehaviors();
}


/*
  Put your shapes/objects and lights here to be drawn to the screen
*/
void drawScene() {  
  pointLight(100, 0, 0,  width/2, height, 200);              // under red light
  pointLight(51, 153, 153,  width/2, -50, 150);              // over teal light
  pointLight(204, 204, 204,  width/2, (height/2) - 50, 500); // mid light gray light

  sphereDetail(20);
  H.drawStageOnly();
}
