package h3d.shader;

class Utils  extends hxsl.Shader {
	static var SRC = {
		var boneMatrixX : Mat3x4;
		var boneMatrixY : Mat3x4;
		var boneMatrixZ : Mat3x4;
		var boneMatrixW : Mat3x4;

		var skinWeights : Vec4;

		function applySkinPoint(p : Vec3) : Vec3 {
			var transformed = (p * boneMatrixX) * skinWeights.x +
					          (p * boneMatrixY) * skinWeights.y +
				              (p * boneMatrixZ) * skinWeights.z;
			if(skinWeights.w > 0.0) {
				transformed += (p * boneMatrixW) * skinWeights.w;
			}
			return transformed;
		}

		function applySkinVec(v : Vec3) : Vec3 {
			var transformed = (v * mat3(boneMatrixX)) * skinWeights.x +
			                  (v * mat3(boneMatrixY)) * skinWeights.y +
				   			  (v * mat3(boneMatrixZ)) * skinWeights.z;
			if(skinWeights.w > 0.0) {
				transformed += (v * mat3(boneMatrixW)) * skinWeights.w;
			}
			return transformed;
		}
	}
}
class Skin extends SkinBase {

	static var SRC = {

		@:import h3d.shader.Skin.Utils;

		@input var input : {
			var position : Vec3;
			var normal : Vec3;
			var weights : Vec3;
			var indexes : Bytes4;
		};

		var transformedTangent : Vec4;
		var previousTransformedPosition : Vec3;

		function vertex() {
			boneMatrixX = bonesMatrixes[int(input.indexes.x)];
			boneMatrixY = bonesMatrixes[int(input.indexes.y)];
			boneMatrixZ = bonesMatrixes[int(input.indexes.z)];
			boneMatrixW = bonesMatrixes[int(input.indexes.w)];
			skinWeights = vec4(input.weights, 0.0);
			if(fourBonesByVertex) {
				skinWeights.z = 1 - (input.weights.x + input.weights.y + input.weights.z);
			}

			transformedPosition = applySkinPoint(relativePosition);
			transformedNormal = applySkinVec(input.normal);

			previousTransformedPosition = transformedPosition;
			transformedNormal = normalize(transformedNormal);
		}
	};
}