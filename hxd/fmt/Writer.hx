package hxd.fmt;

class Writer {
	var out : haxe.io.Output;
	var version : Int;

	public function new(out) {
		this.out = out;
	}

	public function write(l : hxd.fmt.Library) {
		throw "Should be implemented";
	}
}