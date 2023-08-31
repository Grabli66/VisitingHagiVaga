#ifndef _COMPILED_GLSL_
#define _COMPILED_GLSL_
#define _Irr
#define _Rad
#define _Deferred
#define _Sun
#define _Clusters
#define _Brdf
#define _EmissionShaded
#define _Deferred
#define _Clusters
#define _Deferred
#define _Clusters
#define _CToneFilmic
#define GBUF_SIZE 3
#define GBUF_IDX_0 0
#define GBUF_IDX_1 1
#define GBUF_IDX_EMISSION 2
#if defined(HLSL) || defined(METAL)
#define _InvY
#endif
#define _FlipY
const float PI = 3.1415926535;
const float PI2 = PI * 2.0;
const vec2 shadowmapSize = vec2(0, 0);
const float shadowmapCubePcfSize = 0.001;
const int shadowmapCascades = 4;
const int skinMaxBones = 65;
const int maxLights = 4;
const int maxLightsCluster = 4;
const float clusterNear = 3.0;

#endif // _COMPILED_GLSL_
