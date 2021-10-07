package h3d.shader.pbr;

class PropsTexture extends hxsl.Shader {
	static var SRC = {

		@param var texture : Sampler2D;
		@param var emissiveValue : Float;
		@param var custom1Value : Float;
		@param var custom2Value : Float;

		var output : {
			metalness : Float,
			roughness : Float,
			occlusion : Float,
			emissive : Float,
			custom1 : Float,
			custom2 : Float,
		};

		var metalness : Float;
		var roughness : Float;
		var occlusion : Float;
		var emissive : Float;
		var custom1 : Float;
		var custom2 : Float;

		var calculatedUV : Vec2;

		function __init__fragment() {
			{
				var v = texture.get(calculatedUV);
				metalness = v.r;
				roughness = 1 - v.g * v.g;
				occlusion = v.b;
				emissive = emissiveValue * v.a;
			}
			custom1 = custom1Value;
			custom2 = custom2Value;
		}

		function fragment() {
			output.metalness = metalness;
			output.roughness = roughness;
			output.occlusion = occlusion;
			output.emissive = emissive;
			output.custom1 = custom1;
			output.custom2 = custom2;
		}

	}

	public function new(?t) {
		super();
		this.texture = t;
	}
}
