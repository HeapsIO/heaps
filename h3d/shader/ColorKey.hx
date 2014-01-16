package h3d.shader;

class ColorKey extends hxsl.Shader {

	static var SRC = {
		@param var colorKey : Vec4;
		var textureColor : Vec4;
		
		function fragment() {
			if( (textureColor - colorKey).length() == 0 ) discard;
		}
	}
	
	public function new( v = 0 ) {
		super();
		colorKey.setColor(v);
	}
	
}