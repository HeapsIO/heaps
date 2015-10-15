package h3d.shader;

class Blur extends ScreenShader {

	static var SRC = {

		@param var cameraInverseViewProj : Mat4;

		@param var texture : Sampler2D;
		@param var depthTexture : Sampler2D;
		@param @const var Quality : Int;
		@param @const var isDepth : Bool;
		@param var values : Array<Float,Quality>;
		@param var pixel : Vec2;

		@const var hasFixedColor : Bool;
		@const var smoothFixedColor : Bool;
		@param var fixedColor : Vec4;

		@param @const var isDepthDependant : Bool;
		@param @const var hasNormal : Bool;
		@param var normalTexture : Sampler2D;

		function fragment() {
			if( isDepthDependant ) {
				var pcur = getPosition(input.uv);
				var ccur = texture.get(input.uv);
				var color = vec4(0, 0, 0, 0);
				var ncur = unpackNormal(normalTexture.get(input.uv));
				for( i in -Quality + 1...Quality ) {
					var uv = input.uv + pixel * float(i);
					var c = texture.get(uv);
					var p = getPosition(uv);
					var d = (p - pcur).dot(p - pcur);
					var n = unpackNormal(normalTexture.get(uv));

					c = mix(ccur, c, ncur.dot(n));
					c = mix(c, ccur, ((d - 0.001).max(0.) * 100000).min(1.));
					color += c * values[i < 0 ? -i : i];
				}
				output.color = color;
			}
			else if( isDepth ) {
				var val = 0.;
				for( i in -Quality + 1...Quality )
					val += unpack(texture.get(input.uv + pixel * float(i))) * values[i < 0 ? -i : i];
				output.color = pack(val.min(0.9999999));
			} else {
				var color = vec4(0, 0, 0, 0);
				for( i in -Quality + 1...Quality )
					color += texture.get(input.uv + pixel * float(i)) * values[i < 0 ? -i : i];
				output.color = color;
			}
			if( hasFixedColor ) {
				output.color.rgb = fixedColor.rgb;
				if( smoothFixedColor )
					output.color.a *= fixedColor.a;
				else
					output.color.a = fixedColor.a * float(output.color.a > 0);
			}
		}

		function getPosition( uv : Vec2 ) : Vec3 {
			var depth = unpack(depthTexture.get(uv));
			var uv2 = (uv - 0.5) * vec2(2, -2);
			var temp = vec4(uv2, depth, 1) * cameraInverseViewProj;
			var originWS = temp.xyz / temp.w;
			return originWS;
		}
	}

}