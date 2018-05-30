package h3d.shader.pbr;

class PropsValues extends hxsl.Shader {

	static var SRC = {

		var output : {
			metalness : Float,
			roughness : Float,
			occlusion : Float,
		};

		@param var metalness : Float;
		@param var roughness : Float;
		@param var occlusion : Float;

		function fragment() {
			output.metalness = metalness;
			output.roughness = roughness;
			output.occlusion = occlusion;
		}

	};

	public function new(metalness=0.,roughness=1.,occlusion=0.) {
		super();
		this.metalness = metalness;
		this.roughness = roughness;
		this.occlusion = occlusion;
	}

}

