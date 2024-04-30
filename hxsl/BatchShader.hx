package hxsl;

class BatchShader extends hxsl.Shader {

	static var SRC = {
		@const var Batch_HasOffset : Bool;
		@const var Batch_UseStorage : Bool;
		@const(4096) var Batch_Count : Int;
		@param var Batch_Buffer : Buffer<Vec4,Batch_Count>;
		@param var Batch_StorageBuffer : RWBuffer<Vec4>;
	};

	public var params : RuntimeShader.AllocParam;
	public var paramsSize : Int;

}