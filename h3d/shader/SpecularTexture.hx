package h3d.shader;

class SpecularTexture extends hxsl.Shader {

	static var SRC = {
		@param var texture : Sampler2D;
		var calculatedUV : Vec2;
		var specAmount : Float;

		function fragment() {
			specAmount *= texture.get(calculatedUV).x;
		}
	}

	public function new(?tex) {
		super();
		this.texture = tex;
	}

}