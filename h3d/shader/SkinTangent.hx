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
				boneMatrixX = prevBonesMatrixes[int(input.indexes.x)];
				boneMatrixY = prevBonesMatrixes[int(input.indexes.y)];
				boneMatrixZ = prevBonesMatrixes[int(input.indexes.z)];
				boneMatrixW = prevBonesMatrixes[int(input.indexes.w)];
				skinWeights = vec4(input.weights, 0.0);
				if ( fourBonesByVertex )
					skinWeights.w = 1 - (input.weights.x + input.weights.y + input.weights.z);

				previousTransformedPosition = applySkinPoint(relativePosition);
			}

			boneMatrixX = bonesMatrixes[int(input.indexes.x)];
			boneMatrixY = bonesMatrixes[int(input.indexes.y)];
			boneMatrixZ = bonesMatrixes[int(input.indexes.z)];
			boneMatrixW = bonesMatrixes[int(input.indexes.w)];
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