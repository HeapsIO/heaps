package hxd.fmt;

abstract class Parser<T> {
	public function new() {
	}

	public abstract function read( data : haxe.io.Bytes ) : T;
}
