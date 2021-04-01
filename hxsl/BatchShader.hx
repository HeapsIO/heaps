package hxsl;

class BatchShader extends hxsl.Shader {

	static var SRC = {
		@const(65536) var Batch_Count : Int;
		@param var Batch_Buffer : Buffer<Vec4,Batch_Count>;
	};

	public var params : RuntimeShader.AllocParam;
	public var paramsSize : Int;

}