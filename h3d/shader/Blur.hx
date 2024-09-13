package h3d.shader;

class Blur extends ScreenShader {

	static var SRC = {

		@global var camera : {
			var inverseViewProj : Mat4;
		};

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

		@param @const var isCube : Bool;
		@param var cubeTexture : SamplerCube;
		@param var cubeDir : Mat3;

		function fragment() {
			if( isDepthDependant ) {
				var pcur = getPosition(input.uv);
				var ccur = texture.get(input.uv);
				var color = vec4(0, 0, 0, 0);
				@unroll for( i in -Quality + 1...Quality ) {
					var uv = input.uv + pixel * offsets[i < 0 ? -i : i] * i;
					var c = texture.get(uv);
					var p = getPosition(uv);
					var d = abs(pcur.z - p.z); 

					c = ( d > depthThreshold ) ? ccur : c;
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

		function getPosition( uv : Vec2 ) : Vec3 {
			var depth = unpack(depthTexture.get(uv));
			var temp = vec4(uvToScreen(uv), depth, 1) * camera.inverseViewProj;
			var originWS = temp.xyz / temp.w;
			return originWS;
		}
	}

}