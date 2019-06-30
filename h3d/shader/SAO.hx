package h3d.shader;

/**
	Screen space ambient occlusion.
	Uses "Scalable Ambient Obscurance" [McGuire12]
**/
class SAO extends ScreenShader {

	static var SRC = {

		@range(4,30) @const var numSamples : Int;
		@range(1,10) @const(16) var numSpiralTurns : Int;
		@const var useWorldUV : Bool;

		@ignore @param var depthTexture : Channel;
		@ignore @param var normalTexture : Channel3;
		@param var noiseTexture : Sampler2D;
		@param var noiseScale : Vec2;
		@range(0,10) @param var sampleRadius : Float;
		@range(0,10) @param var intensity : Float;
		@range(0,0.2) @param var bias : Float;

		@ignore @param var cameraView : Mat3x4;
		@ignore @param var cameraInverseViewProj : Mat4;

		@ignore @param var screenRatio : Vec2;
		@ignore @param var fovTan : Float;

		@ignore @param var microOcclusion : Channel;
		@param var microOcclusionIntensity : Float;

		function sampleAO(uv : Vec2, position : Vec3, normal : Vec3, radiusSS : Float, tapIndex : Int, rotationAngle : Float) : Float {
			// returns a unit vector and a screen-space radius for the tap on a unit disk
			// (the caller should scale by the actual disk radius)
			var alpha = (float(tapIndex) + 0.5) * (1.0 / float(numSamples));
			var angle = alpha * (float(numSpiralTurns) * 6.28) + rotationAngle;

			var unitOffset = vec2(cos(angle), sin(angle));
			var targetUV = uv + radiusSS * alpha * unitOffset * screenRatio;
			var Q = getPosition(targetUV);
			var v = Q - position;

			var vv = dot(v, v);
			var vn = dot(v, normal) - (bias * sampleRadius);

			// Smoother transition to zero (lowers contrast, smoothing out corners). [Recommended]
			var radius2 = sampleRadius * sampleRadius;
			var f = max(radius2 - vv, 0.0) / radius2;
			var epsilon = 0.01;
			return f * f * f * max(vn / (epsilon + vv), 0.0);
		}

		function getPosition( uv : Vec2 ) : Vec3 {
			var depth = depthTexture.get(uv);
			var uv2 = uvToScreen(uv);
			var temp = vec4(uv2, depth, 1) * cameraInverseViewProj;
			var originWS = temp.xyz / temp.w;
			return originWS;
		}

		function fragment() {

			var vUV = input.uv;
			var occlusion = 0.0;
			var origin = getPosition(vUV);
			var normal = normalTexture.get(vUV);

			var noiseUv : Vec2;
			if( useWorldUV )
				noiseUv = (origin.xy + origin.z) * noiseScale;
			else
				noiseUv = vUV / screenRatio * noiseScale;

			var sampleNoise = noiseTexture.get(noiseUv).x;
			var randomPatternRotationAngle = 2.0 * PI * sampleNoise;

			// change from WS to DepthUV space
			var radiusSS = (sampleRadius * fovTan) / (origin * cameraView).z;

			for( i in 0...numSamples )
				occlusion += sampleAO(vUV, origin, normal, radiusSS, i, randomPatternRotationAngle);

			occlusion = 1.0 - occlusion / float(numSamples);
			occlusion = pow(occlusion, 1.0 + intensity).saturate();

			occlusion *= mix(1, microOcclusion.get(vUV).r, microOcclusionIntensity);

			output.color = vec4(occlusion.xxx, 1.);
		}
	};

	public function new() {
		super();
		numSamples = 20;
		sampleRadius = 1;
		intensity = 1;
		numSpiralTurns = 7;
		bias = 0.01;
		noiseScale.set(10, 10);
		noiseTexture = h3d.mat.Texture.genNoise(128);
		noiseTexture.wrap = Repeat;
	}

}