package h3d.impl;

@:allow(h3d.impl.Driver)
class InstanceBuffer {

	var data : Dynamic;
	var driver : h3d.impl.Driver;
	var indexCount : Int;
	var startIndex : Int;
	public var triCount(default,null) : Int = 0;
	public var commandCount(default, null) : Int;

	public function new() {
	}

	public function setCommand( commandCount : Int, indexCount : Int, startIndex=0 ) {
		this.commandCount = commandCount;
		this.indexCount = indexCount;
		this.triCount = Std.int((commandCount * indexCount) / 3);
		this.startIndex = startIndex;
	}

	/**
		Bytes are structures of 5 i32 with the following values:
		- indexCount : number of indexes per instance
		- instanceCount : number of indexed draws
		- startIndexLocation : offset in indexes
		- baseVertexLocation : offset in buffer
		- startInstanceLocation : offset in per instance buffer
	**/
	public function setBuffer( commandCount : Int, bytes : haxe.io.Bytes ) {
		dispose();

		for( i in 0...commandCount ) {
			var idxCount = bytes.getInt32(i * 20);
			var instCount = bytes.getInt32(i * 20 + 4);
			var tri = Std.int((idxCount * instCount) / 3);
			triCount += tri;
		}

		this.commandCount = commandCount;
		this.indexCount = 0;
		driver = h3d.Engine.getCurrent().driver;
		driver.allocInstanceBuffer(this, bytes);
	}

	public function dispose() {
		if( data != null ) driver.disposeInstanceBuffer(this);
	}

}