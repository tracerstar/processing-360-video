class TerrainGrid {

	float startX, startY, startZ;
	float spacing;
	int numTiles, numRows;

	ArrayList<TerrainTile> grid;

	float travelled;
	float speed;

	boolean useNoise = true;

	int tileIndex = 0;

	float killDist = 0;

	
	TerrainGrid () {
		
		numTiles = 100;
		numRows = 90;

		startX = 0.0f;
		startY = 0.0f;
		startZ = 0.0f;

		spacing = 150.0f;
		killDist = 10000.0f;

		travelled = 0.0f;
		speed = 20.0f;

		initGrid();

		// println("INIT: " + grid.size());

	}

	public void initGrid() {
		//fill arrayList with initial grid
		grid = new ArrayList<TerrainTile>();

		color f = color(0);

		for (int i = 0; i < numRows; i++) {

			//f = color((int) random(0, 255), (int) random(0, 255), (int) random(0, 255));
			f = color(#ff5500);

			for (int j = 0; j < numTiles; j++) {

				TerrainTile t = new TerrainTile(tileIndex);

				t.setFill(f);
				t.setYoff(startZ);

				float x = startX + j*spacing;
				float z = 0;
				float y = startY - i*spacing;

				t.setPoints(0, x, y, z);
				t.setPoints(1, x+spacing, y, z);
				t.setPoints(2, x+spacing, y-spacing, z);
				t.setPoints(3, x, y-spacing, z);

				if (useNoise) {
					t.noiseY(numTiles);
				}

				grid.add(t);

				tileIndex += 1;

			}
		}
	}

	public void startX(float x) {
		startX = x;
	}

	public void startY(float y) {
		startY = y;
	}

	public void startZ(float z) {
		startZ = z;
	}

	public void update() {

		// println("LOOP: " + grid.size());

		for (TerrainTile tt : grid) {
			tt.zPlus(speed);
		}

		//kill any we need to
		for (int i = grid.size() - 1; i >= 0; i--) {
			TerrainTile t = grid.get(i);
			if (t.getZ() > killDist) {
				grid.remove(i);
			}
		}

		travelled += speed;


		//if last point is within threshold of horizon edge, add a row
		
		if (travelled >= spacing) {

			//println(travelled);

			float diff = travelled - spacing;

			color f = color((int) random(0, 255), (int) random(0, 255), (int) random(0, 255));
			f = color(#ff5500);

			for (int j = 0; j < numTiles; j++) {

				//int index = i * numTiles + j;

				TerrainTile t = new TerrainTile(tileIndex);

				t.setFill(f);
				t.setYoff(startZ);

				float x = startX + j*spacing;
				float y = startY - (numRows*spacing) + travelled;
				float z = 0;

				t.setPoints(0, x, y, z);
				t.setPoints(1, x+spacing, y, z);
				t.setPoints(2, x+spacing, y - spacing, z);
				t.setPoints(3, x, y - spacing, z);

				if (useNoise) {
					t.noiseY(numTiles);
				}


				grid.add(t);

				tileIndex += 1;

			}
			travelled = diff;
		}

	}

	public void addRow() {
		for (int k = 0; k < numTiles; k++) {

				//int index = i * numTiles + j;

				TerrainTile mt = new TerrainTile(tileIndex);
				mt.setYoff(startZ);

				float x = startX + (k * spacing);
				float y = 0;
				float z = -1000;

				mt.setPoints(0, x, y, z);
				mt.setPoints(1, x+spacing, y, z);
				mt.setPoints(2, x+spacing, y, z+spacing);
				mt.setPoints(3, x, y, z+spacing);

				if (useNoise) {
					mt.noiseY(numTiles);
				}

				grid.add(mt);

				tileIndex += 1;

			}
	}

	public void display() {

		canvas.fill(255);
		canvas.strokeWeight(2);

		canvas.beginShape(QUADS);
  		for (int i = 0; i < grid.size(); i++) {
  			TerrainTile t = grid.get(i);
  			t.drawVerts();
		}
		canvas.endShape();


	}

} 