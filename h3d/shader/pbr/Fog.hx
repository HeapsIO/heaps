package h3d.shader.pbr;

class FogClear extends h3d.shader.ScreenShader {

	static var SRC = {

		@param var fadingSpeed : Float;
		@param var dt : Float;

		@param var prevCamMat : Mat4;
		@param var cameraInverseViewProj : Mat4;
		@param var prevfogOcclusion : Sampler2D;
		@ignore @param var depthTexture : Channel;

		function getPixelPosition() : Vec3 {
			var uv2 = uvToScreen(calculatedUV);
			var depth = depthTexture.get(calculatedUV);
			var temp = vec4(uv2, depthTexture.get(calculatedUV), 1) * cameraInverseViewProj;
			var originWS = temp.xyz / temp.w;
			return originWS;
		}

		function fragment() {
			var pixelPos = getPixelPosition();
			var prevPos =  vec4(pixelPos, 1.0) * prevCamMat;
			prevPos.xyz /= prevPos.w;
			var prevUV = screenToUv(prevPos.xy);
			var uvOffset = calculatedUV - prevUV;
			var prevOcclusion = prevfogOcclusion.get(calculatedUV - uvOffset).r;
			if(prevUV.x < 0 || prevUV.x > 1 || prevUV.y < 0 || prevUV.y > 1) prevOcclusion = 0.0;
			pixelColor = vec4(prevOcclusion - (dt * fadingSpeed), 0, 0, 0);
		}
	}

	public function new() {
		super();
	}
}

class Fog extends h3d.shader.ScreenShader {

	static var SRC = {

		@ignore @param var depthTexture : Channel;
		@param var fogOcclusion : Sampler2D;
		@const var maxStepCount : Int;
		@param var cameraPos : Vec3;
		@param var cameraInverseViewProj : Mat4;
		@param var time : Float;
		@param var color : Vec3;
		@param var tilling : Vec2;
		@param var speed : Vec2;
		@param var fadeStrength : Float;
		@param var density : Float;
		@global var fogHeight : Float;
		@global var fogRange : Float;
		@param var texture : Sampler2D;

		@param var turbulenceText : Sampler2D;
		@param var turbulenceScale : Float;
		@param var turbulenceTilling : Vec2;
		@param var turbulenceSpeed : Vec2;
		@param var turbulenceIntensity : Float;

		function getPixelPosition() : Vec3 {
			var uv2 = uvToScreen(calculatedUV);
			var depth = depthTexture.get(calculatedUV);
			var temp = vec4(uv2, depthTexture.get(calculatedUV), 1) * cameraInverseViewProj;
			var originWS = temp.xyz / temp.w;
			return originWS;
		}

		function getFogDensity(pos: Vec3) : Float{
			var speedOffset = time * speed / tilling;
			var fadeFactor = 1 - (abs((pos.z - fogHeight) / (fogRange)));
			fadeFactor *= fadeFactor;
			fadeFactor = mix(1, fadeFactor, fadeStrength);
			var uv = (pos.xy / tilling) + speedOffset;
			var turbulenceUV = time * turbulenceSpeed + uv /*- (pos.z * 0.5)*/;
			var turbulence = textureLod(turbulenceText, turbulenceUV * turbulenceScale, 0).rg * turbulenceIntensity;
			var fog = textureLod(texture, uv + turbulence, 0).r;
			return fog * density * fadeFactor;
		}

		function fragment() {

			var pixelPos = getPixelPosition();

			var posToCam = normalize(cameraPos - pixelPos);
			var camToPos = -posToCam;
			var up = vec3(0,0,1);
			var maxZ = fogHeight + fogRange - pixelPos.z;
			var minZ = fogHeight - fogRange - pixelPos.z;

			var UdC = dot(posToCam, up);
			var distCamUpFog = ((cameraPos.z - (fogHeight + fogRange)) / UdC);
			var distCamDownFog = ((cameraPos.z - (fogHeight - fogRange))  / UdC);
			var fogStart = camToPos * distCamUpFog + cameraPos;
			var fogEnd = camToPos * distCamDownFog + cameraPos;

			if(fogRange <= 0) discard;
			if(cameraPos.z < fogStart.z) discard;

			var stepSize = length(fogEnd - fogStart) / maxStepCount;
			var step = camToPos * stepSize;
			var densitySum = 0.0;
			var curPos = fogStart;
			while(curPos.z > pixelPos.z && curPos.z > (fogHeight - fogRange)){
				densitySum += getFogDensity(curPos);
				curPos += step;
			}

			densitySum /= maxStepCount;
			densitySum = clamp(densitySum, 0, 1);

			var occlusion = 1 - fogOcclusion.get(calculatedUV).r;
			pixelColor = vec4( color, densitySum * occlusion);
		}
	}

	public function new() {
		super();
	}
}