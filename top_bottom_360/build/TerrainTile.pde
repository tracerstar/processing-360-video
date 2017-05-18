class TerrainTile {

	PVector[] points = new PVector[4];
	int index, myX, myZ;

	float nz = 0.12203;
	float nx = 0.183;
	float nMult = 650;

	float yOff = 0;

	color fill;
	
	TerrainTile(int i) {
		index = i;

		myX = floor(index%10);
		myZ = floor(index/10);

		fill = color(#ffffff);
	}

	public void setPoints(int idx, float x, float y, float z) {
		if (idx >=0 && idx <= 3) {
			points[idx] = new PVector(x, y, z);
		}
	}

	public void setFill(color f) {
		fill = f;
	}

	public void noiseY(int numTiles) {

		int x = floor(index%numTiles);
		int z = floor(index/numTiles);

		points[0].z = yOff + noise(x * nx, z*nz) * nMult;
		points[1].z = yOff + noise((x+1) * nx, z*nz) * nMult;
		points[2].z = yOff + noise((x+1) * nx, (z + 1) * nz) * nMult;
		points[3].z = yOff + noise(x * nx, (z + 1) * nz) * nMult;
	}

	public void setYoff(float y) {
		yOff = y;
	}

	public void zPlus(float z) {
		points[0].y += z;
		points[1].y += z;
		points[2].y += z;
		points[3].y += z;
	}

	float getZ() {
		return points[0].y;
	}

	public void drawVerts() {
		
		canvas.stroke(
			200, 
			min(map(points[0].y, 6500, 4500, 100, 0), 100), 
			min(map(points[0].y, -8500, 3000, 0, 160), 160)
		);

		canvas.vertex(points[0].x, points[0].z, points[0].y);
		canvas.vertex(points[1].x, points[1].z, points[1].y);
		canvas.vertex(points[2].x, points[2].z, points[2].y);
		canvas.vertex(points[3].x, points[3].z, points[3].y);

	}
}