package h3d.shader;

class AlphaChannel extends hxsl.Shader {

	static var SRC = {
		var pixelColor : Vec4;
		@const var showAlpha : Bool;
		function fragment() {
			if( showAlpha ) pixelColor.rgb = pixelColor.aaa;
			pixelColor.a = 1.;
		}
	}

}