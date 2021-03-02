package h3d.shader.pbr;

class PropsTexture extends hxsl.Shader {
	static var SRC = {

		@param var texture : Sampler2D;
		@param var emissiveValue : Float;

		var output : {
			metalness : Float,
			roughness : Float,
			occlusion : Float,
			emissive : Float,
		};

		var metalness : Float;
		var roughness : Float;
		var occlusion : Float;
		var emissive : Float;

		var calculatedUV : Vec2;

		function __init__fragment() {
			{
				var v = texture.get(calculatedUV);
				metalness = v.r;
				roughness = 1 - v.g * v.g;
				occlusion = v.b;
				emissive = emissiveValue * v.a;
			}
		}

		function fragment() {
			output.metalness = metalness;
			output.roughness = roughness;
			output.occlusion = occlusion;
			output.emissive = emissive;
		}

	}

	public function new(?t) {
		super();
		this.texture = t;
	}
}
