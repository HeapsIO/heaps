package h3d.shader.pbr;

class PropsTexture extends hxsl.Shader {
	static var SRC = {
		@param var texture : Sampler2D;
		var output : {
			metalness : Float,
			roughness : Float,
			occlusion : Float,
		};
		var calculatedUV : Vec2;
		function fragment() {
			var v = texture.get(calculatedUV);
			output.metalness = v.r;
			output.roughness = 1 - v.g * v.g;
			output.occlusion = v.b;
		}
	}
	public function new(?t) {
		super();
		this.texture = t;
	}
}
