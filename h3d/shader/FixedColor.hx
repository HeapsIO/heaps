package h3d.shader;

class FixedColor extends hxsl.Shader {

	static var SRC = {
		@param var color : Vec4;
		var output : { color : Vec4 };
		function fragment() {
			output.color = color;
		}
	}

	public function new( color = 0, alpha = 1. ) {
		super();
		this.color.setColor(color,alpha);
	}

}