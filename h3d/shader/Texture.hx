package h3d.shader;

class Texture extends hxsl.Shader {

	static var SRC = {
		@input var input : {
			var uv : Vec2;
		};

		@const var additive : Bool;
		@const var killAlpha : Bool;
		@param var killAlphaThreshold : Float;

		@param var texture : Sampler2D;
		var calculatedUV : Vec2;
		var pixelColor : Vec4;

		function vertex() {
			calculatedUV = input.uv;
		}

		function fragment() {
			var c = texture.get(calculatedUV);
			if( killAlpha && c.a - killAlphaThreshold < 0 ) discard;
			if( additive )
				pixelColor += c;
			else
				pixelColor *= c;
		}
	}


	public function new(?tex) {
		super();
		this.texture = tex;
		killAlphaThreshold = 0.5;
	}

}