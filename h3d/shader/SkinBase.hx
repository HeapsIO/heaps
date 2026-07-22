package h3d.shader;

class SkinBase extends hxsl.Shader {

	static var SRC = {

		var relativePosition : Vec3;
		var transformedPosition : Vec3;
		var transformedNormal : Vec3;

		@const(1024) var BUFFER_SIZE : Int;  // MAX_SHADER_BONES x3 vec4 per mat3x4
		@const @param var fourBonesByVertex = false;
		@const var calcPrevPos : Bool = false;

		@param var bonesMatrixes : Buffer<Vec4, BUFFER_SIZE>;
		@param var prevBonesMatrixes : Buffer<Vec4, BUFFER_SIZE>;

		function getBoneMatrix( index : Float ) : Mat3x4 {
			var i = int(index) * 3;
			return mat3x4(bonesMatrixes[i], bonesMatrixes[i + 1], bonesMatrixes[i + 2]);
		}

		function getPrevBoneMatrix( index : Float ) : Mat3x4 {
			var i = int(index) * 3;
			return mat3x4(prevBonesMatrixes[i], prevBonesMatrixes[i + 1], prevBonesMatrixes[i + 2]);
		}
	};
}
