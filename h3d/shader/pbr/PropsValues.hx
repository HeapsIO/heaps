package h3d.shader.pbr;

class PropsValues extends hxsl.Shader {

	static var SRC = {

		var output : {
			metalness : Float,
			roughness : Float,
			occlusion : Float,
			emissive : Float,
		};

		@param var metalnessValue : Float;
		@param var roughnessValue : Float;
		@param var occlusionValue : Float;
		@param var emissiveValue : Float;

		var metalness : Float;
		var roughness : Float;
		var occlusion : Float;
		var emissive : Float;

		function __init__() {
			metalness = metalnessValue;
			roughness = roughnessValue;
			occlusion = occlusionValue;
			emissive = emissiveValue;
		}

		function fragment() {
			output.metalness = metalness;
			output.roughness = roughness;
			output.occlusion = occlusion;
			output.emissive = emissive;
		}

	};

	public function new(metalness=0.,roughness=1.,occlusion=1.,emissive=0.) {
		super();
		this.metalnessValue = metalness;
		this.roughnessValue = roughness;
		this.occlusionValue = occlusion;
		this.emissiveValue = emissive;
	}

}

