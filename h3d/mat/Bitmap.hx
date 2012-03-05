package h3d.mat;

class Bitmap {

	public var bytes : haxe.io.Bytes;
	public var width : Int;
	public var height : Int;
	
	public function new(w,h,b) {
		this.width = w;
		this.height = h;
		this.bytes = b;
	}
	
}