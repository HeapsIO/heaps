package h3d.shader;

class DirShadow extends hxsl.Shader {

	static var SRC = {

		@const var enable : Bool;

		@const var PCF : Int;
		@param var pcfScale : Float;

		@param var shadowMap : Channel;
		@param var shadowProj : Mat3x4;
		@param var shadowPower : Float;
		@param var shadowBias : Float;
		@param var shadowRes : Vec2;

		var transformedPosition : Vec3;
		var shadow : Float;

		@param var poissonDisk2x2 : Array<Vec4,5>;
		@param var poissonDisk4x4 : Array<Vec4,13>;

		function rand( v : Float ) : Float {
			 var dp = dot(vec4(v), vec4(12.9898,78.233,45.164,94.673));
   			 return fract(sin(dp) * 43758.5453);
		}

		function fragment() {
			if( enable ) {
				if( PCF > 0 ) {
					shadow = 1.0;
					var texelSize = 1.0/shadowRes;
					var shadowPos = transformedPosition * shadowProj;
					var shadowUv = screenToUv(shadowPos.xy);
					var zMax = shadowPos.z.saturate();

					var rot = rand(transformedPosition.x + transformedPosition.y + transformedPosition.z) * 3.14 * 2;
					switch(PCF){
						case 1:
							var sampleStrength = 1.0 / 5.0;
							for( i in 0 ... 5 ) {
								var offset = poissonDisk2x2[i].xy * texelSize * pcfScale;
								offset = vec2(cos(rot) * offset.x - sin(rot) * offset.y, cos(rot) * offset.y + sin(rot) * offset.x);
								var depth = shadowMap.get(shadowUv + offset);
								if( zMax - shadowBias > depth )
									shadow -= sampleStrength;
							}
						case 2:
							var sampleStrength = 1.0 / 13.0;
							for( i in 0 ... 13 ) {
								var offset = poissonDisk4x4[i].xy * texelSize * pcfScale;
								offset = vec2(cos(rot) * offset.x - sin(rot) * offset.y, cos(rot) * offset.y + sin(rot) * offset.x);
								var depth = shadowMap.get(shadowUv + offset);
								if( zMax - shadowBias > depth )
									shadow -= sampleStrength;
							}
					}
				}
				else{
					var shadowPos = transformedPosition * shadowProj;
					var depth = shadowMap.get(screenToUv(shadowPos.xy));
					var zMax = shadowPos.z.saturate();
					var delta = (depth + shadowBias).min(zMax) - zMax;
					shadow = exp( shadowPower * delta ).saturate();
				}
			}
		}

	}

	public function new() {
		super();
		poissonDisk2x2 = [	new h3d.Vector( 0., 0. ),
							new h3d.Vector(-0.942,-0.399 ),
							new h3d.Vector( 0.945,-0.768 ),
							new h3d.Vector(-0.094,-0.929 ),
							new h3d.Vector( 0.344, 0.293 ) ];

		poissonDisk4x4 = [  new h3d.Vector( 0., 0. ),
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

	}

}