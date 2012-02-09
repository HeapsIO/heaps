package h3d.impl;

class Indexes {

	public var ibuf : flash.display3D.IndexBuffer3D;
	public var count : Int;
	
	public function new(ibuf,count) {
		this.ibuf = ibuf;
		this.count = count;
	}
	
	public function dispose() {
		ibuf.dispose();
		ibuf = null;
	}

}