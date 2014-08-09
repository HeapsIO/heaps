package h3d.shader;

class ColorKey extends hxsl.Shader {

	static var SRC = {
		@param var colorKey : Vec4;
		var textureColor : Vec4;

		function fragment() {
			var cdiff = textureColor - colorKey;
			if( cdiff.dot(cdiff) < 0.00001 ) discard;
		}
	}

	public function new( v = 0 ) {
		super();
		colorKey.setColor(v);
	}

}