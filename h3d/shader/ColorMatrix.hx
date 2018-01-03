package h3d.shader;

class ColorMatrix extends hxsl.Shader {

	static var SRC = {
		var pixelColor : Vec4;

		@param var matrix : Mat4;

		function fragment() {
			pixelColor = vec4( (vec4(pixelColor.rgb,1.) * matrix).rgb, (pixelColor * matrix).a);
		}

	};

	public function new( ?m : Array<Float> ) {
		super();
		if( m != null ) this.matrix.loadValues(m) else this.matrix.identity();
	}

}