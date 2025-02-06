package h3d.shader;

class Blur extends ScreenShader {

	static var SRC = {

		@param var inverseProj : Mat4;
		@param var texture : Sampler2D;
		@param var depthTexture : Sampler2D;
		@param @const var Quality : Int;
		@param @const var isDepth : Bool;
		@param var values : Array<Float,Quality>;
		@param var offsets : Array<Float,Quality>;
		@param var pixel : Vec2;

		@const var hasFixedColor : Bool;
		@const var smoothFixedColor : Bool;
		@param var fixedColor : Vec4;

		@param @const var isDepthDependant : Bool;
		@param var depthThreshold : Float = 1.0;
		@param var depthThresholdMaxDist : Float = 0.0;

		@param @const var isCube : Bool;
		@param var cubeTexture : SamplerCube;
		@param var cubeDir : Mat3;

		function scaleThreshold(z : Float) : Float {
			var t = depthThreshold;
			if ( depthThresholdMaxDist > 0.0 )
				t *= 1.0 + max(z - depthThresholdMaxDist, 0.0);
			return t;
		}

		function fragment() {
			if( isDepthDependant ) {
				var dimensions = texture.size();
				var invDimensions = 1.0 / dimensions;
				var coord = fragCoord.xy;
				var fragUV = coord.xy * invDimensions;
				var p = getViewPosition(fragUV);
				var minZ = p.z;
				var c = texture.get(fragUV);
				var color = vec4(0, 0, 0, 0);

				var isEdge = false;

				@unroll for( i in -Quality...Quality + 1 ) {
					var curCoord = floor(coord + ( pixel * dimensions ) * vec2(1.0) * i) + vec2(0.5);
					var nearestUV = curCoord * invDimensions;
					var pcur = getViewPosition(nearestUV);
					var d = abs(pcur.z - p.z);
					isEdge = isEdge || ( d > scaleThreshold(min(pcur.z, p.z)) );
				}

				@unroll for( i in -Quality + 1...Quality ) {
					var curCoord = floor(coord + ( pixel * dimensions ) * offsets[i < 0 ? -i : i] * i) + vec2(0.5);
					var nearestUV = curCoord * invDimensions;
					var uv = fragUV + pixel * offsets[i < 0 ? -i : i] * i;
					var ccur = texture.get( ( isEdge ) ? nearestUV : uv );
					var pcur = getViewPosition(nearestUV);
					var d = abs(pcur.z - p.z);
					c = ( d > scaleThreshold(min(pcur.z, p.z)) ) ? c : ccur;
					color += c * values[i < 0 ? -i : i];
				}
				pixelColor = color;
			}
			else if( isDepth ) {
				var val = 0.;
				@unroll for( i in -Quality + 1...Quality ){
					if( isCube ) val += unpack(cubeTexture.get(vec3((input.uv + pixel * offsets[i < 0 ? -i : i] * i )* 2.0 - 1.0, 1) * cubeDir)) * values[i < 0 ? -i : i];
					else val += unpack(texture.get(input.uv + pixel * offsets[i < 0 ? -i : i] * i)) * values[i < 0 ? -i : i];
				}
				pixelColor = pack(val.min(0.9999999));
			} else {
				var color = vec4(0, 0, 0, 0);
				@unroll for( i in -Quality + 1...Quality ){
					if( isCube ) color += cubeTexture.get(vec3((input.uv + pixel * offsets[i < 0 ? -i : i] * i )* 2.0 - 1.0, 1) * cubeDir) * values[i < 0 ? -i : i];
					else color += texture.get(input.uv + pixel * offsets[i < 0 ? -i : i] * i) * values[i < 0 ? -i : i];
				}
				pixelColor = color;
			}
			if( hasFixedColor ) {
				if( smoothFixedColor )
					pixelColor.a *= fixedColor.a;
				else
					pixelColor.a = fixedColor.a * float(pixelColor.a > 0);
				pixelColor.rgb = fixedColor.rgb * pixelColor.a; // premult required for 2D filters
			}
		}

		function getViewPosition( uv : Vec2 ) : Vec3 {
			var depth = depthTexture.get(uv).r;
			var temp = vec4(uvToScreen(uv), depth, 1) * inverseProj;
			var originWS = temp.xyz / temp.w;
			return originWS;
		}
	}

}