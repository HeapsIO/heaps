package h3d.shader;

class CubeMap extends hxsl.Shader {

	static var SRC = {

		var pixelColor : Vec4;
		var transformedNormal : Vec3;

		@const var reflection : Bool;
		@param var texture : SamplerCube;
		@global var camera : {
			var position : Vec3;
		};
		var pixelTransformedPosition : Vec3;

		function fragment() {
			var n = if( reflection ) reflect(-normalize(camera.position - pixelTransformedPosition), transformedNormal) else transformedNormal;
			pixelColor.rgb *= texture.get(n).rgb;
		}

	}

	public function new(texture, reflection=false) {
		super();
		this.texture = texture;
		this.reflection = reflection;
	}

}