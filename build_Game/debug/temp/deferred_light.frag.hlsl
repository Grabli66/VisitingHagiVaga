uniform float4 casData[20];
TextureCube<float4> shadowMapPoint[1] : register(t0);
SamplerComparisonState _shadowMapPoint_sampler[1] : register(s0);
uniform float2 lightProj;
Texture2D<float4> gbuffer0 : register(t1);
SamplerState _gbuffer0_sampler : register(s1);
Texture2D<float4> gbuffer1 : register(t2);
SamplerState _gbuffer1_sampler : register(s2);
Texture2D<float4> gbufferD : register(t3);
SamplerState _gbufferD_sampler : register(s3);
uniform float3 eye;
uniform float3 eyeLook;
uniform float2 cameraProj;
Texture2D<float4> senvmapBrdf : register(t4);
SamplerState _senvmapBrdf_sampler : register(s4);
uniform float4 shirr[7];
uniform int envmapNumMipmaps;
Texture2D<float4> senvmapRadiance : register(t5);
SamplerState _senvmapRadiance_sampler : register(s5);
uniform float envmapStrength;
uniform float3 sunDir;
Texture2D<float4> shadowMap : register(t6);
SamplerComparisonState _shadowMap_sampler : register(s6);
uniform float shadowsBias;
uniform float3 sunCol;
uniform float3 pointPos;
uniform float3 pointCol;
uniform float pointBias;

static float2 texCoord;
static float3 viewRay;
static float4 fragColor;

struct SPIRV_Cross_Input
{
    float2 texCoord : TEXCOORD0;
    float3 viewRay : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 fragColor : SV_Target0;
};

float2 octahedronWrap(float2 v)
{
    return (1.0f.xx - abs(v.yx)) * float2((v.x >= 0.0f) ? 1.0f : (-1.0f), (v.y >= 0.0f) ? 1.0f : (-1.0f));
}

void unpackFloatInt16(float val, out float f, out uint i)
{
    uint bitsValue = uint(val);
    i = bitsValue >> 12u;
    f = float(bitsValue & 4294905855u) / 4095.0f;
}

float2 unpackFloat2(float f)
{
    return float2(floor(f) / 255.0f, frac(f));
}

float3 surfaceAlbedo(float3 baseColor, float metalness)
{
    return lerp(baseColor, 0.0f.xxx, metalness.xxx);
}

float3 surfaceF0(float3 baseColor, float metalness)
{
    return lerp(0.039999999105930328369140625f.xxx, baseColor, metalness.xxx);
}

float3 getPos(float3 eye_1, float3 eyeLook_1, float3 viewRay_1, float depth, float2 cameraProj_1)
{
    float linearDepth = cameraProj_1.y / (((depth * 0.5f) + 0.5f) - cameraProj_1.x);
    float viewZDist = dot(eyeLook_1, viewRay_1);
    float3 wposition = eye_1 + (viewRay_1 * (linearDepth / viewZDist));
    return wposition;
}

float3 shIrradiance(float3 nor, float4 shirr_1[7])
{
    float3 cl00 = float3(shirr_1[0].x, shirr_1[0].y, shirr_1[0].z);
    float3 cl1m1 = float3(shirr_1[0].w, shirr_1[1].x, shirr_1[1].y);
    float3 cl10 = float3(shirr_1[1].z, shirr_1[1].w, shirr_1[2].x);
    float3 cl11 = float3(shirr_1[2].y, shirr_1[2].z, shirr_1[2].w);
    float3 cl2m2 = float3(shirr_1[3].x, shirr_1[3].y, shirr_1[3].z);
    float3 cl2m1 = float3(shirr_1[3].w, shirr_1[4].x, shirr_1[4].y);
    float3 cl20 = float3(shirr_1[4].z, shirr_1[4].w, shirr_1[5].x);
    float3 cl21 = float3(shirr_1[5].y, shirr_1[5].z, shirr_1[5].w);
    float3 cl22 = float3(shirr_1[6].x, shirr_1[6].y, shirr_1[6].z);
    return ((((((((((cl22 * 0.429042994976043701171875f) * ((nor.y * nor.y) - ((-nor.z) * (-nor.z)))) + (((cl20 * 0.743125021457672119140625f) * nor.x) * nor.x)) + (cl00 * 0.88622701168060302734375f)) - (cl20 * 0.2477079927921295166015625f)) + (((cl2m2 * 0.85808598995208740234375f) * nor.y) * (-nor.z))) + (((cl21 * 0.85808598995208740234375f) * nor.y) * nor.x)) + (((cl2m1 * 0.85808598995208740234375f) * (-nor.z)) * nor.x)) + ((cl11 * 1.02332794666290283203125f) * nor.y)) + ((cl1m1 * 1.02332794666290283203125f) * (-nor.z))) + ((cl10 * 1.02332794666290283203125f) * nor.x);
}

float getMipFromRoughness(float roughness, float numMipmaps)
{
    return roughness * numMipmaps;
}

float2 envMapEquirect(float3 normal)
{
    float phi = acos(normal.z);
    float theta = atan2(-normal.y, normal.x) + 3.1415927410125732421875f;
    return float2(theta / 6.283185482025146484375f, phi / 3.1415927410125732421875f);
}

float3 lambertDiffuseBRDF(float3 albedo, float nl)
{
    return albedo * nl;
}

float d_ggx(float nh, float a)
{
    float a2 = a * a;
    float denom = ((nh * nh) * (a2 - 1.0f)) + 1.0f;
    denom = max(denom * denom, 6.103515625e-05f);
    return (a2 * 0.3183098733425140380859375f) / denom;
}

float g2_approx(float NdotL, float NdotV, float alpha)
{
    float2 helper = (float2(NdotL, NdotV) * 2.0f) * (1.0f.xx / ((float2(NdotL, NdotV) * (2.0f - alpha)) + alpha.xx));
    return max(helper.x * helper.y, 0.0f);
}

float3 f_schlick(float3 f0, float vh)
{
    return f0 + ((1.0f.xxx - f0) * exp2((((-5.554729938507080078125f) * vh) - 6.9831600189208984375f) * vh));
}

float3 specularBRDF(float3 f0, float roughness, float nl, float nh, float nv, float vh)
{
    float a = roughness * roughness;
    return (f_schlick(f0, vh) * (d_ggx(nh, a) * g2_approx(nl, nv, a))) / max(4.0f * nv, 9.9999997473787516355514526367188e-06f).xxx;
}

float4x4 getCascadeMat(float d, inout int casi, inout int casIndex)
{
    float4 comp = float4(float(d > casData[16].x), float(d > casData[16].y), float(d > casData[16].z), float(d > casData[16].w));
    casi = int(min(dot(1.0f.xxxx, comp), 4.0f));
    casIndex = casi * 4;
    return float4x4(float4(casData[casIndex]), float4(casData[casIndex + 1]), float4(casData[casIndex + 2]), float4(casData[casIndex + 3]));
}

float PCF(Texture2D<float4> shadowMap_1, SamplerComparisonState _shadowMap_1_sampler, float2 uv, float compare, float2 smSize)
{
    float3 _451 = float3(uv + ((-1.0f).xx / smSize), compare);
    float result = shadowMap_1.SampleCmp(_shadowMap_1_sampler, _451.xy, _451.z);
    float3 _460 = float3(uv + (float2(-1.0f, 0.0f) / smSize), compare);
    result += shadowMap_1.SampleCmp(_shadowMap_1_sampler, _460.xy, _460.z);
    float3 _471 = float3(uv + (float2(-1.0f, 1.0f) / smSize), compare);
    result += shadowMap_1.SampleCmp(_shadowMap_1_sampler, _471.xy, _471.z);
    float3 _482 = float3(uv + (float2(0.0f, -1.0f) / smSize), compare);
    result += shadowMap_1.SampleCmp(_shadowMap_1_sampler, _482.xy, _482.z);
    float3 _490 = float3(uv, compare);
    result += shadowMap_1.SampleCmp(_shadowMap_1_sampler, _490.xy, _490.z);
    float3 _501 = float3(uv + (float2(0.0f, 1.0f) / smSize), compare);
    result += shadowMap_1.SampleCmp(_shadowMap_1_sampler, _501.xy, _501.z);
    float3 _512 = float3(uv + (float2(1.0f, -1.0f) / smSize), compare);
    result += shadowMap_1.SampleCmp(_shadowMap_1_sampler, _512.xy, _512.z);
    float3 _523 = float3(uv + (float2(1.0f, 0.0f) / smSize), compare);
    result += shadowMap_1.SampleCmp(_shadowMap_1_sampler, _523.xy, _523.z);
    float3 _534 = float3(uv + (1.0f.xx / smSize), compare);
    result += shadowMap_1.SampleCmp(_shadowMap_1_sampler, _534.xy, _534.z);
    return result / 9.0f;
}

float shadowTestCascade(Texture2D<float4> shadowMap_1, SamplerComparisonState _shadowMap_1_sampler, float3 eye_1, float3 p, float shadowsBias_1)
{
    float d = distance(eye_1, p);
    int param;
    int param_1;
    float4x4 _780 = getCascadeMat(d, param, param_1);
    int casi = param;
    int casIndex = param_1;
    float4x4 LWVP = _780;
    float4 lPos = mul(float4(p, 1.0f), LWVP);
    float3 _795 = lPos.xyz / lPos.w.xxx;
    lPos = float4(_795.x, _795.y, _795.z, lPos.w);
    float visibility = 1.0f;
    if (lPos.w > 0.0f)
    {
        visibility = PCF(shadowMap_1, _shadowMap_1_sampler, lPos.xy, lPos.z - shadowsBias_1, float2(4096.0f, 1024.0f));
    }
    float nextSplit = casData[16][casi];
    float _820;
    if (casi == 0)
    {
        _820 = nextSplit;
    }
    else
    {
        _820 = nextSplit - casData[16][casi - 1];
    }
    float splitSize = _820;
    float splitDist = (nextSplit - d) / splitSize;
    if ((splitDist <= 0.1500000059604644775390625f) && (casi != 3))
    {
        int casIndex2 = casIndex + 4;
        float4x4 LWVP2 = float4x4(float4(casData[casIndex2]), float4(casData[casIndex2 + 1]), float4(casData[casIndex2 + 2]), float4(casData[casIndex2 + 3]));
        float4 lPos2 = mul(float4(p, 1.0f), LWVP2);
        float3 _898 = lPos2.xyz / lPos2.w.xxx;
        lPos2 = float4(_898.x, _898.y, _898.z, lPos2.w);
        float visibility2 = 1.0f;
        if (lPos2.w > 0.0f)
        {
            visibility2 = PCF(shadowMap_1, _shadowMap_1_sampler, lPos2.xy, lPos2.z - shadowsBias_1, float2(4096.0f, 1024.0f));
        }
        float lerpAmt = smoothstep(0.0f, 0.1500000059604644775390625f, splitDist);
        return lerp(visibility2, visibility, lerpAmt);
    }
    return visibility;
}

float attenuate(float dist)
{
    return 1.0f / (dist * dist);
}

float lpToDepth(inout float3 lp, float2 lightProj_1)
{
    lp = abs(lp);
    float zcomp = max(lp.x, max(lp.y, lp.z));
    zcomp = lightProj_1.x - (lightProj_1.y / zcomp);
    return (zcomp * 0.5f) + 0.5f;
}

float PCFCube(TextureCube<float4> shadowMapCube, SamplerComparisonState _shadowMapCube_sampler, float3 lp, inout float3 ml, float bias, float2 lightProj_1, float3 n)
{
    float3 param = lp;
    float _567 = lpToDepth(param, lightProj_1);
    float compare = _567 - (bias * 1.5f);
    ml += ((n * bias) * 20.0f);
    ml.y = -ml.y;
    float4 _587 = float4(ml, compare);
    float result = shadowMapCube.SampleCmp(_shadowMapCube_sampler, _587.xyz, _587.w);
    float4 _599 = float4(ml + 0.001000000047497451305389404296875f.xxx, compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _599.xyz, _599.w);
    float4 _613 = float4(ml + float3(-0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _613.xyz, _613.w);
    float4 _626 = float4(ml + float3(0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _626.xyz, _626.w);
    float4 _639 = float4(ml + float3(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _639.xyz, _639.w);
    float4 _652 = float4(ml + float3(-0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _652.xyz, _652.w);
    float4 _665 = float4(ml + float3(0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _665.xyz, _665.w);
    float4 _678 = float4(ml + float3(-0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, -0.001000000047497451305389404296875f), compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _678.xyz, _678.w);
    float4 _691 = float4(ml + (-0.001000000047497451305389404296875f).xxx, compare);
    result += shadowMapCube.SampleCmp(_shadowMapCube_sampler, _691.xyz, _691.w);
    return result / 9.0f;
}

float3 sampleLight(float3 p, float3 n, float3 v, float dotNV, float3 lp, float3 lightCol, float3 albedo, float rough, float spec, float3 f0, int index, float bias, bool receiveShadow)
{
    float3 ld = lp - p;
    float3 l = normalize(ld);
    float3 h = normalize(v + l);
    float dotNH = max(0.0f, dot(n, h));
    float dotVH = max(0.0f, dot(v, h));
    float dotNL = max(0.0f, dot(n, l));
    float3 direct = lambertDiffuseBRDF(albedo, dotNL) + (specularBRDF(f0, rough, dotNL, dotNH, dotNV, dotVH) * spec);
    direct *= attenuate(distance(p, lp));
    direct *= lightCol;
    if (receiveShadow)
    {
        float3 param = -l;
        float _975 = PCFCube(shadowMapPoint[0], _shadowMapPoint_sampler[0], ld, param, bias, lightProj, n);
        direct *= _975;
    }
    return direct;
}

void frag_main()
{
    float4 g0 = gbuffer0.SampleLevel(_gbuffer0_sampler, texCoord, 0.0f);
    float3 n;
    n.z = (1.0f - abs(g0.x)) - abs(g0.y);
    float2 _1004;
    if (n.z >= 0.0f)
    {
        _1004 = g0.xy;
    }
    else
    {
        _1004 = octahedronWrap(g0.xy);
    }
    n = float3(_1004.x, _1004.y, n.z);
    n = normalize(n);
    float roughness = g0.z;
    float param;
    uint param_1;
    unpackFloatInt16(g0.w, param, param_1);
    float metallic = param;
    uint matid = param_1;
    float4 g1 = gbuffer1.SampleLevel(_gbuffer1_sampler, texCoord, 0.0f);
    float2 occspec = unpackFloat2(g1.w);
    float3 albedo = surfaceAlbedo(g1.xyz, metallic);
    float3 f0 = surfaceF0(g1.xyz, metallic);
    float depth = (gbufferD.SampleLevel(_gbufferD_sampler, texCoord, 0.0f).x * 2.0f) - 1.0f;
    float3 p = getPos(eye, eyeLook, normalize(viewRay), depth, cameraProj);
    float3 v = normalize(eye - p);
    float dotNV = max(dot(n, v), 0.0f);
    float2 envBRDF = senvmapBrdf.Load(int3(int2(float2(dotNV, 1.0f - roughness) * 256.0f), 0)).xy;
    float3 envl = shIrradiance(n, shirr);
    float3 reflectionWorld = reflect(-v, n);
    float lod = getMipFromRoughness(roughness, float(envmapNumMipmaps));
    float3 prefilteredColor = senvmapRadiance.SampleLevel(_senvmapRadiance_sampler, envMapEquirect(reflectionWorld), lod).xyz;
    envl *= albedo;
    envl *= (1.0f.xxx - ((f0 * envBRDF.x) + envBRDF.y.xxx));
    envl += (prefilteredColor * ((f0 * envBRDF.x) + envBRDF.y.xxx));
    envl *= (envmapStrength * occspec.x);
    fragColor = float4(envl.x, envl.y, envl.z, fragColor.w);
    float3 sh = normalize(v + sunDir);
    float sdotNH = max(0.0f, dot(n, sh));
    float sdotVH = max(0.0f, dot(v, sh));
    float sdotNL = max(0.0f, dot(n, sunDir));
    float svisibility = 1.0f;
    float3 sdirect = lambertDiffuseBRDF(albedo, sdotNL) + (specularBRDF(f0, roughness, sdotNL, sdotNH, dotNV, sdotVH) * occspec.y);
    svisibility = shadowTestCascade(shadowMap, _shadowMap_sampler, eye, p + ((n * shadowsBias) * 10.0f), shadowsBias);
    float3 _1217 = fragColor.xyz + ((sdirect * svisibility) * sunCol);
    fragColor = float4(_1217.x, _1217.y, _1217.z, fragColor.w);
    int param_2 = 0;
    float param_3 = pointBias;
    bool param_4 = true;
    float3 _1242 = fragColor.xyz + sampleLight(p, n, v, dotNV, pointPos, pointCol, albedo, roughness, occspec.y, f0, param_2, param_3, param_4);
    fragColor = float4(_1242.x, _1242.y, _1242.z, fragColor.w);
    fragColor.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    texCoord = stage_input.texCoord;
    viewRay = stage_input.viewRay;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
