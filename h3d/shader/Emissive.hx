package h3d.shader;

class Emissive extends hxsl.Shader {

	static var SRC = {
		var pixelColor : Vec4;
		@param var emissive : Float;

		function fragment() {
			pixelColor.rgb = max(pixelColor.rgb, pixelColor.rgb + pixelColor.rgb * emissive * pixelColor.a);
		}

	};

	public function new( emissive : Float = 0 ) {
		super();
		this.emissive = emissive;
	}

}