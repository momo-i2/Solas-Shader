float texture2DShadow(sampler2D shadowtex, vec3 shadowPos) {
    float shadow = texture2D(shadowtex, shadowPos.xy).r;

    return clamp((shadow - shadowPos.z) * 65536.0, 0.0, 1.0);
}

#ifdef VC_SHADOWS
void getDynamicWeather(inout float speed, inout float amount, inout float frequency, inout float density, inout float height) {
    int worldDayInterpolated = int((worldDay * 24000 + worldTime) / 24000);
	float dayAmountFactor = abs(worldDayInterpolated % 7 / 2 - 0.5) * 0.5;
	float dayDensityFactor = abs(worldDayInterpolated % 9 / 4 - worldDayInterpolated % 2);
	float dayFrequencyFactor = 1.0 + abs(worldDayInterpolated % 6 / 4 - worldDayInterpolated % 2) * 0.65;

	amount = mix(amount, 11.5, wetness) - dayAmountFactor;
	density += dayDensityFactor;
	frequency *= dayFrequencyFactor;
}


void getCloudShadow(vec2 rayPos, vec2 wind, float amount, float frequency, float density, inout float noise) {
	rayPos *= 0.0002 * frequency;

	float noiseBase = texture2D(noisetex, rayPos + 0.5 + wind * 0.5).g;
		  noiseBase = (1.0 - noiseBase) * 0.35 + 0.25 + wetness * 0.1;

	noise = noiseBase * 22.0;
	noise = max(noise - amount, 0.0) * (density * 0.25);
	noise /= sqrt(noise * noise + 0.25);
	noise = exp(noise * -2.0);
    noise = clamp(noise, 0.0, 1.0);
}
#endif

vec3 ToShadowProjected(vec3 pos){
    pos = mat3(gbufferModelViewInverse) * pos + gbufferModelViewInverse[3].xyz;
    pos = mat3(shadowModelView) * pos + shadowModelView[3].xyz;
    pos = diagonal3(shadowProjection) * pos + shadowProjection[3].xyz;

    return pos;
}

vec3 distortShadow(vec3 shadowPos) {
    float distb = sqrt(shadowPos.x * shadowPos.x + shadowPos.y * shadowPos.y);
    float distortFactor = distb * shadowMapBias + (1.0 - shadowMapBias);

    shadowPos.xy /= distortFactor;
    shadowPos.z *= 0.2;
    shadowPos = shadowPos * 0.5 + 0.5;
    shadowPos.z += 0.0512 / shadowMapResolution;

	return shadowPos;
}

void computeVL(inout vec3 vl, in vec3 translucent, in float dither) {
	vec3 finalVL = vec3(0.0);

	//Depth
	float z0 = texture2D(depthtex0, texCoord).r;
	
	#ifdef DISTANT_HORIZONS
	float dhZ = texture2D(dhDepthTex, texCoord).r;
	#else
	float dhZ = 0.0;
	#endif

	//Positions
	vec3 lightVec = sunVec * ((timeAngle < 0.5325 || timeAngle > 0.9675) ? 1.0 : -1.0);
	vec3 worldSunVec = mat3(gbufferModelViewInverse) * lightVec;
	vec3 viewPos = ToViewDH(texCoord, z0, dhZ);
	vec3 nViewPos = normalize(viewPos);

    //Total Visibility & Variables
    float indoorFactor = (1.0 - eBS * eBS) * float(isEyeInWater == 0 && cameraPosition.y < 1000.0);
	#if MC_VERSION >= 12104
		  indoorFactor = mix(indoorFactor, 1.0, isPaleGarden * 0.5);
	#endif

	float VoL = dot(nViewPos, lightVec);
	float VoLC = clamp(VoL, 0.0, 1.0);
		  VoLC = mix(VoLC, 0.5, 0.25 * float(isEyeInWater == 1));
	float VoLP = 1.0 + VoL;

	#ifdef OVERWORLD
	float waterFactor = 1.0 - float(isEyeInWater == 1) * 0.5;
	float denseForestFactor = min(isSwamp + isJungle, 1.0);
	float meVisRatio = (1.0 - VL_STRENGTH_RATIO) + clamp(exp(VoLC * VoLC * 0.25) * pow(VoLC, 1.3), 0.0, 1.0) * VL_STRENGTH_RATIO;
	float visibility = float(0.56 < z0) * shadowFade * VoLP * VL_STRENGTH;
		  visibility *= mix(meVisRatio, 2.0 - sunVisibility, min(timeBrightness + (1.0 - sunVisibility), 1.0));
		  visibility = mix(visibility, 0.5, indoorFactor) * waterFactor;
		  visibility *= clamp(1.0 - exp(-length(viewPos) * 0.0075), 0.0, 1.0);
	#else
	float visibility = exp(pow4(VoLC)) * 0.1;
	#endif

	#if MC_VERSION >= 11900
	visibility *= 1.0 - darknessFactor;
	#endif

	visibility *= 1.0 - blindFactor;

	if (visibility > 0) {
		//Other Variables
		#ifdef OVERWORLD
		vec3 newSkyColor = normalize(skyColor + 0.0001);
		vec3 vlColor = mix(pow(lightCol, vec3(0.85)), lightCol * newSkyColor, timeBrightness);
		#else
		vec3 vlColor = endLightColSqrt;
		#endif

		vec3 shadowCol = vec3(0.0);

		//Cloud Shadows Paramteres
		#ifdef VC_SHADOWS
		float speed = VC_SPEED;
		float amount = VC_AMOUNT;
		float frequency = VC_FREQUENCY;
		float density = VC_DENSITY;
		float height = VC_HEIGHT;
		float cloudTop = VC_HEIGHT + VC_THICKNESS + 75.0 - timeBrightness * 30.0;

		getDynamicWeather(speed, amount, frequency, density, height);

		vec2 wind = vec2(frameTimeCounter * speed * 0.005, sin(frameTimeCounter * speed * 0.1) * 0.01) * speed * 0.1;
		#endif

		//Ray Marching
		vec3 worldPos = ToWorld(viewPos);
		vec3 shadowPos = mat3(shadowModelView) * worldPos + shadowModelView[3].xyz;
			 shadowPos = diagonal3(shadowProjection) * shadowPos + shadowProjection[3].xyz;
		vec3 startPos = ToShadowProjected(vec3(0.0));
		vec3 sampleStepS = shadowPos - startPos;
		vec3 sampleStepW = worldPos - gbufferModelViewInverse[3].xyz;

		float minDistFactor = 8.0;
		float maxDistFactor = shadowDistance + 256.0;
		#ifdef DISTANT_HORIZONS
			  maxDistFactor += min(dhRenderDistance, 512.0);
		#endif
			  maxDistFactor = mix(maxDistFactor, 64.0, float(isEyeInWater == 1));
		float maxDist = min(length(sampleStepW), maxDistFactor) / length(sampleStepW);

		sampleStepS *= maxDist;
		sampleStepW *= maxDist;

		#ifdef OVERWORLD
		int sampleCount = int(VL_SAMPLES + 2 * mefade);
		#ifdef DISTANT_HORIZONS
			sampleCount += 4;
		#endif
		#else
		int sampleCount = VL_SAMPLES;
		#endif

		vec3 rayShadowPos = startPos;
		vec3 rayWorldPos = vec3(0.0);

		for (int i = 0; i < sampleCount; i++) {
			float currentDist = (pow(minDistFactor, float(i + dither) / float(sampleCount)) / minDistFactor - 1.0 / minDistFactor) / (1.0 - 1.0 / minDistFactor);

			rayWorldPos = gbufferModelViewInverse[3].xyz + cameraPosition + currentDist * sampleStepW;
			rayShadowPos = startPos.xyz + currentDist * sampleStepS;
			rayShadowPos = distortShadow(rayShadowPos);

			float shadow0 = 0.0;
			float shadow1 = 0.0;

			if (length(rayShadowPos.xy * 2.0 - 1.0) < 1.0) {
				shadow0 = texture2DShadow(shadowtex0, rayShadowPos);

				#ifdef SHADOW_COLOR
				if (shadow0 < 1.0) {
					shadow1 = texture2DShadow(shadowtex1, rayShadowPos);
					if (shadow1 > 0.0) {
						shadowCol = texture2D(shadowcolor0, rayShadowPos.xy).rgb;
					}
				}
				#endif
			}

			vec3 shadow = clamp(shadow1 * pow2(shadowCol) + shadow0 * vlColor * float(isEyeInWater == 0), 0.0, 8.0);

			//Crepuscular rays
			#ifdef VC_SHADOWS
			if (rayWorldPos.y < cloudTop) {
				vec3 cloudShadowPos = rayWorldPos + (worldSunVec / max(abs(worldSunVec.y), 0.0)) * max(cloudTop - rayWorldPos.y, 0.0);

				float noise = 0.0;
				getCloudShadow(cloudShadowPos.xz, wind, amount, frequency, density, noise);
				shadow *= noise;
			}
			shadow *= 1.0 - min((rayWorldPos.y - VC_THICKNESS) * (1.0 / cloudTop), 1.0);
			#endif

			finalVL += shadow;
		}
		finalVL *= visibility;
		finalVL /= sampleCount;

		if (isEyeInWater == 1.0) finalVL *= mix(waterColorSqrt, waterColorSqrt * weatherCol, wetness) * (4.0 + sunVisibility * 8.0);

		vl += finalVL;
	}
}