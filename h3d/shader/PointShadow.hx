package h3d.shader;

class PointShadow extends hxsl.Shader {

	static var SRC = {

		@const var enable : Bool;

		// ESM
		@const var USE_ESM : Bool;
		@param var shadowPower : Float;
		// PCF
		@const var USE_PCF : Bool;
		@const var pcfQuality : Int;
		@param var pcfScale : Float;

		@param var shadowMap : SamplerCube;
		@param var lightPos : Vec3;
		@param var shadowBias : Float;
		@param var zFar : Float;

		var transformedPosition : Vec3;
		var shadow : Float;
		var pointShadow : Float;

		function fragment() {
			if( enable ) {
				if( USE_PCF ) {
					shadow = 1.0;
					var posToLight = transformedPosition.xyz - lightPos;
					var dir = normalize(posToLight.xyz);
					var zMax = length(posToLight);

					if( zFar < zMax )
						shadow = 1.0;
					else {
						var sampleCount = 0;
						switch( pcfQuality ) {
							case 1: sampleCount = 1;
							case 2: sampleCount = 2;
							case 3: sampleCount = 4;
						};
						var samplePerDim = sampleCount * 2 + 1;
						var totalSample = samplePerDim * samplePerDim * samplePerDim;
						var sampleStrength = 1.0 / totalSample;
						for( i in -sampleCount ... sampleCount + 1 ) {
							for( j in -sampleCount ... sampleCount + 1 ) {
								for( k in -sampleCount ... sampleCount + 1 ) {
									var offset = vec3(i, j, k) * pcfScale;
									var depth = shadowMap.getLod(dir + offset, 0).r * zFar;
									if( zMax - shadowBias > depth )
										shadow -= sampleStrength;
								}
							}
						}
					}
				}
				else if ( USE_ESM ) {
					var posToLight = transformedPosition.xyz - lightPos;
					var dir = normalize(posToLight.xyz);
					var depth = shadowMap.getLod(dir, 0).r * zFar;
					var zMax = length(posToLight);
					var delta = (depth + shadowBias).min(zMax) - zMax;
					shadow = exp(shadowPower * delta).saturate();
				}
				else {
					var posToLight = transformedPosition.xyz - lightPos;
					var dir = normalize(posToLight.xyz);
					var depth = shadowMap.getLod(dir, 0).r * zFar;
					var zMax = length(posToLight);
					shadow = zMax - shadowBias > depth ? 0 : 1;
				}
			}
			pointShadow = shadow;
		}
	}

	public function new() {
		super();
	}
}