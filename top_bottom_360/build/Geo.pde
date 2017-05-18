class Geo extends Drawable {

	float w, h;
	
	Geo() {
		super();

		w = 50;
		h = 50;
	}

	public void update() {
		super.update();
	}

	public boolean isDead() {
		if (loc.z > 7500) {
			return true;
		} else {
			return false;
		}
	}

	public void display() {

		canvas.pushMatrix();

			canvas.translate(loc.x, loc.y, loc.z);

			canvas.hint(DISABLE_DEPTH_TEST);
			canvas.hint(ENABLE_DEPTH_SORT); //woohoo!!!!

			for (int i = 7; i > 0; i--) {
				canvas.rotate(radians((i+1) * 15));
				canvas.noStroke();
				canvas.noFill();
				canvas.fill(0, 255, 0);

				canvas.beginShape(QUADS);
					canvas.tint(255 - i*25, 65 + i*20, 50 + i*20, 200);
					canvas.texture(poly);
					canvas.textureMode(NORMAL);
					canvas.vertex(-w, -h, -i * 300, 0, 0);
					canvas.vertex(w, -h, -i * 300, 1, 0);
					canvas.vertex(w, h, -i * 300, 1, 1);
					canvas.vertex(-w, h, -i * 300, 0, 1);
				canvas.endShape(CLOSE);
			}
			canvas.hint(ENABLE_DEPTH_TEST);
			canvas.hint(DISABLE_DEPTH_SORT);

		canvas.popMatrix();
	}
}