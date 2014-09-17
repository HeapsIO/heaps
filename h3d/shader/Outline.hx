package h3d.shader;

class Outline extends hxsl.Shader {

	static var SRC = {

		@:import BaseMesh;

		@param var size : Float;
		@param var distance : Float;
		@param var color : Vec4;

		function __init__vertex() {
			transformedPosition += transformedNormal * size;
		}

		function vertex() {
			projectedPosition.z -= distance * projectedPosition.w;
		}

		function fragment() {
			output.color = color;
		}

	};

}