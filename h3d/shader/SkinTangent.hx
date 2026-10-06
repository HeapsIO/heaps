package h3d.shader;

class SkinTangent extends SkinBase {

	static var SRC = {

		@:import h3d.shader.Skin.Utils;

		@input var input : {
			var position : Vec3;
			var normal : Vec3;
			var tangent : Vec3;
			var weights : Vec3;
			var indexes : Bytes4;
		};

		var transformedTangent : Vec4;
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
			transformedTangent.xyz = applySkinVec(input.tangent.xyz);

			transformedNormal = normalize(transformedNormal);
			transformedTangent.xyz = normalize(transformedTangent.xyz);

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