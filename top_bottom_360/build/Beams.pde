class Beams extends Drawable {

	float myHeight;
	float heightCap;
	float speed;

	Beams() {
		super();
		myHeight = 0;

		heightCap = floor(random(2, 6)) * 500;

		speed = floor(random(1, 4)) * 10;
	}

	public void update() {
		super.update();
		myHeight += speed;
		myHeight = min(myHeight, heightCap);
	}

	public boolean isDead() {
		if (loc.z > 7500) {
			return true;
		} else {
			return false;
		}
	}

	public void display() {

		float boxSize = max(cur[myIdx]/6, 5);
		float a = max(75, (2*cur[myIdx]) + 55);

		canvas.pushMatrix();

			canvas.translate(loc.x, loc.y, loc.z);
			canvas.noLights();
			canvas.fill(220, 240, 255, a);
			canvas.strokeWeight(0);
			canvas.noStroke();

			canvas.translate(0, 250, 0);
			canvas.box(boxSize, myHeight, boxSize);

			canvas.translate(50, -125, 0);
			canvas.box(boxSize, myHeight, boxSize);

			canvas.translate(50, -125, 0);
			canvas.box(boxSize, myHeight, boxSize);

			canvas.translate(50, 125, 0);
			canvas.box(boxSize, myHeight, boxSize);

			canvas.translate(50, 125, 0);
			canvas.box(boxSize, myHeight, boxSize);


		canvas.popMatrix();
	}
}