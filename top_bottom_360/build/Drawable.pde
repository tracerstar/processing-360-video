class Drawable {

	PVector loc;
	PVector vel;

	int myFill;
	int myStroke;
	float myStrokeWeight;
	int myIdx;
	

	Drawable() {
		loc = new PVector();
		vel = new PVector();

		myFill = color(255, 255, 255);
		myStroke = color(0, 0, 0);
		myStrokeWeight = 1;
	}

	public boolean isDead() {
		return false;
	}

	public void setIdx(int i) {
		myIdx = i;
	}

	public void setPos(float x, float y, float z) {
		loc.x = x;
		loc.y = y;
		loc.z = z;
	}

	public void setVel(float x, float y, float z) {
		vel.x = x;
		vel.y = y;
		vel.z = z;
	}

	public float getZ() {
		return loc.z;
	}

	public void setFill(color c) {
		myFill = c;
	}
	public void setStroke(color c) {
		myStroke = c;
	}
	public void setStrokeWeight(float f) {
		myStrokeWeight = f;
	}

	public void display() {
		
	}

	public void update() {
		loc.add(vel);
	}
}