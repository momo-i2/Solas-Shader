//Settings//
#include "/lib/common.glsl"

#ifdef FSH

//Varyings//
in vec2 texCoord;

//Uniforms//
#ifdef BLOOM
#ifdef TAA
uniform int frameCounter;
#endif

uniform float viewWidth, viewHeight;
#endif

uniform sampler2D noisetex;
uniform sampler2D colortex0;

#ifdef TAA
uniform sampler2D colortex2;
#endif

uniform sampler2D depthtex0;

#ifdef BLOOM
uniform sampler2D colortex1;

uniform mat4 gbufferProjectionInverse;
#endif

//Optifine Constants//
#ifdef TAA
const bool colortex2Clear = false;
#endif

#ifdef BLOOM
const bool colortex1MipmapEnabled = true;
#endif

//Includes//
#include "/lib/util/bayerDithering.glsl"
#include "/lib/post/tonemap.glsl"

#ifdef BLOOM
#include "/lib/post/getBloom.glsl"
#endif

//Program//
void main() {
	vec3 color = texture2D(colortex0, texCoord).rgb;

	float blueNoiseDither = texture2D(noisetex, gl_FragCoord.xy / 512.0).b;
	float z0 = texture2D(depthtex0, texCoord).r;

	#ifdef BLOOM
	#ifdef TAA
	blueNoiseDither = fract(blueNoiseDither + 1.61803398875 * mod(float(frameCounter), 3600.0));
	#endif

	vec3 rawBloom = getBloom(texCoord, blueNoiseDither, z0);

	float intensity = BLOOM_STRENGTH;

	#if BLOOM_CONTRAST == 0
	color = mix(color, rawBloom, 0.1 * intensity);
	#else
	vec3 bloomContrast = vec3(exp2(BLOOM_CONTRAST * 0.25));
	color = pow(color, bloomContrast);

	vec3 bloomStrength = pow(vec3(0.1 * intensity), bloomContrast);
	color = mix(color, pow(rawBloom, bloomContrast), bloomStrength);
	color = pow(color, 1.0 / bloomContrast);
	#endif
	#endif

    //Tonemapping & Film Grain
	BSLTonemap(color);
	color = pow(color, vec3(1.0 / 2.2));
	ColorSaturation(color);
	color += (blueNoiseDither - 0.5) / 64.0;

	//TAA
	#ifdef TAA
	vec3 tempData = texture2D(colortex2, texCoord).gba;
	#endif

	/* DRAWBUFFERS:1 */
	gl_FragData[0].rgb = color;

	#ifdef TAA
	/* DRAWBUFFERS:12 */
	gl_FragData[1].gba = tempData;
	#endif
}

#endif

/////////////////////////////////////////////////////////////////////////////////////

#ifdef VSH

//Varyings//
out vec2 texCoord;

//Program//
void main() {
	//Coord
	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

	//Position
	gl_Position = ftransform();
}


#endif