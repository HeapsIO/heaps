package h3d.shader;

class Skin extends SkinBase {

	static var SRC = {

		@input var input : {
			var position : Vec3;
			var normal : Vec3;
			var weights : Vec3;
			var indexes : Bytes4;
		};

		var transformedTangent : Vec4;

		function vertex() {
			transformedPosition =
				(relativePosition * bonesMatrixes[int(input.indexes.x)]) * input.weights.x +
				(relativePosition * bonesMatrixes[int(input.indexes.y)]) * input.weights.y +
				(relativePosition * bonesMatrixes[int(input.indexes.z)]) * input.weights.z;
			transformedNormal = 
				(input.normal * mat3(bonesMatrixes[int(input.indexes.x)])) * input.weights.x +
				(input.normal * mat3(bonesMatrixes[int(input.indexes.y)])) * input.weights.y +
				(input.normal * mat3(bonesMatrixes[int(input.indexes.z)])) * input.weights.z;

			if(fourBonesByVertex) {
				var w4 = 1 - (input.weights.x + input.weights.y + input.weights.z);
				transformedPosition += (relativePosition * bonesMatrixes[int(input.indexes.w)]) * w4;
				transformedNormal += (input.normal * mat3(bonesMatrixes[int(input.indexes.z)])) * w4;
			}
			
			transformedNormal = normalize(transformedNormal);
		}

	};

}