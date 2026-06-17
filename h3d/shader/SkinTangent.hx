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
			if ( calcPrevPos ) {
				boneMatrixX = getPrevBoneMatrix(input.indexes.x);
				boneMatrixY = getPrevBoneMatrix(input.indexes.y);
				boneMatrixZ = getPrevBoneMatrix(input.indexes.z);
				boneMatrixW = getPrevBoneMatrix(input.indexes.w);
				skinWeights = vec4(input.weights, 0.0);
				if ( fourBonesByVertex )
					skinWeights.w = 1 - (input.weights.x + input.weights.y + input.weights.z);

				previousTransformedPosition = applySkinPoint(relativePosition);
			}

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

			if ( !calcPrevPos )
				previousTransformedPosition = transformedPosition;
		}

	};

}