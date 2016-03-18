package h3d.shader;

/**
	This is similar to [Texture] shader but uses a second UV set.
**/
class Texture2 extends hxsl.Shader {

	static var SRC = {
		@input var input : {
			var uv2 : Vec2;
		};

		@const var additive : Bool;
		@const var killAlpha : Bool;
		@param var killAlphaThreshold : Float;

		@param var texture : Sampler2D;
		var calculatedUV2 : Vec2;
		var pixelColor : Vec4;

		function vertex() {
			calculatedUV2 = input.uv2;
		}

		function fragment() {
			var c = texture.get(calculatedUV2);
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
		this.killAlphaThreshold = h3d.mat.Defaults.defaultKillAlphaThreshold;
	}

}