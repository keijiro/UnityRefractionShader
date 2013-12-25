Shader "Custom/Simple Refraction" {
	Properties {
		_EnvTex ("Environment", Cube) = "gray" {}
		_Refraction ("Refration Index", float) = 0.9
		_Fresnel ("Fresnel Coefficient", float) = 5.0
		_Reflectance ("Reflectance", float) = 1.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		samplerCUBE _EnvTex;
		float _Refraction;
		float _Fresnel;
		float _Reflectance;

		struct Input {
			float3 viewDir;
			float3 worldNormal;
		};

		void surf (Input IN, inout SurfaceOutput o) {
            float3 n = normalize (IN.worldNormal);
			float3 v = normalize (IN.viewDir);
			float fr = pow(1.0f - dot(v, n), _Fresnel) * _Reflectance;
			
			float3 reflectDir = reflect(-v, n);
			float3 refractDir = refract(-v, n, _Refraction);
			
			o.Emission = texCUBE (_EnvTex, refractDir).rgb + texCUBE (_EnvTex, reflectDir).rgb * fr;
		}
		ENDCG
	} 
	FallBack Off
}
