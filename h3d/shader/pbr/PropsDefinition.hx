package h3d.shader.pbr;

class PropsDefinition extends hxsl.Shader {

	static var SRC = {
		var albedo : Vec3;
		var depth : Float;
		var normal : Vec3;
		var metalness : Float;
		var roughness : Float;
		var occlusion : Float;
		var emissive : Float;
		var custom1 : Float;
		var custom2 : Float;
		var pbrSpecularColor : Vec3;
		var transformedPosition : Vec3;

		var view : Vec3;
		var NdV : Float;

		@param var cameraPosition : Vec3;
		var pixelColor : Vec4;
		var shadow : Float;

		function __init__fragment() {
			shadow = 1.;
			pixelColor = vec4(0.,0.,0.,1.);
			{
				view = (cameraPosition - transformedPosition).normalize();
				NdV = normal.dot(view).max(0.);
			}
		}

	}

}
