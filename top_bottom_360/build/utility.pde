void renderTexture(float offset) {
	{

		int currentHorizontalStep = 0;
		int currentVerticalStep = 0;

		//set start positions
		float roll = 0.0f;
		float yaw = 0.0f;
		float pitch = 90.0f - vAngIncrement/2.0f;

    	float focalLength = 50.0;

		float pitchCheck = pitch + 0;

		int totalSteps = numberOfHorizontalSteps * numberOfVerticalSteps;
		for (int i = 0; i < totalSteps; i++) {
			currentHorizontalStep = i % numberOfHorizontalSteps;
			currentVerticalStep = floor(i/numberOfHorizontalSteps);

			yaw = 180.0f + currentHorizontalStep * hAngIncrement;
			pitch = -90.0f + currentVerticalStep * vAngIncrement;

			pitchCheck = pitch + 0;

			float pitchUp = 90.0f - pitch;

			if (currentVerticalStep >= (numberOfVerticalSteps-2) || currentVerticalStep < 2) {
			   pitchUp = -90.0f - pitch;//up and down
			}

			pitchUp = radians(clamp(pitchUp));

			//clamp rotations between 0 and 360
      		float fwdYaw = radians(yaw - 90.0);
			yaw = radians(clamp(yaw));
			pitch = radians(clamp(pitch));

			//set cam rotation and pos
			PVector pos = new PVector(width/2, height/2, 0.0f);
			
			float x = cos(yaw) * offset;
			float z = sin(yaw) * offset;
			pos.x += x;
			pos.z += z;

			//handle eye separation
			PVector fwd = new PVector();
			fwd.x = pos.x + focalLength * (cos(fwdYaw)*cos(pitch));
			fwd.y = pos.y + focalLength * sin(pitch);
			fwd.z = pos.z + focalLength * (sin(fwdYaw)*cos(pitch));

			PVector up = new PVector();
      
			up.x = (cos(fwdYaw)*cos(pitchUp));
			up.y = sin(pitchUp);
			up.z = sin(fwdYaw)*cos(pitchUp);

			up.normalize();

			canvas.camera(pos.x, pos.y, pos.z, fwd.x, fwd.y, fwd.z, up.x, up.y, up.z);

			drawStage();

			int capX = (int) (width/2 - stripWidth/2);
			int capY = (int) (height/2 - stripHeight/2);

			int dX = currentHorizontalStep * stripWidth;
			int dY = currentVerticalStep * stripHeight;

			PImage stage = canvas.get();

			unprojectedAtlas.copy(stage, capX, capY, stripWidth, stripHeight, dX, dY, stripWidth, stripHeight);

		}
	}
}


float clamp(float value) {
	float f = value % 360.0f;
	if (f < 0.0f) {
		f += 360.0f;
	}
	return f;
}
