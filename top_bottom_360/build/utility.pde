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

//fudge to reduce the distortion at the poles. Needs further investigation to prevent distortion and retain 3d with eye separation.
//if (currentVerticalStep == 0 || currentVerticalStep == numberOfVerticalSteps-1) {
//if (currentVerticalStep == 0 || currentVerticalStep == (numberOfVerticalSteps-2)) {
  //offset = 0;
//}

//float myYaw = 180.0f + currentHorizontalStep * hAngIncrement;
//float myPitch = -90.0f + currentVerticalStep * vAngIncrement;

			yaw = 180.0f + currentHorizontalStep * hAngIncrement;
			pitch = -90.0f + currentVerticalStep * vAngIncrement;

			pitchCheck = pitch + 0;

			//float pitchUp = pitch - 90.0f;
//float pitchUp = pitch + 90.0f;

//best last working thing
float pitchUp = 90.0f - pitch;

//if (currentVerticalStep == 0 || currentVerticalStep == (numberOfVerticalSteps-1)) {
if (currentVerticalStep >= (numberOfVerticalSteps-2) || currentVerticalStep < 2) {
   pitchUp = -90.0f - pitch;//up and down
   //println(currentVerticalStep + "/" + numberOfVerticalSteps);
   //continue;
}

//println(currentVerticalStep + " // " + numberOfVerticalSteps);

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
      //up.x = pos.x;
      //up.y = pos.y;
      //up.z = pos.z;
			//up.x = cos(yaw)*cos(pitchUp);
			//up.y = sin(pitchUp);
			//up.z = sin(yaw)*cos(pitchUp);
      
      up.x = (cos(fwdYaw)*cos(pitchUp));
      up.y = sin(pitchUp);
      up.z = sin(fwdYaw)*cos(pitchUp);

			up.normalize();
			//up.mult(-1);
//if (currentVerticalStep == 0 || currentVerticalStep == (numberOfVerticalSteps-1)) {
//  up.mult(-1);
//}

			//if (pitchCheck < (-90 + vAngIncrement) || pitchCheck > (90 - vAngIncrement) ) {
				canvas.camera(pos.x, pos.y, pos.z, fwd.x, fwd.y, fwd.z, up.x, up.y, up.z);
			//} else {
				//canvas.camera(pos.x, pos.y, pos.z, fwd.x, fwd.y, fwd.z, 0, 1, 0);
			//}

			drawStage();

			int capX = (int) (width/2 - stripWidth/2);
			int capY = (int) (height/2 - stripHeight/2);

			int dX = currentHorizontalStep * stripWidth;
			int dY = currentVerticalStep * stripHeight;

			PImage stage = canvas.get();

			unprojectedAtlas.copy(stage, 
				capX, capY, stripWidth, stripHeight, 
				dX, dY, stripWidth, stripHeight);

      //if (i == 0) {
      //  println(offset);
      //  println(pos);
      //  println(fwd);
      //  println(up);
      //  println(pitchCheck);
      //  println(pitch);
      //  println(currentHorizontalStep);
      //  println(currentVerticalStep);
      //  //println(myYaw);
      //  //println(myPitch);
        
      //}

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