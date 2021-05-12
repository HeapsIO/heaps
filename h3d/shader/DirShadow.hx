package h3d.shader;

class DirShadow extends hxsl.Shader {

	static var SRC = {

		@const var enable : Bool;

		// ESM
		@const var USE_ESM : Bool;
		@param var shadowPower : Float;
		// PCF
		@const var USE_PCF : Bool;
		@const var PCF_SAMPLES : Int;
		@param var pcfScale : Float;
		@param var shadowRes : Vec2;

		@param var shadowMap : Channel;
		@param var shadowProj : Mat3x4;
		@param var shadowBias : Float;

		var transformedPosition : Vec3;
		var shadow : Float;
		var dirShadow : Float;

		@param var poissonDisk : Array<Vec4,PCF_SAMPLES>;

		function rand( v : Float ) : Float {
			 var dp = dot(vec4(v), vec4(12.9898,78.233,45.164,94.673));
   			 return fract(sin(dp) * 43758.5453);
		}

		function fragment() {
			if( enable ) {
				if( USE_PCF ) {
					shadow = 1.0;
					var texelSize = 1.0/shadowRes;
					var shadowPos = transformedPosition * shadowProj;
					var shadowUv = screenToUv(shadowPos.xy);
					var zMax = shadowPos.z.saturate();

					var rot = rand(transformedPosition.x + transformedPosition.y + transformedPosition.z) * 3.14 * 2;
					var cosR = cos(rot);
					var sinR = sin(rot);
					var sampleStrength = 1.0 / PCF_SAMPLES;
					var offScale = texelSize * pcfScale;
					for(i in 0...PCF_SAMPLES) {
						var offset = poissonDisk[i].xy * offScale;
						offset = vec2(cosR * offset.x - sinR * offset.y, cosR * offset.y + sinR * offset.x);
						var depth = shadowMap.getLod(shadowUv + offset, 0);
						shadow  -= (zMax - shadowBias > depth) ? sampleStrength : 0.0;
					}
				}
				else if( USE_ESM ) {
					var shadowPos = transformedPosition * shadowProj;
					var depth = shadowMap.get(screenToUv(shadowPos.xy));
					var zMax = shadowPos.z.saturate();
					var delta = (depth + shadowBias).min(zMax) - zMax;
					shadow = exp(shadowPower * delta).saturate();
				}
				else {
					var shadowPos = transformedPosition * shadowProj;
					var shadowUv = screenToUv(shadowPos.xy);
					var depth = shadowMap.get(shadowUv.xy);
					shadow = shadowPos.z.saturate() - shadowBias > depth ? 0 : 1;
				}
			}
			dirShadow = shadow;
		}
	}

	public var pcfQuality(never, set) : Int;
	function set_pcfQuality(q: Int) {
		poissonDisk = switch(q) {
		default: [
			new h3d.Vector(-0.942,-0.399 ),
			new h3d.Vector( 0.945,-0.768 ),
			new h3d.Vector(-0.094,-0.929 ),
			new h3d.Vector( 0.344, 0.293 ) ];

		case 2: [
			new h3d.Vector(-0.326,-0.406),
			new h3d.Vector(-0.840,-0.074),
			new h3d.Vector(-0.696, 0.457),
			new h3d.Vector(-0.203, 0.621),
			new h3d.Vector( 0.962,-0.195),
			new h3d.Vector( 0.473,-0.480),
			new h3d.Vector( 0.519, 0.767),
			new h3d.Vector( 0.185,-0.893),
			new h3d.Vector( 0.507, 0.064),
			new h3d.Vector( 0.896, 0.412),
			new h3d.Vector(-0.322,-0.933),
			new h3d.Vector(-0.792,-0.598) ];

		case 3: [
			new h3d.Vector(-0.613392, 0.617481),
			new h3d.Vector(0.170019, -0.040254),
			new h3d.Vector(-0.299417, 0.791925),
			new h3d.Vector(0.645680, 0.493210),
			new h3d.Vector(-0.651784, 0.717887),
			new h3d.Vector(0.421003, 0.027070),
			new h3d.Vector(-0.817194, -0.271096),
			new h3d.Vector(-0.705374, -0.668203),
			new h3d.Vector(0.977050, -0.108615),
			new h3d.Vector(0.063326, 0.142369),
			new h3d.Vector(0.203528, 0.214331),
			new h3d.Vector(-0.667531, 0.326090),
			new h3d.Vector(-0.098422, -0.295755),
			new h3d.Vector(-0.885922, 0.215369),
			new h3d.Vector(0.566637, 0.605213),
			new h3d.Vector(0.039766, -0.396100),
			new h3d.Vector(0.751946, 0.453352),
			new h3d.Vector(0.078707, -0.715323),
			new h3d.Vector(-0.075838, -0.529344),
			new h3d.Vector(0.724479, -0.580798),
			new h3d.Vector(0.222999, -0.215125),
			new h3d.Vector(-0.467574, -0.405438),
			new h3d.Vector(-0.248268, -0.814753),
			new h3d.Vector(0.354411, -0.887570),
			new h3d.Vector(0.175817, 0.382366),
			new h3d.Vector(0.487472, -0.063082),
			new h3d.Vector(-0.084078, 0.898312),
			new h3d.Vector(0.488876, -0.783441),
			new h3d.Vector(0.470016, 0.217933),
			new h3d.Vector(-0.696890, -0.549791),
			new h3d.Vector(-0.149693, 0.605762),
			new h3d.Vector(0.034211, 0.979980),
			new h3d.Vector(0.503098, -0.308878),
			new h3d.Vector(-0.016205, -0.872921),
			new h3d.Vector(0.385784, -0.393902),
			new h3d.Vector(-0.146886, -0.859249),
			new h3d.Vector(0.643361, 0.164098),
			new h3d.Vector(0.634388, -0.049471),
			new h3d.Vector(-0.688894, 0.007843),
			new h3d.Vector(0.464034, -0.188818),
			new h3d.Vector(-0.440840, 0.137486),
			new h3d.Vector(0.364483, 0.511704),
			new h3d.Vector(0.034028, 0.325968),
			new h3d.Vector(0.099094, -0.308023),
			new h3d.Vector(0.693960, -0.366253),
			new h3d.Vector(0.678884, -0.204688),
			new h3d.Vector(0.001801, 0.780328),
			new h3d.Vector(0.145177, -0.898984),
			new h3d.Vector(0.062655, -0.611866),
			new h3d.Vector(0.315226, -0.604297),
			new h3d.Vector(-0.780145, 0.486251),
			new h3d.Vector(-0.371868, 0.882138),
			new h3d.Vector(0.200476, 0.494430),
			new h3d.Vector(-0.494552, -0.711051),
			new h3d.Vector(0.612476, 0.705252),
			new h3d.Vector(-0.578845, -0.768792),
			new h3d.Vector(-0.772454, -0.090976),
			new h3d.Vector(0.504440, 0.372295),
			new h3d.Vector(0.155736, 0.065157),
			new h3d.Vector(0.391522, 0.849605),
			new h3d.Vector(-0.620106, -0.328104),
			new h3d.Vector(0.789239, -0.419965),
			new h3d.Vector(-0.545396, 0.538133),
			new h3d.Vector(-0.178564, -0.596057) ];
		}
		PCF_SAMPLES = poissonDisk.length;
		return q;
	}

	public function new() {
		super();
		pcfQuality = 1;
	}

}