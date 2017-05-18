/**
 * Processing to 360 video
 * 
 * This sketch renders a cubemap to an equirectangular image that can be captured to create 360 photos or videos.
 *
 * example_02 - integration with HYPE Framework
 * 
 * The code is a modification of the DomeProjection Processing example sketch, and an equirectangular GLSL shader by BeRo, on ShaderToy: 
 * https://www.shadertoy.com/view/XsBSDR#
 * https://www.shadertoy.com/user/BeRo
 */

import hype.*;
import hype.extended.layout.HSphereLayout;
import hype.extended.behavior.HOscillator;
import hype.extended.behavior.HOrbiter3D;
 
import java.nio.IntBuffer;

PShader cubemapShader;
PShape myRect;

IntBuffer fbo;
IntBuffer rbo;
IntBuffer envMapTextureID;

int envMapSize = 1024; //width & height used for the cubemap texture
/*
  The following float, zClippingPlane, is the distance from center to a cubemap wall. 
  The higher the number, the further objects can travel before they begin to clip out of frame.
  The pixel dimension of the drawable area is 0 to zClippingPlane * 2.
  e.g. if zClippingPlane is 2000, the drawable area is 0 to 4000 in each direction (x, y, z).

  Rather than rely on your screen width and height vars, you should use values based on the zClippingPlane.
  i.e. to translate to center screen, use: 
  translate(zClippingPlane, zClippingPlane, 0);

  Remember instead of width/2 or height/2, use zClippingPlane, 
  and instead of width or height, use zClippingPlane*2
*/
float zClippingPlane = 2000.0f;

//set record to true if you want to save frames to make a video
boolean record = false;

//HYPE specific vars
HDrawablePool     pool;
HSphereLayout     layout;
HOrbiter3D        orb, orb2;

void setup() {
  //we'll be using the saved frames to create a 2048 x 1024 video
  size(2048, 1024, P3D);

  //for testing, you might want to work at a smaller resolution, but for export, the above is preferred
  //size(1024, 512, P3D);

  smooth();
  background(0);

  // if you have a retina display, pixelDesnity(2) is supported. Bring on those 4k renders!
  // pixelDensity(2);

  initCubeMap();

  //HYPE stuff
  H.init(this).background(#242424).use3D(true);

  pool = new HDrawablePool(200);

  layout = new HSphereLayout()
    .loc(zClippingPlane, zClippingPlane, 0)
    .radius(200)
    .rotate(true)
    .useSpiral()
    .numPoints(200)
    .phiModifier(3.0001)
  ;
  
  pool.add(new HIcosahedron())
    .layout(layout)
    .autoAddToStage()
    .onCreate (
      new HCallback() {
        public void run(Object obj) {
          HDrawable3D d = (HDrawable3D) obj;
          d.depth(20);
          d.size(20, 20);
          d.noStroke();

          int i = pool.currentIndex();

          new HOscillator()
            .target(d)
            .property(H.SCALE)
            .range(0.5, 1.5)
            .speed(1.5)
            .freq(1.6)
            .currentStep(i*3)
          ;
        }
      }
    )
    .requestAll()
  ;

  orb = new HOrbiter3D(zClippingPlane, zClippingPlane, 0)
    .zSpeed(random(0.0, 1.0) + 0.5)
    .ySpeed(random(0.0, 1.0) + 0.5)
    .radius(250)
    .zAngle( (int)random(360) )
    .yAngle( (int)random(360) )
  ;

  orb2 = new HOrbiter3D(zClippingPlane, zClippingPlane, 0)
    .zSpeed(random(0.0, 1.0) + 1.0)
    .ySpeed(random(0.0, 1.0) + 0.5)
    .radius(300)
    .zAngle( (int)random(360) )
    .yAngle( (int)random(360) )
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
  orb._run();
  orb2._run();
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
  pointLight(35, 35, 35, zClippingPlane, zClippingPlane-400, 300);
  pointLight(255, 0, 156,   orb.x(), orb.y(), orb.z()); // magenta
  pointLight(0, 100, 180,   orb2.x(), orb2.y(), orb2.z()); // blue

  H.drawStageOnly();
}
