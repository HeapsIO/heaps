package h3d.shader;

class SkinBase extends hxsl.Shader {

	static var SRC = {

		var relativePosition : Vec3;
		var transformedPosition : Vec3;
		var transformedNormal : Vec3;

		@const var MaxBones : Int;
		@const @param var fourBonesByVertex = false;

		@ignore @param var bonesMatrixes : Array<Mat3x4,MaxBones>;

	};

	public function new() {
		super();
		MaxBones = 34;
	}

}
