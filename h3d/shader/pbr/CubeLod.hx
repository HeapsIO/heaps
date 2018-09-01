package h3d.shader.pbr;

class CubeLod extends hxsl.Shader {

	static var SRC = {

		var pixelColor : Vec4;
		var transformedNormal : Vec3;
		@param var texture : SamplerCube;
		@param var lod : Float;
		function fragment() {
			pixelColor.rgb *= textureLod(texture,transformedNormal,lod).rgb;
		}

	}

	public function new(?texture) {
		super();
		this.texture = texture;
	}
}
