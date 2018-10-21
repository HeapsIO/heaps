package h3d.shader.pbr;

class PropsValues extends hxsl.Shader {

	static var SRC = {

		var output : {
			metalness : Float,
			roughness : Float,
			occlusion : Float,
			emissive : Float,
		};

		@param var metalness : Float;
		@param var roughness : Float;
		@param var occlusion : Float;
		@param var emissive : Float;

		var metalnessValue : Float;
		var roughnessValue : Float;
		var occlusionValue : Float;
		var emissiveValue : Float;

		function __init__() {
			metalnessValue = metalness;
			roughnessValue = roughness;
			occlusionValue = occlusion;
			emissiveValue = emissive;
		}

		function fragment() {
			output.metalness = metalnessValue;
			output.roughness = roughnessValue;
			output.occlusion = occlusionValue;
			output.emissive = emissiveValue;
		}

	};

	public function new(metalness=0.,roughness=1.,occlusion=1.,emissive=0.) {
		super();
		this.metalness = metalness;
		this.roughness = roughness;
		this.occlusion = occlusion;
		this.emissive = emissive;
	}

}

