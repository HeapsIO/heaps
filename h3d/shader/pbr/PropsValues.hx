package h3d.shader.pbr;

class PropsValues extends hxsl.Shader {

	static var SRC = {

		var output : {
			metalness : Float,
			roughness : Float,
			occlusion : Float,
			emissive : Float,
			custom1 : Float,
			custom2 : Float,
		};

		@param var metalnessValue : Float;
		@param var roughnessValue : Float;
		@param var occlusionValue : Float;
		@param var emissiveValue : Float;
		@param var custom1Value : Float;
		@param var custom2Value : Float;

		var metalness : Float;
		var roughness : Float;
		var occlusion : Float;
		var emissive : Float;
		var custom1 : Float;
		var custom2 : Float;

		function __init__() {
			metalness = metalnessValue;
			roughness = roughnessValue;
			occlusion = occlusionValue;
			emissive = emissiveValue;
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

	};

	public function new(metalness=0.,roughness=1.,occlusion=1.,emissive=0.,custom1=0.,custom2=0.) {
		super();
		this.metalnessValue = metalness;
		this.roughnessValue = roughness;
		this.occlusionValue = occlusion;
		this.emissiveValue = emissive;
		this.custom1Value = custom1;
		this.custom2Value = custom2;
	}

}

