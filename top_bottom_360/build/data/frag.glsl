#ifdef GL_ES
precision highp float;
precision highp int;
#endif
 
uniform sampler2D sampleSet;

uniform vec2 u_resolution;
uniform vec2 u_sampleResolution;

uniform float hAngIncrement;
uniform float vAngIncrement;

uniform float stripWidth;
uniform float stripHeight;

uniform int sampling_level;

float myClamp(float value) {
	float f = mod(value, 360.0f);
	if (f < 0.0f) {
		f = f + 360.0f;
	}
	return f;
}


vec3 getColorAt(float xOff, float yOff) {

	vec2 slicePlaneDim = vec2(
    	2.0f * tan(radians(hAngIncrement) / 2.0f),
    	2.0f * tan(radians(vAngIncrement) / 2.0f)
    );

    double dimX = 0.03491013;
    double dimY = 0.5358984;

	vec2 pos = vec2(float(gl_FragCoord.x + xOff), float(gl_FragCoord.y + yOff));
	// vec2 pos = gl_FragCoord.xy;
	pos = pos/u_resolution;
	pos.y = 1.0 - pos.y;

	// vec2 modifier = vec2(1.0, 1.0)/u_resolution;

	// pos.x = pos.x + xOff * modifier.x;
	// pos.y = pos.y + yOff * modifier.y;

	// vec4 clr = texture2D(sampleSet, pos);

	// return vec3(clr.r, clr.g, clr.b);

	float sampleTheta = pos.x * 360.0f;
	float samplePhi = pos.y * 180.0f;
	float sampleThetaRad = radians(sampleTheta);
	float samplePhiRad = radians(samplePhi);

	vec3 sampleDirection = vec3(
		sin(samplePhiRad) * cos(sampleThetaRad), 
		sin(samplePhiRad) * sin(sampleThetaRad), 
		cos(samplePhiRad)
	);

	int sliceXIndex = int(myClamp(floor(sampleTheta + hAngIncrement / 2.0f)) / hAngIncrement);

	int sliceYIndex = 0;

	//calculate slice Y index
	
		float largestCosAngle = 0.0f;
		for (int vstep = 0; vstep < 7; vstep++) {

			vec2 sliceCenterThetaPhi = vec2(
				hAngIncrement * sliceXIndex,
				vAngIncrement * vstep
			);

			vec3 sliceDir = vec3(
				sin(radians(sliceCenterThetaPhi.y)) * cos(radians(sliceCenterThetaPhi.x)),
				sin(radians(sliceCenterThetaPhi.y)) * sin(radians(sliceCenterThetaPhi.x)),
				cos(radians(sliceCenterThetaPhi.y))
			);

			float cosAngle = dot(sampleDirection, sliceDir);

			if (cosAngle > largestCosAngle) {
				largestCosAngle = cosAngle;
				sliceYIndex = vstep;
			}
		}

	vec2 sliceCenterThetaPhi = vec2(hAngIncrement * sliceXIndex, vAngIncrement * sliceYIndex);

	vec3 sliceDir = normalize(vec3(
		sin(radians(sliceCenterThetaPhi.y)) * cos(radians(sliceCenterThetaPhi.x)),
		sin(radians(sliceCenterThetaPhi.y)) * sin(radians(sliceCenterThetaPhi.x)),
		cos(radians(sliceCenterThetaPhi.y))
	));

	float planeW = dot(sliceDir, vec3(-sliceDir.x, -sliceDir.y, -sliceDir.z));

	vec3 slicePlanePhiTangent = normalize(vec3(
		cos(radians(sliceCenterThetaPhi.y)) * cos(radians(sliceCenterThetaPhi.x)),
		cos(radians(sliceCenterThetaPhi.y)) * sin(radians(sliceCenterThetaPhi.x)),
		-sin(radians(sliceCenterThetaPhi.y))
	));

	vec3 slicePlaneThetaTangent = normalize(cross(sliceDir, slicePlanePhiTangent));

	float t = -planeW / dot(sampleDirection, sliceDir);

	vec3 sliceIntersection = vec3(
		t * sampleDirection.x, 
		t * sampleDirection.y, 
		t * sampleDirection.z
	);

	float sliceU = float(dot(sliceIntersection, slicePlaneThetaTangent) / dimX);
	float sliceV = float(dot(sliceIntersection, slicePlanePhiTangent) / dimY);

	//TODO: ikrimae: Supersample/bilinear filter
	float slicePixelX = floor(sliceU * stripWidth);
	float slicePixelY = floor(sliceV * stripHeight);

	float sliceCenterPixelX = floor(sliceXIndex * int(stripWidth) + floor(stripWidth/2.0));
	float sliceCenterPixelY = floor(sliceYIndex * int(stripHeight) + floor(stripHeight/2.0));
	
	pos.x = int(sliceCenterPixelX + slicePixelX)/u_sampleResolution.x;
	pos.y = int(sliceCenterPixelY + slicePixelY)/u_sampleResolution.y;

	vec4 color = texture2D(sampleSet, pos);

	return vec3(color.r, color.g, color.b);

}


void main(void) {

	vec3 myColor = vec3(0.0f, 0.0f, 0.0f);

	if (sampling_level < 2) {
		if (sampling_level == 0) {
			//Lowest quality sampling
			myColor = getColorAt(0.0f, 0.0f);
			gl_FragColor = vec4(myColor, 1.0);
		} else {
			//medium quality sampling
			myColor = myColor + getColorAt(0.125f, 0.625f);
			myColor = myColor + getColorAt(0.375f, 0.125f);
			myColor = myColor + getColorAt(0.625f, 0.875f);
			myColor = myColor + getColorAt(0.875f, 0.375f);
			gl_FragColor = vec4(myColor/4.0, 1.0);
		}
	} else {
		//best quality sampling
		myColor = myColor + getColorAt(0.125f, 0.125f);
		myColor = myColor + getColorAt(0.125f, 0.375f);
		myColor = myColor + getColorAt(0.125f, 0.625f);
		myColor = myColor + getColorAt(0.125f, 0.875f);
		myColor = myColor + getColorAt(0.375f, 0.125f);
		myColor = myColor + getColorAt(0.375f, 0.375f);
		myColor = myColor + getColorAt(0.375f, 0.625f);
		myColor = myColor + getColorAt(0.375f, 0.875f);
		myColor = myColor + getColorAt(0.625f, 0.125f);
		myColor = myColor + getColorAt(0.625f, 0.375f);
		myColor = myColor + getColorAt(0.625f, 0.625f);
		myColor = myColor + getColorAt(0.625f, 0.875f);
		myColor = myColor + getColorAt(0.875f, 0.125f);
		myColor = myColor + getColorAt(0.875f, 0.375f);
		myColor = myColor + getColorAt(0.875f, 0.625f);
		myColor = myColor + getColorAt(0.875f, 0.875f);
		gl_FragColor = vec4(myColor/16.0, 1.0);
	}
	
}
