package h3d.shader;

class AlphaMap extends hxsl.Shader {

	static var SRC = {
		var calculatedUV : Vec2;
		var pixelColor : Vec4;
		@param var texture : Sampler2D;
		@param var uvScale : Vec2;
		@param var uvDelta : Vec2;
		function fragment() {
			pixelColor.a *= texture.get(calculatedUV * uvScale + uvDelta).b;
		}
	}

	public function new(texture) {
		super();
		uvScale.set(1, 1);
		this.texture = texture;
	}

}