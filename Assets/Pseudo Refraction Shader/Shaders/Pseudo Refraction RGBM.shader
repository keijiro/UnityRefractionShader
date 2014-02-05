Shader "Custom/Pseudo Refraction RGBM"
{
    Properties
    {
        _EnvTex ("Environment", Cube) = "gray" {}
        _Exposure("Exposure", Float) = 1
        _Refraction ("Refration Index", float) = 0.9
        _Fresnel ("Fresnel Coefficient", float) = 5.0
        _Reflectance ("Reflectance", float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="TransparentButHasDepth" }
        
        CGPROGRAM

        #pragma surface surf PseudoRefraction
        #pragma multi_compile USE_GAMMA USE_LINEAR

        half4 LightingPseudoRefraction (SurfaceOutput s, half3 lightDir, half atten)
        {
            half4 c;
            c.rgb = s.Emission;
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            half3 viewDir;
            half3 worldNormal;
        };

        samplerCUBE _EnvTex;
        half _Exposure;
        half _Refraction;
        half _Fresnel;
        half _Reflectance;

        half3 SampleRGBM (half4 c)
        {
#if USE_LINEAR
            half e = c.a * _Exposure * 8.0f;
            half e2 = e * e;
            half lin_e = dot(half2(0.7532f, 0.2468f), half2(e2, e2 * e));
            return c.rgb * lin_e;
#else
            return c.rgb * c.a * _Exposure * 8.0f;
#endif
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            half3 n = normalize (IN.worldNormal);
            half3 v = normalize (IN.viewDir);
            half fr = pow(1.0f - dot(v, n), _Fresnel) * _Reflectance;
            
            half3 reflectDir = reflect(-v, n);
            half3 refractDir = refract(-v, n, _Refraction);

            half3 reflectColor = SampleRGBM (texCUBE (_EnvTex, reflectDir));
            half3 refractColor = SampleRGBM (texCUBE (_EnvTex, refractDir));
            
            o.Emission = reflectColor * fr + refractColor;
        }
        ENDCG
    } 
    CustomEditor "PseudoRefractionRgbmInspector"
}
