package h3d.shader;

class Skin extends hxsl.Shader {

	static var SRC = {

		@input var input : {
			var position : Vec3;
			var normal : Vec3;
			var weights : Vec3;
			var indexes : Bytes4;
		};

		var transformedPosition : Vec3;
		var transformedNormal : Vec3;

		@const var MaxBones : Int;
		@param var bonesMatrixes : Array<Mat3x4,MaxBones>;

		function vertex() {
			transformedPosition =
				(input.position * bonesMatrixes[input.indexes.x]) * input.weights.x +
				(input.position * bonesMatrixes[input.indexes.y]) * input.weights.y +
				(input.position * bonesMatrixes[input.indexes.z]) * input.weights.z;
			transformedNormal = normalize(
				(input.normal * mat3(bonesMatrixes[input.indexes.x])) * input.weights.x +
				(input.normal * mat3(bonesMatrixes[input.indexes.y])) * input.weights.y +
				(input.normal * mat3(bonesMatrixes[input.indexes.z])) * input.weights.z);
		}

	}

	public function new() {
		super();
		MaxBones = 34;
	}

}