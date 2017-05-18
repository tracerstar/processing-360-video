class Icos extends Drawable {

	ArrayList<PVector> v;

	float fadeAmt;
	float curFade;

	float xSpin, zSpin, xSpeed, zSpeed;

	Icos() {
		super();

		v = new ArrayList<PVector>();

		float t = 1.61803399f / 2.0f;//half golden ration to make icos unit radius .5

		v.add(new PVector(-0.5f,  t,  0));
		v.add(new PVector( 0.5f,  t,  0));
		v.add(new PVector(-0.5f, -t,  0));
		v.add(new PVector( 0.5f, -t,  0));
		v.add(new PVector( 0, -0.5f,  t));
		v.add(new PVector( 0,  0.5f,  t));
		v.add(new PVector( 0, -0.5f, -t));
		v.add(new PVector( 0,  0.5f, -t));
		v.add(new PVector( t,  0, -0.5f));
		v.add(new PVector( t,  0,  0.5f));
		v.add(new PVector(-t,  0, -0.5f));
		v.add(new PVector(-t,  0,  0.5f));

		fadeAmt = random(1, 5);
		curFade = 255;

		xSpeed = random(2, 8);
		zSpeed = random(2, 8);

		xSpin = 0;
		zSpin = 0;
	}

	public boolean isDead() {
		if (curFade <= 0) {
			return true;
		} else {
			return false;
		}
	}

	public void update() {
		super.update();
	
		curFade -= max(fadeAmt, 0.0);

		xSpin += xSpeed;
		zSpin += zSpeed;
	}

	public void display() {

		canvas.pushMatrix();

			canvas.translate(loc.x, loc.y, loc.z);
			canvas.rotateX(radians(xSpin));
			canvas.rotateZ(radians(zSpin));
			canvas.noLights();
			canvas.fill(10, 10, 30, curFade);
			canvas.strokeWeight(2);
			canvas.stroke(#dd3300, curFade);

			canvas.scale(100,100,100);
			
			//scale the strokeWeight back down so it appears normal on screen
			float sw = (float) 1.0/100 * 2;
			canvas.strokeWeight(sw);

			canvas.beginShape(PConstants.TRIANGLES);

				// 5 faces around point 0
				canvas.vertex(v.get(0).x, v.get(0).y, v.get(0).z);
				canvas.vertex(v.get(11).x, v.get(11).y, v.get(11).z);
				canvas.vertex(v.get(5).x, v.get(5).y, v.get(5).z);

				canvas.vertex(v.get(0).x, v.get(0).y, v.get(0).z);
				canvas.vertex(v.get(5).x, v.get(5).y, v.get(5).z);
				canvas.vertex(v.get(1).x, v.get(1).y, v.get(1).z);

				canvas.vertex(v.get(0).x, v.get(0).y, v.get(0).z);
				canvas.vertex(v.get(1).x, v.get(1).y, v.get(1).z);
				canvas.vertex(v.get(7).x, v.get(7).y, v.get(7).z);

				canvas.vertex(v.get(0).x, v.get(0).y, v.get(0).z);
				canvas.vertex(v.get(7).x, v.get(7).y, v.get(7).z);
				canvas.vertex(v.get(10).x, v.get(10).y, v.get(10).z);

				canvas.vertex(v.get(0).x, v.get(0).y, v.get(0).z);
				canvas.vertex(v.get(10).x, v.get(10).y, v.get(10).z);
				canvas.vertex(v.get(11).x, v.get(11).y, v.get(11).z);

				// 5 adjacent faces
				canvas.vertex(v.get(1).x, v.get(1).y, v.get(1).z);
				canvas.vertex(v.get(5).x, v.get(5).y, v.get(5).z);
				canvas.vertex(v.get(9).x, v.get(9).y, v.get(9).z);

				canvas.vertex(v.get(5).x, v.get(5).y, v.get(5).z);
				canvas.vertex(v.get(11).x, v.get(11).y, v.get(11).z);
				canvas.vertex(v.get(4).x, v.get(4).y, v.get(4).z);

				canvas.vertex(v.get(11).x, v.get(11).y, v.get(11).z);
				canvas.vertex(v.get(10).x, v.get(10).y, v.get(10).z);
				canvas.vertex(v.get(2).x, v.get(2).y, v.get(2).z);

				canvas.vertex(v.get(10).x, v.get(10).y, v.get(10).z);
				canvas.vertex(v.get(7).x, v.get(7).y, v.get(7).z);
				canvas.vertex(v.get(6).x, v.get(6).y, v.get(6).z);

				canvas.vertex(v.get(7).x, v.get(7).y, v.get(7).z);
				canvas.vertex(v.get(1).x, v.get(1).y, v.get(1).z);
				canvas.vertex(v.get(8).x, v.get(8).y, v.get(8).z);

				// 5 faces around point 3
				canvas.vertex(v.get(3).x, v.get(3).y, v.get(3).z);
				canvas.vertex(v.get(9).x, v.get(9).y, v.get(9).z);
				canvas.vertex(v.get(4).x, v.get(4).y, v.get(4).z);

				canvas.vertex(v.get(3).x, v.get(3).y, v.get(3).z);
				canvas.vertex(v.get(4).x, v.get(4).y, v.get(4).z);
				canvas.vertex(v.get(2).x, v.get(2).y, v.get(2).z);

				canvas.vertex(v.get(3).x, v.get(3).y, v.get(3).z);
				canvas.vertex(v.get(2).x, v.get(2).y, v.get(2).z);
				canvas.vertex(v.get(6).x, v.get(6).y, v.get(6).z);

				canvas.vertex(v.get(3).x, v.get(3).y, v.get(3).z);
				canvas.vertex(v.get(6).x, v.get(6).y, v.get(6).z);
				canvas.vertex(v.get(8).x, v.get(8).y, v.get(8).z);

				canvas.vertex(v.get(3).x, v.get(3).y, v.get(3).z);
				canvas.vertex(v.get(8).x, v.get(8).y, v.get(8).z);
				canvas.vertex(v.get(9).x, v.get(9).y, v.get(9).z);

				// 5 adjacent faces
				canvas.vertex(v.get(4).x, v.get(4).y, v.get(4).z);
				canvas.vertex(v.get(9).x, v.get(9).y, v.get(9).z);
				canvas.vertex(v.get(5).x, v.get(5).y, v.get(5).z);

				canvas.vertex(v.get(2).x, v.get(2).y, v.get(2).z);
				canvas.vertex(v.get(4).x, v.get(4).y, v.get(4).z);
				canvas.vertex(v.get(11).x, v.get(11).y, v.get(11).z);

				canvas.vertex(v.get(6).x, v.get(6).y, v.get(6).z);
				canvas.vertex(v.get(2).x, v.get(2).y, v.get(2).z);
				canvas.vertex(v.get(10).x, v.get(10).y, v.get(10).z);

				canvas.vertex(v.get(8).x, v.get(8).y, v.get(8).z);
				canvas.vertex(v.get(6).x, v.get(6).y, v.get(6).z);
				canvas.vertex(v.get(7).x, v.get(7).y, v.get(7).z);

				canvas.vertex(v.get(9).x, v.get(9).y, v.get(9).z);
				canvas.vertex(v.get(8).x, v.get(8).y, v.get(8).z);
				canvas.vertex(v.get(1).x, v.get(1).y, v.get(1).z);

			canvas.endShape(PConstants.CLOSE);



		canvas.popMatrix();
	}
}