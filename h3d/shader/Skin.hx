package h3d.shader;

class Utils extends hxsl.Shader {
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
			if( skinWeights.w > 0.0 )
				transformed += (p * boneMatrixW) * skinWeights.w;
			return transformed;
		}

		function applySkinVec(v : Vec3) : Vec3 {
			var transformed = (v * mat3(boneMatrixX)) * skinWeights.x +
			                  (v * mat3(boneMatrixY)) * skinWeights.y +
			                  (v * mat3(boneMatrixZ)) * skinWeights.z;
			if( skinWeights.w > 0.0 )
				transformed += (v * mat3(boneMatrixW)) * skinWeights.w;
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

		var previousTransformedPosition : Vec3;

		function vertex() {
			boneMatrixX = getBoneMatrix(input.indexes.x);
			boneMatrixY = getBoneMatrix(input.indexes.y);
			boneMatrixZ = getBoneMatrix(input.indexes.z);
			boneMatrixW = getBoneMatrix(input.indexes.w);
			skinWeights = vec4(input.weights, 0.0);
			if ( fourBonesByVertex )
				skinWeights.w = 1 - (input.weights.x + input.weights.y + input.weights.z);

			transformedPosition = applySkinPoint(relativePosition);
			transformedNormal = applySkinVec(input.normal);

			transformedNormal = normalize(transformedNormal);

			// Kept in a local: Dce only drops writes to unused vars, so going through boneMatrix* would keep prevBonesMatrixes alive when not needed
			var prevPosition = (relativePosition * getPrevBoneMatrix(input.indexes.x)) * skinWeights.x +
			                   (relativePosition * getPrevBoneMatrix(input.indexes.y)) * skinWeights.y +
			                   (relativePosition * getPrevBoneMatrix(input.indexes.z)) * skinWeights.z;
			if( skinWeights.w > 0.0 )
				prevPosition += (relativePosition * getPrevBoneMatrix(input.indexes.w)) * skinWeights.w;
			previousTransformedPosition = prevPosition;
		}
	};
}