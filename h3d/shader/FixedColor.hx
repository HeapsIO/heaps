package h3d.shader;

class FixedColor extends hxsl.Shader {

	static var SRC = {
		@param var colorID : Vec4;
		@param var viewport : Vec4;
		var output : {
			position : Vec4,
			pickPosition : Vec4,
			colorID : Vec4
		};
		function vertex() {
			output.pickPosition = (output.position + vec4(viewport.xy, 0., 0.) * output.position.w) * vec4(viewport.zw, 1., 1.);
		}
		function fragment() {
			output.colorID = colorID;
		}
	}

}