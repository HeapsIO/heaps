package h3d.shader;

class Blur extends ScreenShader {

	static var SRC = {

		@param var cameraInverseViewProj : Mat4;

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
		@param @const var hasNormal : Bool;
		@param var normalTexture : Sampler2D;

		@param @const var isCube : Bool;
		@param var cubeTexture : SamplerCube;
		@param var cubeDir : Mat3;

		function fragment() {
			if( isDepthDependant ) {
				var pcur = getPosition(input.uv);
				var ccur = texture.get(input.uv);
				var color = vec4(0, 0, 0, 0);
				var ncur = unpackNormal(normalTexture.get(input.uv));
				@unroll for( i in -Quality + 1...Quality ) {
					var uv = input.uv + pixel * offsets[i < 0 ? -i : i];
					var c = texture.get(uv);
					var p = getPosition(uv);
					var d = (p - pcur).dot(p - pcur);
					var n = unpackNormal(normalTexture.get(uv));

					c = mix(ccur, c, ncur.dot(n));
					c = mix(c, ccur, ((d - 0.001).max(0.) * 100000).min(1.));
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
			var temp = vec4(uvToScreen(uv), depth, 1) * cameraInverseViewProj;
			var originWS = temp.xyz / temp.w;
			return originWS;
		}
	}

}