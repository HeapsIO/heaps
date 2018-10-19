package h3d.shader.pbr;

class Brush extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.Base2d;
		@param var strength : Float;
		@param var size : Float;
		@param var pos : Vec3;

		function fragment() {
			var tileUV = pos.xy + calculatedUV * size;
			pixelColor = vec4((textureColor * strength).rgb, textureColor.r);
		}
	}
}
