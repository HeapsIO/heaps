package h3d.shader;

class Skin extends hxsl.Shader {

	static var SRC = {

		@input var input : {
			var position : Vec3;
			var normal : Vec3;
			var tangent : Vec3;
			var weights : Vec3;
			var indexes : Bytes4;
		};

		var relativePosition : Vec3;
		var transformedPosition : Vec3;
		var transformedNormal : Vec3;
		var transformedTangent : Vec4;

		@const var MaxBones : Int;
		@ignore @param var bonesMatrixes : Array<Mat3x4,MaxBones>;

		function vertex() {
			transformedPosition =
				(relativePosition * bonesMatrixes[input.indexes.x]) * input.weights.x +
				(relativePosition * bonesMatrixes[input.indexes.y]) * input.weights.y +
				(relativePosition * bonesMatrixes[input.indexes.z]) * input.weights.z;
			transformedNormal = normalize(
				(input.normal * mat3(bonesMatrixes[input.indexes.x])) * input.weights.x +
				(input.normal * mat3(bonesMatrixes[input.indexes.y])) * input.weights.y +
				(input.normal * mat3(bonesMatrixes[input.indexes.z])) * input.weights.z);
			transformedTangent = vec4(normalize(
				(input.tangent.xyz * mat3(bonesMatrixes[input.indexes.x])) * input.weights.x +
				(input.tangent.xyz * mat3(bonesMatrixes[input.indexes.y])) * input.weights.y +
				(input.tangent.xyz * mat3(bonesMatrixes[input.indexes.z])) * input.weights.z
			), transformedTangent.w);
		}

	}

	public function new() {
		super();
		MaxBones = 34;
	}

}