package h3d.shader;

class ColorAdd extends hxsl.Shader {

	static var SRC = {
		var pixelColor : Vec4;

		@param var color : Vec3;

		function fragment() {
			pixelColor.rgb += color;
		}

	};

	public function new( color : Int = 0 ) {
		super();
		this.color.setColor(color);
	}

}