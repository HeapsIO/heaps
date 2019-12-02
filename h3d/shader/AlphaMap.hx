package h3d.shader;

class AlphaMap extends hxsl.Shader {

	static var SRC = {
		var calculatedUV : Vec2;
		var pixelColor : Vec4;
		@param var texture : Sampler2D;
		@param var uvScale : Vec2;
		@param var uvDelta : Vec2;
		@const var useAlphaChannel : Bool;
		function fragment() {
			if( useAlphaChannel )
				pixelColor.a *= texture.get(calculatedUV * uvScale + uvDelta).a;
			else
				pixelColor.a *= texture.get(calculatedUV * uvScale + uvDelta).b;
		}
	}

	public function new(texture, useAlphaChannel=false) {
		super();
		uvScale.set(1, 1);
		this.useAlphaChannel = useAlphaChannel;
		this.texture = texture;
	}

}