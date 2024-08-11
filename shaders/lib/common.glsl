//Huge thanks to Capt Tatsu, SixthSurge and others for allowing me to use parts of their code. You made this shader possible :P

#define SOLAS_BY_SEPTONIOUS 0 //[0]

////////////// S H A D E R S E T T I N G S //////////////

const int shadowMapResolution = 1536; //[512 1024 1536 2048 3072]
const float shadowDistance = 192.0; //[128.0 192.0 256.0 320.0 384.0 448.0 512.0]
const float entityShadowDistanceMul = 0.05; // [0.05 0.10 1.50 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.0]
#ifndef END
const float sunPathRotation = -40.0; //[-85.0 -80.0 -75.0 -70.0 -65.0 -60.0 -55.0 -50.0 -45.0 -40.0 -35.0 -30.0 -25.0 -20.0 -15.0 -10.0 -5.0 0.0 5.0 10.0 15.0 20.0 25.0 30.0 35.0 40.0 45.0 50.0 55.0 60.0 65.0 70.0 75.0 80.0 85.0]
#else
const float sunPathRotation = -40.0;
#endif
const float shadowMapBias = 1.0 - 25.6 / shadowDistance;

#define SHADOW_COLOR
//#define VPS
#define VPS_BLUR_STRENGTH 0.55 //[0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80]
//#define ENTITY_SHADOWS

//Tonemap//
#define LIGHTNESS_INTENSITY 0.28 //[0.10 0.12 0.14 0.16 0.18 0.20 0.22 0.24 0.26 0.28 0.30 0.32 0.34 0.36 0.38 0.40 0.42 0.44 0.46 0.48 0.50]
#define DARKNESS_INTENSITY 0.10 //[0.04 0.06 0.08 0.10 0.12 0.14 0.16 0.18 0.20]
#define CONTRAST 0.016 //[0.010 0.012 0.014 0.016 0.018 0.020 0.022 0.024 0.026 0.028 0.030]

//Atmosphere//
#define STARS
#define STAR_BRIGHTNESS 0.75 //[0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00]
#define STAR_AMOUNT 1.2 //[0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]

#define AURORA
#define AURORA_BRIGHTNESS 0.5 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define AURORA_COLD_BIOME_VISIBILITY
#define AURORA_FULL_MOON_VISIBILITY

#define MILKY_WAY
#define MILKY_WAY_BRIGHTNESS 2.00 //[0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00]

#define RAINBOW
#define RAINBOW_BRIGHTNESS 2.00 //[0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]

//#define SKYBOX
#define SKYBOX_MIX_FACTOR 0.5 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SKYBOX_BRIGHTNESS 1.00 //[0.50 0.75 1.00 1.25 1.50 1.75 2.00]

#define END_NEBULA
#define END_NEBULA_BRIGHTNESS 1.25 //[0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00]
#define END_VORTEX
#define END_VORTEX_ARMS 5.0 //[4.0 5.0 6.0 7.0 8.0]
#define END_VORTEX_WHIRL 20.0 //[16.0 18.0 20.0 22.0 24.0 26.0 28.0 30.0 32.0]
#define END_STARS

//Planar Clouds
#define PLANAR_CLOUDS
#define PLANAR_CLOUDS_BRIGHTNESS 1.1 //[0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define PLANAR_CLOUDS_OPACITY 0.8 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

//Volumetric Clouds
#define VC
#define VC_FREQUENCY 0.7 //[0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define VC_DENSITY 8.0 //[4.0 6.0 8.0 10.0 12.0 14.0 16.0]
#define VC_AMOUNT 13.0 //[14.0 13.5 13.0 12.5 12.0 11.5 11.0 10.5 10.0]
#define VC_HEIGHT 170.0 //[10.0 20.0 30.0 40.0 50.0 60.0 70.0 80.0 90.0 100.0 110.0 120.0 130.0 140.0 150.0 160.0 170.0 180.0 190.0 200.0 210.0 220.0 230.0 240.0 250.0]
#define VC_THICKNESS 18.0 //[8.0 10.0 12.0 14.0 16.0 18.0 20.0]
#define VC_DETAIL 1.5 //[1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define VC_SPEED 1.00 //[0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.50 3.00 3.50 4.00]
#define VC_OPACITY 0.8 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define VC_DISTANCE 1000.0 //[500.0 600.0 700.0 800.0 900.0 1000.0 1100.0 1200.0 1300.0 1400.0 1500.0]
//#define VC_SHADOWS
//#define BLOCKY_CLOUDS

//VL//
#define VL
#define VL_STRENGTH 1.75 //[0.00 0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]
#define VL_SAMPLES 7 //[4 5 6 7 8 9 10]
#define VL_CLOUDY_FOG

//LPV Fog//
#define LPV_FOG
#define LPV_FOG_STRENGTH 0.7 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LPV_FOG_SAMPLES 6 //[4 5 6 7 8 9 10]

//Nether Cloudy Fog//
#define NETHER_CLOUDY_FOG
#define VF_NETHER_STRENGTH 1.5 //[0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5]
#define VF_NETHER_FREQUENCY 3.00 //[2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]
#define VF_NETHER_SPEED 6.00 //[1.00 1.50 2.00 2.50 3.00 3.50 4.00 4.50 5.00 5.50 6.00 6.50 7.00 7.50 8.00]

//End Cloudy Fog//
#define END_CLOUDY_FOG
#define VF_END_HEIGHT -30.0 //[-20.0 -10.0 0.0 10.0 20.0 30.0 40.0]
#define VF_END_AMOUNT 8.5 //[7.5 8.0 8.5 9.0 9.5 10.0]
#define VF_END_THICKNESS 10.0 //[4.0 6.0 8.0 10.0 12.0 14.0 16.0 18.0 20.0 22.0 24.0]
#define VF_END_OPACITY 0.7 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

//Fog//
#define DISTANT_FADE
#define DISTANT_FADE_STYLE 0 //[0 1]
#define FOG_DISTANCE 90 //[10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 110 120 130 140 150 160 170 180 190 200]
#define FOG_DENSITY 1.2 //[0.0 0.2 0.4 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0]
#define FOG_HEIGHT 100.0 //[50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210 220 230 240 250]

//Bloom//
#define BLOOM
#define BLOOM_STRENGTH 1.00 //[0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00]
#define BLOOM_CONTRAST 2 //[-4 -3 -2 -1 0 1 2 3 4]
#define BLOOM_TILE_SIZE 1.0 //[0.0 0.5 1.0 1.5 2.0]

//Vanilla AO//
#define VANILLA_AO
#define AO
#define AO_RADIUS 0.5 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define AO_STRENGTH 0.5 //[0.5 0.6 0.7 0.8 0.9 1.0]

//Fireflies//
//#define FIREFLIES
#define FIREFLIES_BRIGHTNESS 5.00 //[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00 4.25 4.50 4.75 5.00 5.25 5.50 5.75 6.00]

//Floodfill//
#define VOXEL_VOLUME_SIZE 128 //[64 128 256 512]
//#define EMISSIVE_CONCRETE
#define EMISSIVE_FLOWERS
#define EMISSIVE_ORES
#define FLOODFILL_BRIGHTNESS 1.00 //[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]
#define FLOODFILL_RADIUS 1.4 //[0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7]
#define DYNAMIC_HANDLIGHT
#define DYNAMIC_HANDLIGHT_STRENGTH 1.50 //[0.50 0.75 1.00 1.25 1.50 1.75 2.00]

//RSM GI//
//#define GI
#define GI_SAMPLES 6 //[4 5 6 7 8 9 10 11 12 13 14 15 16]
#define GI_RADIUS 32.0 //[16.0 24.0 32.0 48.0 64.0 80.0 96.0 112.0 128.0]
#define GI_BRIGHTNESS 1.0 //[1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0]

//Depth of Field & Distant Blur//
//#define DOF
#define DOF_STRENGTH 3.00 //[0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]
//#define DISTANT_BLUR
#define DISTANT_BLUR_STRENGTH 2.0 //[1.0 1.5 2.0 2.5 3.0 3.5 4.0]
#define DISTANT_BLUR_RANGE 4 //[1 2 3 4 5 6 7 8]

//Motion Blur//
//#define MOTION_BLUR
#define MOTION_BLUR_STRENGTH 0.50 //[0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]

//Antialiasing//
//#define FXAA
#define FXAA_SUBPIXEL 0.75 //[0.00 0.25 0.50 0.75 1.00]
#define FXAA_EDGE_SENSITIVITY 1 //[0 1 2]
#define TAA

//Other Effects//
//#define CHROMATIC_ABERRATION
#define CHROMATIC_ABERRATION_STRENGTH 1.00 //[0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00]
#define SHARPENING

//Water//
#define WATER_REFLECTIONS
#define WATER_NORMALS 1 //[0 1 2]
#define WATER_NORMAL_BUMP 0.4 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_NORMAL_OFFSET 0.5 //[0.2 0.3 0.4 0.5 0.6 0.7 0.8]
#define WATER_NORMAL_DETAIL 0.40 //[0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50]
#define WATER_NORMAL_SPEED 1.50 //[0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.50 3.00 3.50 4.00]
#define WATER_CAUSTICS
#define WATER_CAUSTICS_STRENGTH 4.00 //[1.00 1.50 2.00 2.50 3.00 3.50 4.00 4.50 5.00 5.50 6.00]
#define WATER_FOG
#define WATER_FOG_EXPONENT -6.00 //[-2.00 -3.00 -4.00 -5.00 -6.00 -7.00 -8.00]
#define REFRACTION
#define REFRACTION_STRENGTH 0.6 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

//PBR//
#define GENERATED_EMISSION
#define EMISSION_STRENGTH 3.00 //[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]
#define GENERATED_NORMALS
#define GENERATED_SPECULAR
#define RAIN_PUDDLES
#define RAIN_PUDDLES_STRENGTH 1.00 //[0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00]
#define NORMAL_STRENGTH 3.0 //[1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0]
#define NORMAL_RESOLUTION 128.0 //[64.0 96.0 128.0 160.0 192.0]
#define NORMAL_THRESHOLD 0.15 //[0.05 0.10 0.15 0.20 0.25]

//PBR//
//#define PBR
#define MATERIAL_FORMAT 1 //[0 1]

//#define PARALLAX
#define PARALLAX_DEPTH 0.20 //[0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50]
#define PARALLAX_QUALITY 64 //[32 48 64 80 96 112 128]
#define PARALLAX_DISTANCE 32 //[8 16 32 48 64 80 96 112 128]
#define SELF_SHADOW
#define SELF_SHADOW_ANGLE 3.0 //[0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0]
#define SELF_SHADOW_QUALITY 6 //[4 6 8 10 12 14 16]
#define SELF_SHADOW_STRENGTH 48 //[4 8 16 32 48 64]

//Waving//
#define WAVING_PLANTS
#define WAVING_LEAVES
#define WAVING_AMPLITUDE 2.50 //[1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00]
#define WAVING_SPEED 1.2 //[0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]

//Colors//
#define LIGHTTEMP_SS 2500 //[2500 2750 3000 3250 3500]
#define LIGHTTEMP_ME 4750 //[4500 4750 5000 5250 5500]
#define LIGHTTEMP_D 5750 //[5500 5750 6000 6250 6500]
#define LIGHTTEMP_N 11750 //[11000 11250 11500 11750 12000]

#define LIGHTINTENSITY_SS 1.3 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define LIGHTINTENSITY_ME 1.5 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define LIGHTINTENSITY_D 1.5 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define LIGHTINTENSITY_N 0.6 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define AMBIENTINTENSITY_D 1.10 //[0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25]
#define AMBIENTINTENSITY_N 0.60 //[0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define AMBIENTCOL_SKY_INFLUENCE 0.6 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

#define LIGHT_END_R 165 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define LIGHT_END_G 125 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define LIGHT_END_B 255 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define LIGHT_END_I 0.90 //[0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.55 1.60 1.65 1.70 1.75 1.80 1.85 1.90 1.95 2.00 2.05 2.10 2.15 2.20 2.25 2.30 2.35 2.40 2.45 2.50 2.55 2.60 2.65 2.70 2.75 2.80 2.85 2.90 2.95 3.00]

#define AMBIENT_END_R 205 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define AMBIENT_END_G 145 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define AMBIENT_END_B 255 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define AMBIENT_END_I 0.30 //[0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.55 1.60 1.65 1.70 1.75 1.80 1.85 1.90 1.95 2.00 2.05 2.10 2.15 2.20 2.25 2.30 2.35 2.40 2.45 2.50 2.55 2.60 2.65 2.70 2.75 2.80 2.85 2.90 2.95 3.00]

#define WEATHER_RR 175 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define WEATHER_RG 185 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define WEATHER_RB 255 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define WEATHER_RI 0.60 //[0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.55 1.60 1.65 1.70 1.75 1.80 1.85 1.90 1.95 2.00 2.05 2.10 2.15 2.20 2.25 2.30 2.35 2.40 2.45 2.50 2.55 2.60 2.65 2.70 2.75 2.80 2.85 2.90 2.95 3.00]

#define BLOCKLIGHT_R 245 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define BLOCKLIGHT_G 195 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define BLOCKLIGHT_B 135 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define BLOCKLIGHT_I 1.00 //[0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.55 1.60 1.65 1.70 1.75 1.80 1.85 1.90 1.95 2.00 2.05 2.10 2.15 2.20 2.25 2.30 2.35 2.40 2.45 2.50 2.55 2.60 2.65 2.70 2.75 2.80 2.85 2.90 2.95 3.00 3.05 3.10 3.15 3.20 3.25 3.30 3.35 3.40 3.45 3.50 3.55 3.60 3.65 3.70 3.75 3.80 3.85 3.90 3.95 4.00]

#define WATER_R 115 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define WATER_G 200 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define WATER_B 250 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define WATER_I 0.80 //[0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define WATER_A 0.70 //[0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95]

#define MINLIGHT_R 125 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define MINLIGHT_G 130 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define MINLIGHT_B 135 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define MINLIGHT_I 0.40 //[0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

////////////// V A R I A B L E S //////////////
#define PI 3.14
#define TAU 6.28

//Blocklight Color//
const vec3 blockLightColSqrt = vec3(BLOCKLIGHT_R, BLOCKLIGHT_G, BLOCKLIGHT_B) * BLOCKLIGHT_I / 255.0;
const vec3 blockLightCol = blockLightColSqrt * blockLightColSqrt;

//Minlight Color//
const vec3 minLightColSqrt = vec3(MINLIGHT_R, MINLIGHT_G, MINLIGHT_B) * MINLIGHT_I / 255.0;
const vec3 minLightCol = minLightColSqrt * minLightColSqrt * 0.1;
const vec3 caveMinLightCol = vec3(0.3, 0.4, 0.55) * 0.125;

//End Color//
const vec3 endLightColSqrt = vec3(LIGHT_END_R, LIGHT_END_G, LIGHT_END_B) / 255.0 * LIGHT_END_I;
const vec3 endLightCol = endLightColSqrt * endLightColSqrt;
const vec3 endAmbientColSqrt = vec3(AMBIENT_END_R, AMBIENT_END_G, AMBIENT_END_B) / 255.0 * AMBIENT_END_I;
const vec3 endAmbientCol = endAmbientColSqrt * endAmbientColSqrt;

//Water Color//
const vec3 waterColorSqrt = vec3(WATER_R, WATER_G, WATER_B) / 255.0 * WATER_I;
const vec3 waterColor = waterColorSqrt * waterColorSqrt;

//Weather Color//
const vec3 weatherCol = vec3(WEATHER_RR, WEATHER_RG, WEATHER_RB) / 255.0 * WEATHER_RI;

////////////// F U N C T I O N S //////////////
float pow2(float x) {return x*x;}
float pow3(float x) {return x*x*x;}
float pow4(float x) {return x*x*x*x;}
float pow5(float x) {return x*x*x*x*x;}
float pow6(float x) {return x*x*x*x*x*x;}
float pow7(float x) {return x*x*x*x*x*x*x;}
float pow8(float x) {return x*x*x*x*x*x*x*x;}
float pow9(float x) {return x*x*x*x*x*x*x*x*x;}
float pow10(float x) {return x*x*x*x*x*x*x*x*x*x;}
float pow11(float x) {return x*x*x*x*x*x*x*x*x*x*x;}
float pow12(float x) {return x*x*x*x*x*x*x*x*x*x*x*x;}
float pow13(float x) {return x*x*x*x*x*x*x*x*x*x*x*x*x;}
float pow14(float x) {return x*x*x*x*x*x*x*x*x*x*x*x*x*x;}
float pow15(float x) {return x*x*x*x*x*x*x*x*x*x*x*x*x*x*x;}
float pow16(float x) {return x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x;}
float pow17(float x) {return x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x;}
float pow18(float x) {return x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x;}
float pow19(float x) {return x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x;}
float pow20(float x) {return x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x;}
float pow24(float x) {return x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x;}
float pow32(float x) {return x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x;}

vec2 pow2(vec2 x) {return x*x;}
vec2 pow3(vec2 x) {return x*x*x;}
vec2 pow4(vec2 x) {return x*x*x*x;}
vec2 pow5(vec2 x) {return x*x*x*x*x;}
vec2 pow6(vec2 x) {return x*x*x*x*x*x;}
vec2 pow7(vec2 x) {return x*x*x*x*x*x*x;}
vec2 pow8(vec2 x) {return x*x*x*x*x*x*x*x;}

vec3 pow2(vec3 x) {return x*x;}
vec3 pow3(vec3 x) {return x*x*x;}
vec3 pow4(vec3 x) {return x*x*x*x;}
vec3 pow5(vec3 x) {return x*x*x*x*x;}
vec3 pow6(vec3 x) {return x*x*x*x*x*x;}
vec3 pow7(vec3 x) {return x*x*x*x*x*x*x;}
vec3 pow8(vec3 x) {return x*x*x*x*x*x*x*x;}

vec3 getSunVector(mat4 gbufferModelView, float timeAngle) {
	#if defined OVERWORLD
	const vec2 sunRotationData = vec2(cos(sunPathRotation * 0.01745329251994), -sin(sunPathRotation * 0.01745329251994));
	float ang = fract(timeAngle - 0.25);
	ang = (ang + (cos(ang * PI) * -0.5 + 0.5 - ang) / 3.0) * TAU;
	return normalize((gbufferModelView * vec4(vec3(-sin(ang), cos(ang) * sunRotationData) * 2000.0, 1.0)).xyz);
	#elif defined END
	const vec2 sunRotationData = vec2(cos(sunPathRotation * 0.01745329251994), -sin(sunPathRotation * 0.01745329251994));
	return normalize((gbufferModelView * vec4(vec3(0.0, sunRotationData * 2000.0), 1.0)).xyz);
	#else
	return vec3(0.0);
	#endif
}

float minOf(vec3 v) { return min(min(v.x, v.y), v.z); }
float maxOf(vec3 v) { return max(max(v.x, v.y), v.z); }

float linearStep(float edge0, float edge1, float x) {
	return clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
}

////////////// S H E N A N I G A N S //////////////

#ifdef PARALLAX
#undef GENERATED_NORMALS
#endif

#ifdef PBR
#undef GENERATED_SPECULAR
#endif

#ifndef OVERWORLD
#undef MILKY_WAY
#undef RAINBOW
#undef AURORA
#undef VC
#undef STARS
#undef PLANAR_CLOUDS
#undef RAIN_PUDDLES
#undef WAVING_PLANTS
#undef WAVING_LEAVES
#undef FIREFLIES
#undef GI
#endif

#ifndef NETHER
#undef NETHER_CLOUDY_FOG
#endif

#ifndef END
#undef END_NEBULA
#undef END_VORTEX
#undef END_CLOUDY_FOG
#endif

#ifdef NETHER
#undef VL
#endif

#ifdef VC_SHADOWS
#endif

#if !defined GBUFFERS_TERRAIN
#undef VPS
#endif

#ifdef GBUFFERS_BASIC
#undef DYNAMIC_HANDLIGHT
#endif

#if !defined AURORA_COLD_BIOME_VISIBILITY && !defined AURORA_FULL_MOON_VISIBILITY
#define AURORA_ALWAYS_VISIBLE
#endif

#ifdef RAIN_PUDDLES
#endif

#ifdef ENTITY_SHADOWS
#endif

#if defined IS_IRIS && !defined MC_OS_MAC
#define VX_SUPPORT
#endif

#ifndef VX_SUPPORT
#undef LPV_FOG
#endif