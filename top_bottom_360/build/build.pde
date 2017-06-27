/*
	Processing to 3D 360 video (Top/Bottom view) rendering.

	This is purely an exporting tool. There's nothing to see on screen, all the work is done behind the scenes and generates frames for 3D 360 photos or video.

	The code is largely a port of the Unreal Engine 360 exporter by Kite and Lightning, into the Processing / Java language, 
	with the functionality that transforms the sampled texture to an equirectangular image for export, done by a GLSL shader.

	Currently, this code does NOT support pixelDensity(2).

	It is also not real time, so please don't expect 60FPS rendering.

	Inside the shader, there's 3 sampling levels. The best quality is the default, but you can go in and change it.
	There's probably some optimisation that could be done on the shader, but it works.

	Do all of your drawing to the canvas PGraphics object inside the drawStage() method. Anything drawn direct to the screen won't show up.
*/

boolean debug = false;

int sphericalAtlasWidth = 2048;
int sphericalAtlasHeight = 1024;

int captureHeight = 720;
int captureWidth = 720;

float hAngIncrement = 2.0f;
float vAngIncrement = 30.0f;
float eyeSeparation = 6.4f;
float fieldOfView = 60.0f;

int numberOfHorizontalSteps;
int numberOfVerticalSteps;
int totalSteps;

int unprojectedAtlasWidth;
int unprojectedAtlasHeight;

int stripWidth;
int stripHeight;

PVector slicePlaneDim;
PVector capturePlaneDim;

PImage unprojectedAtlas;
PGraphics projection_tmp;
PImage projection;
PGraphics canvas;

PShader myShader;

/*
	Put your sketch variables under here
*/
//stuff for data analysis/mapping
Table table;
float[] avgs = {80.0, 80.0, 60.0, 50.0, 40.0, 38.0, 36.0, 33.0, 28.0, 22.0, 21.0, 19.0, 18.0};
float[] cur = new float[13];

//frame counting / table index
int counter = 0;
int max = 0;

//my scene and anim vars
TerrainGrid myGrid;
ArrayList<Drawable> myObjects = new ArrayList<Drawable>();
PImage sky;
PShape sun;
PImage poly;
float delay, myDelay;

void setup() {

	size(720, 720, P3D);
	frameRate(30);
	smooth();

	numberOfHorizontalSteps = int(360.0f / hAngIncrement);
	numberOfVerticalSteps = int(180.0f / vAngIncrement) + 1; //Need an extra b/c we only grab half of the top & bottom slices
	totalSteps = numberOfHorizontalSteps * numberOfVerticalSteps;

	slicePlaneDim = new PVector(
		2.0f * tan(radians(hAngIncrement) / 2.0f),
		2.0f * tan(radians(vAngIncrement) / 2.0f)
	);
	capturePlaneDim = new PVector(
		2.0f * tan(radians(fieldOfView) / 2.0f),
		2.0f * tan(radians(fieldOfView) / 2.0f)
	);
	
	stripWidth  = ceil(width  * slicePlaneDim.x / capturePlaneDim.x);
	stripHeight = ceil(height * slicePlaneDim.y / capturePlaneDim.y);

	//Ensure strip width and height are even
	stripWidth  += stripWidth & 1;
	stripHeight += stripHeight & 1;

	unprojectedAtlasWidth  = numberOfHorizontalSteps * stripWidth;
	unprojectedAtlasHeight = numberOfVerticalSteps   * stripHeight;

	if (debug) {
		println("slicePlaneDim: " + slicePlaneDim);
		println("capturePlaneDim: " + capturePlaneDim);
		println("stripWidth: " + stripWidth);
		println("stripHeight: " + stripHeight);
		println("unprojectedAtlasWidth: " + unprojectedAtlasWidth);
		println("unprojectedAtlasHeight: " + unprojectedAtlasHeight);
	}

	canvas = createGraphics(captureWidth, captureHeight, P3D);

	//set up PImage to draw sampling texture to
	unprojectedAtlas = createImage(unprojectedAtlasWidth, unprojectedAtlasHeight, RGB);

	//setup the output graphics object that serves as our 360 photo/video file(s)
	projection_tmp = createGraphics(sphericalAtlasWidth, sphericalAtlasHeight, P3D);
	projection = createImage(sphericalAtlasWidth, sphericalAtlasHeight*2, RGB);

	//set up the shader to handle the sampling
	myShader = loadShader("frag.glsl");

	myShader.set("u_resolution", float(projection_tmp.width), float(projection_tmp.height));
	myShader.set("u_sampleResolution", float(unprojectedAtlas.width), float(unprojectedAtlas.height));
	myShader.set("hAngIncrement", hAngIncrement);
	myShader.set("vAngIncrement", vAngIncrement);
	myShader.set("stripWidth", float(stripWidth));
	myShader.set("stripHeight", float(stripHeight));
	myShader.set("sampling_level", int(2));//For best quality use 2. For medium, use 1, for low, use 0. Low quality runs a tiny bit faster, but looks worse than 1 or 2.

	/*
		Your sketch vars init
	*/

	//load table data
	table = loadTable("data_30fps.csv");
	max = table.getRowCount();
	for (int i = 0; i < 13; i++) {
		cur[i] = 0;
	}

	//other stuff for animations...
	myGrid = new TerrainGrid();
	myGrid.startZ(400);
	myGrid.startY(5000);
	myGrid.startX(-5115);
	myGrid.initGrid();

	sky = loadImage("sky3.jpg");

	sun = loadShape("sun.svg");
	poly = loadImage("poly2.png");

	delay = 30.0 * 6.3;
	myDelay = 30.0 * 6.3;
	

	/*
	  Not sure why this is necessary yet, but you have to set the perspective 
	  before setting the camera or the first slice will ignore all the camera rotations
	  For now, leave this as is and will investigate later.
	*/
	canvas.beginDraw();
	canvas.perspective(radians(fieldOfView), 1, 1, 10000);
	canvas.endDraw();
}

void draw() {
	projection_tmp.hint(DISABLE_TEXTURE_MIPMAPS);
	((PGraphicsOpenGL)projection_tmp).textureSampling(2);

	//run any pre render animations
	animationPreUpdate();

	//render the left eye
	renderTexture(-eyeSeparation/2);
	myShader.set("sampleSet", unprojectedAtlas);
	projection_tmp.filter(myShader);

	//copy left eye to main projection frame
	projection.copy(projection_tmp, 
				0, 0, projection_tmp.width, projection_tmp.height, 
				0, 0, projection_tmp.width, projection_tmp.height);

	//render the right eye
	renderTexture(eyeSeparation/2);
	myShader.set("sampleSet", unprojectedAtlas);
	projection_tmp.filter(myShader);
	
	//copy right eye to main projection frame
	projection.copy((PImage) projection_tmp, 
				0, 0, projection_tmp.width, projection_tmp.height, 
				0, projection_tmp.height, projection_tmp.width, projection_tmp.height);

	//save the frame
	if (counter <= max) {
		projection.save("frames/filename-"+counter+".png");
	} else {
		noLoop();
		exit();
	}

	//run any post render animations
	animationPostUpdate();
}

void drawStage() {
	canvas.beginDraw();
	//leave perspective as is, it's necessary for accurate rendering
	canvas.perspective(radians(fieldOfView), 1, 1, 10000);

	/*
		Add your code below
	*/
	canvas.background(#050122);

	//can we listen to data and draw a frame?
	if (counter < max) {

		//skybox
		canvas.pushMatrix();
		canvas.translate(width/2, height/2, 0);
		float rot = radians(360.0/36.0);
		float sRot = radians(-90.0);
		float rad = 8000;
		canvas.fill(255);
		canvas.noStroke();
		canvas.strokeWeight(0);
		canvas.beginShape(QUADS);
		canvas.textureMode(NORMAL);
		canvas.tint(255);
		canvas.texture(sky);
		for (int i = 0; i < 36; i++) {
			float x = rad * cos(sRot + rot*i);
			float z = rad * sin(sRot + rot*i);

			float x1 = rad * cos(sRot + rot*(i+1));
			float z1 = rad * sin(sRot + rot*(i+1));

			float u = map(i, 0, 36, 1.0, 0.0);
			float u1 = map(i+1, 0, 36, 1.0, 0.0);

			canvas.vertex(x, -6000, z, u, 0.0);
			canvas.vertex(x1, -6000, z1, u1, 0.0);
			canvas.vertex(x1, 400, z1, u1, 1.0);
			canvas.vertex(x, 400, z, u, 1.0);


		}
		canvas.endShape(CLOSE);
		canvas.popMatrix();

		//sun
		canvas.pushMatrix();
			canvas.translate(width/2, height/2, -7800);
			canvas.noLights();

			float sunSz = 1200;

			canvas.fill(#050122);
			canvas.ellipse(0, 0, sunSz, sunSz);

			canvas.translate(0, 0, 10);

			canvas.pointLight(255, 64, 0, 760, -250, 148);
			canvas.pointLight(255, 26, 156, -720, 350, 266);
			canvas.pointLight(255, 196, 13, 0, -760, 198);

			sun.disableStyle();
			canvas.strokeWeight(0);
			canvas.noStroke();
			canvas.fill(255);

			canvas.shape(sun, -sunSz/2, -sunSz/2, sunSz, sunSz);
		canvas.popMatrix();

		//display my terrain
		canvas.pushMatrix();
		canvas.noLights();
		canvas.translate(width/2, 0, 0);
		canvas.directionalLight(128, 32, 0, 0, 0, 0.94868326);
		canvas.directionalLight(10, 0, 40, 0, 0.70710677, -0.70710677);
		
		canvas.spotLight(0, 10, 70, 0, -500, 500, 0, 0.4472136, 0.8944272, PI, 2);
		canvas.translate(-width/2, 0, 0);
		
		myGrid.display();
		canvas.popMatrix();

		canvas.blendMode(ADD);
		for (Drawable d : myObjects) {
			d.display();
		}
		canvas.blendMode(BLEND);
	}

	canvas.endDraw();
}

void animationPreUpdate() {
	//any variables used for animation BEFORE drawing is done should be placed here
	TableRow row = table.getRow(counter);

	for (int idx = 0; idx < 13; idx++) {
		float h = row.getFloat(idx);
		
		if (h > avgs[idx]) {

			cur[idx] = h;

			//trigger an animation somewhere with this variable attached
			if (idx == 0) {
				//add a pyramid
				Pyramid p = new Pyramid();
				p.setPos(random(-4000, 4000), random(-4000, height/4), random(-6000, -4000));
				p.setVel(0, 5, 20);//random(10, 50));
				p.setIdx(floor(random(1, 8)));
				myObjects.add(p);
			}

			if (idx == 9) {
				Beams b = new Beams();
				b.setPos(random(-5000, 5000), 900, -5500);
				b.setVel(0, 0, 20);
				b.setIdx(floor(random(1, 8)));
				myObjects.add(b);
			}

			if (idx == 11 && myDelay >= delay) {
				myDelay = 0;

				Geo g = new Geo();
				g.setPos(width/2, height/2, -5000);
				g.setVel(0, 0, random(50, 80));
				myObjects.add(g);
			}

			if (idx == 12 && frameCount > 1570) {
				Icos i = new Icos();
				i.setPos(random(-5000, 5000), 800, random(-5500, -1000));
				i.setVel(0, -10, 20);
				i.setIdx(floor(random(1, 8)));
				myObjects.add(i);
			}

		} else {
			cur[idx] *= 0.95;
		}
	}
}

void animationPostUpdate() {

	myGrid.update();
	for (int i = myObjects.size() - 1; i >= 0; i--) {
		Drawable d = myObjects.get(i);
		d.update();
		if (d.isDead() == true) {
			myObjects.remove(i);
		}
	}

	counter += 1;
	myDelay += 1;
}
