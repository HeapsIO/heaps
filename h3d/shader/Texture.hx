package h3d.shader;

class Texture extends hxsl.Shader {

	static var SRC = {
		@input var input : {
			var uv : Vec2;
		};

		@const var additive : Bool;
		@const var killAlpha : Bool;
		@const var specularAlpha : Bool;
		@range(0,1) @param var killAlphaThreshold : Float;

		@param var texture : Sampler2D;
		var calculatedUV : Vec2;
		var pixelColor : Vec4;
		var specColor : Vec3;

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
			if( specularAlpha )
				specColor *= c.aaa;
		}
	}


	public function new(?tex) {
		super();
		this.texture = tex;
		killAlphaThreshold = h3d.mat.Defaults.defaultKillAlphaThreshold;
	}

}