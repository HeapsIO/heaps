package h3d.shader;

class CubeMap extends hxsl.Shader {

	static var SRC = {

		var pixelColor : Vec4;
		var transformedNormal : Vec3;

		@param var texture : SamplerCube;

		function fragment() {
			pixelColor.rgb *= texture.get(transformedNormal).rgb;
		}

	}

	public function new(texture) {
		super();
		this.texture = texture;
	}

}