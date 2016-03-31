package h3d.shader;

class ChannelSelect extends hxsl.Shader {

	static var SRC = {

		var pixelColor : Vec4;
		@const var bits : Int;

		function __init__() {
			if( bits == 1 )
				pixelColor = pixelColor.rrrr;
			else if( bits == 2 )
				pixelColor = pixelColor.gggg;
			else if( bits == 4 )
				pixelColor = pixelColor.bbbb;
			else if( bits == 8 )
				pixelColor = pixelColor.aaaa;
			else
				pixelColor = vec4(0.);
		}

	}

	public function new( bits : Int ) {
		super();
		this.bits = bits;
	}

}