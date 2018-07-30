package h3d.shader.pbr;

class FogOccluder extends hxsl.Shader {

	static var SRC = {

		var output : {
			var position : Vec4;
			var color : Vec4;
			var depth : Float;
			var normal : Vec3;
		};

		var pixelTransformedPosition : Vec3;

		@param var spherePos : Vec3;
		@param var sphereRadius : Float;
		@param var strength : Float;
		@global var fogHeight : Float;
		@global var fogRange : Float;

		@param var fresnelIntensity : Float;
		@param var fresnelPower : Float;

		@param var cameraPos : Vec3;
		@param var cameraMatrix: Mat4;

		function fragment() {

			var posToCam = normalize(cameraPos - pixelTransformedPosition);
			var camToPos = -posToCam;
			var up = vec3(0,0,1);
			var UdC = dot(posToCam, up);
			var distCamUpFog = ((cameraPos.z - (fogHeight + fogRange)) / UdC);
			var distCamDownFog = ((cameraPos.z - (fogHeight - fogRange))  / UdC);
			var fogStart = camToPos * distCamUpFog + cameraPos;
			var fogEnd = camToPos * distCamDownFog + cameraPos;
			var fogLength = length(fogEnd - fogStart);
			var sphereCenterDir = normalize(spherePos - pixelTransformedPosition);
			var SdC = dot(sphereCenterDir, camToPos);
			var sphereLength = sphereRadius * SdC * 2;
			var sphereStart = pixelTransformedPosition;
			var sphereEnd = pixelTransformedPosition + sphereLength * camToPos;

			var ssc = vec4(sphereStart, 1) * cameraMatrix;
			var sec = vec4(sphereEnd, 1) * cameraMatrix;
			var fsc = vec4(fogStart, 1) * cameraMatrix;
			var fec = vec4(fogEnd, 1) * cameraMatrix;

			if(sec.z < fsc.z || ssc.z > fec.z) discard;

			var start = min(ssc.z, fsc.z);
			var end = max(sec.z, fec.z);
			var fresnel = mix(1, pow(dot(output.normal, posToCam), fresnelPower), fresnelIntensity);
			var length = abs(end - start) - abs(fsc.z - ssc.z) - abs(fec.z - sec.z);

			var occlusion = 1 - ((fogLength - length) / fogLength);

			occlusion = occlusion * strength * fresnel;

			output.color = vec4(occlusion,0,0,0);
		}
	}

	public function new() {
		super();
	}
}