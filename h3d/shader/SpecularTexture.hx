package h3d.shader;

class SpecularTexture extends hxsl.Shader {

	static var SRC = {
		@param var texture : Sampler2D;
		var calculatedUV : Vec2;
		var specColor : Vec3;

		function fragment() {
			specColor *= texture.get(calculatedUV).rgb;
		}
	}

	public function new(?tex) {
		super();
		this.texture = tex;
	}

}