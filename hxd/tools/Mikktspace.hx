package hxd.tools;

class Mikktspace {
	public var buffer:hl.BytesAccess<Single>;
	public var stride:Int;
	public var xPos:Int;
	public var normalPos:Int;
	public var uvPos:Int;
	public var tangents:hl.BytesAccess<Single>;
	public var tangentStride:Int;
	public var tangentPos:Int;
	public var indexes:hl.BytesAccess<Int>;
	public var indices:Int;

	public function new() {}

	#if hl
	public function compute(threshold = 180.) {
		if (!_compute(this, threshold))
			throw "assert";
	}

	@:hlNative("fmt", "compute_mikkt_tangents")
	static function _compute(m:Dynamic, threshold:Float):Bool {
		return false;
	}
	#end
}
