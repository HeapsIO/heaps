package h3d.shader.pbr;

class AlphaMask extends hxsl.Shader {

	static var SRC = {
		var normal : Vec3;
		var pixelColor : Vec4;
		function fragment() {
			#if !MRT_low
			var isSky = normal.dot(normal) <= 0;
			#else
			var isSky = normal.dot(normal) > 1.1; // due to normal packing, sky normal is likely sqrt(3) > 1.7
			#end
			if( isSky ) pixelColor.a = 0;
		}
	};

}

