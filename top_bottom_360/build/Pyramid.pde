class Pyramid extends Drawable {

	private PVector p1, p2, p3, p4;
	public float size;
	public int alpha;

	public float spinY;
	public float spinSpeed;

	public float dropSpeed;

	Pyramid() {
		super();

		size = 100;
		loc = new PVector(0, 0, 0);
		alpha = 75;

		myIdx = 0;

		float spinY = 0;
		spinSpeed = random(2, 8);

		dropSpeed = random(0, 20);

		init();
	}

	private void init() {
		//unit vector of pyramid
		p1 = new PVector(-0.5, -0.433, -0.289);
		p2 = new PVector(0.5, -0.433, -0.289);
		p3 = new PVector(0, -0.433, 0.866-0.289);
		p4 = new PVector(0, 0.433, 0);

		p1.mult(size);
		p2.mult(size);
		p3.mult(size);
		p4.mult(size);
	}

	public boolean isDead() {
		if (loc.z > 7500 || loc.y > 1000) {
			return true;
		} else {
			return false;
		}
	}

	public void setSize(float s) {
		size = s;
		init();
	}

	public void update() {
		super.update();

		loc.y += dropSpeed;

		//setSize((cur[0] + cur[1])/2 * 3);
		setSize(max(cur[myIdx] * 3, 40));

		alpha = (int) map((cur[myIdx]), 0, 100, 25, 120);

		spinY += spinSpeed;
	}

	public void display() {
		canvas.pushMatrix();
			canvas.translate(loc.x, loc.y, loc.z);
			canvas.noLights();

			canvas.rotateY(radians(spinY));

			canvas.fill(myFill, alpha);
			canvas.stroke(0, 150, 200, alpha);
			canvas.strokeWeight(2);

			canvas.beginShape(TRIANGLES);

				//top face
				canvas.vertex(p1.x, p1.y, p1.z);
				canvas.vertex(p2.x, p2.y, p2.z);
				canvas.vertex(p3.x, p3.y, p3.z);

				//back face
				canvas.vertex(p1.x, p1.y, p1.z);
				canvas.vertex(p2.x, p2.y, p2.z);
				canvas.vertex(p4.x, p4.y, p4.z);

				//left face
				canvas.vertex(p1.x, p1.y, p1.z);
				canvas.vertex(p3.x, p3.y, p3.z);
				canvas.vertex(p4.x, p4.y, p4.z);

				//left face
				canvas.vertex(p2.x, p2.y, p2.z);
				canvas.vertex(p3.x, p3.y, p3.z);
				canvas.vertex(p4.x, p4.y, p4.z);

			canvas.endShape();

		canvas.popMatrix();
	}
}