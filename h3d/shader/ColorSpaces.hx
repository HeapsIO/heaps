package h3d.shader;

class ColorSpaces extends hxsl.Shader {
	static var SRC = {

		//HSV from https://gist.github.com/983/e170a24ae8eba2cd174f
		function rgb2hsv(c : Vec3) : Vec3 {
			var K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			var p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
			var q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

			var d = q.x - min(q.w, q.y);
			var e = 1.0e-8;
			return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		function hsv2rgb(c : Vec3) : Vec3 {
			var K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
			var p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
			return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
		}

		//HSL
		function hsl2rgb( c : Vec3 ) : Vec3 {
			var rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );

			return c.z + c.y * (rgb-0.5)*(1.0-abs(2.0*c.z-1.0));
		}

		//YCoCg
		function rgb2ycocg( rgb : Vec3 ) : Vec3 {
			var co = rgb.r - rgb.b;
			var t = rgb.b + co * 0.5;
			var cg = rgb.g - t;
			var y = t + cg * 0.5;
			return vec3(y, co, cg);
		}

		function ycocg2rgb( ycocg : Vec3 ) : Vec3 {
			var t = ycocg.r - ycocg.b * 0.5;
			var g = ycocg.b + t;
			var b = t - ycocg.g * 0.5;
			var r = ycocg.g + b;
			return vec3(r, g, b);
		}

		function unpackIntColor( c : Int ) : Vec4 {
			return vec4((c >> 16) & 0xFF, (c >> 8) & 0xFF, c & 0xFF, (c >> 24) & 0xFF) * (1.0 / float(0xFF));
		}

		function packIntColor( c : Vec4 ) : Int {
			var cInt = ivec4(saturate(c) * 255 + 0.499);
			return cInt.a << 24 | cInt.r << 16 | cInt.g << 8 | cInt.b;
		}

		function srgb2linear( srgb : Vec3 ) : Vec3 {
			var linearLo = srgb * 0.0773993808;
			var linearHi = pow(srgb * 0.9478672986 + 0.0521327014, vec3(2.4));
			var linear = vec3(
				srgb.x <= 0.04045 ? linearLo.x : linearHi.x,
				srgb.y <= 0.04045 ? linearLo.y : linearHi.y,
				srgb.z <= 0.04045 ? linearLo.z : linearHi.z
			);
			return linear;
		}

		function linear2srgb( rgb : Vec3 ) : Vec3 {
			var srgbLo = rgb * 12.92;
			var srgbHi = 1.055 * pow(rgb, vec3(0.41666)) - 0.055;
			var srgb = vec3(
				rgb.x <= 0.0031308 ? srgbLo.x : srgbHi.x,
				rgb.y <= 0.0031308 ? srgbLo.y : srgbHi.y,
				rgb.z <= 0.0031308 ? srgbLo.z : srgbHi.z
			);
			return srgb;
		}

		function rgb2luminance( rgb : Vec3 ) : Float {
			return dot(rgb, vec3(0.2126, 0.7152, 0.0722));
		}
	}
}