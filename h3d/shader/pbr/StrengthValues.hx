package h3d.shader.pbr;

class StrengthValues extends hxsl.Shader {

	static var SRC = {

		var output : {
			albedoStrength : Float,
			normalStrength : Float,
			pbrStrength : Float,
			emissiveStrength : Float
		};

		var pixelColor : Vec4;
		@param var albedoStrength : Float;
		@param var normalStrength : Float;
		@param var pbrStrength : Float;
		@param var emissiveStrength : Float;

		function fragment() {
			output.albedoStrength = albedoStrength * pixelColor.a;
			output.normalStrength = normalStrength * pixelColor.a;
			output.pbrStrength = pbrStrength * pixelColor.a;
			output.emissiveStrength = emissiveStrength * pixelColor.a;
		}

	};

	public function new(albedoStrength=1.,normalStrength=1.,pbrStrength=1., emissiveStrength=1.) {
		super();
		this.albedoStrength = albedoStrength;
		this.normalStrength = normalStrength;
		this.pbrStrength = pbrStrength;
		this.emissiveStrength = emissiveStrength;
	}

}

