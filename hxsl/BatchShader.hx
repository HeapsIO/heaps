package hxsl;

class BatchShader extends hxsl.Shader {

	static var SRC = {
		@const(4096) var Batch_Count : Int; // Max 64KB
		@param var Batch_Buffer : Buffer<Vec4,Batch_Count>;
	};

}