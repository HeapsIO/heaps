package h3d.shader.pbr;

class PropsDefinition extends hxsl.Shader {

	static var SRC = {
		var albedo : Vec3;
		var depth : Float;
		var normal : Vec3;
		var metalness : Float;
		var roughness : Float;
		var occlusion : Float;
		var specularColor : Vec3;
		var transformedPosition : Vec3;

		var view : Vec3;
		var NdV : Float;

		@param var cameraPosition : Vec3;
		var pixelColor : Vec4;

		function __init__fragment() {
			pixelColor = vec4(0.,0.,0.,1.);
			{
				view = (cameraPosition - transformedPosition).normalize();
				NdV = normal.dot(view).max(0.);
			}
		}

		function calcG(v:Vec3) : Float {
			var k = (roughness + 1).pow(2) / 8;// (roughness * roughness) / 2;
			return NdV / (NdV * (1 - k) + k);
		}

	}

}
