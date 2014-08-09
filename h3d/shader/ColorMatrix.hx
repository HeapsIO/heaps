package h3d.shader;

class ColorMatrix extends hxsl.Shader {

	static var SRC = {
		var pixelColor : Vec4;

		@param var matrix : Mat4;

		function fragment() {
			pixelColor *= matrix;
		}

	};

	public function new( ?m : Array<Float> ) {
		super();
		if( m != null ) this.matrix.load(m) else this.matrix.identity();
	}

}