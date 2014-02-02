Shader "Custom/Pseudo Refraction"
{
    Properties
    {
        _EnvTex ("Environment", Cube) = "gray" {}
        _Refraction ("Refration Index", float) = 0.9
        _Fresnel ("Fresnel Coefficient", float) = 5.0
        _Reflectance ("Reflectance", float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        CGPROGRAM

        #pragma surface surf PseudoRefraction

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
        half _Refraction;
        half _Fresnel;
        half _Reflectance;

        void surf (Input IN, inout SurfaceOutput o)
        {
            half3 n = normalize (IN.worldNormal);
            half3 v = normalize (IN.viewDir);
            half fr = pow(1.0f - dot(v, n), _Fresnel) * _Reflectance;
            
            half3 reflectDir = reflect(-v, n);
            half3 refractDir = refract(-v, n, _Refraction);

            half3 reflectColor = texCUBE (_EnvTex, reflectDir).rgb;
            half3 refractColor = texCUBE (_EnvTex, refractDir).rgb;
            
            o.Emission = reflectColor * fr + refractColor;
        }

        ENDCG
    } 
    FallBack Off
}
