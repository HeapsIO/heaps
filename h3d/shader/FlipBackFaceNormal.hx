package h3d.shader;

class FlipBackFaceNormal extends hxsl.Shader {

    static var SRC = {

        var transformedNormal : Vec3;

		function __init__fragment() {
			if ( !frontFacing )
				transformedNormal *= -1.0;
		}
     };
}