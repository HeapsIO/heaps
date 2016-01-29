package hxd.impl;

@:generic class ArrayIterator<T> {
	var i : Int;
	var l : Int;
	var a : Array<T>;
	public inline function new(a) {
		this.i = 0;
		this.a = a;
		this.l = this.a.length;
	}
	public inline function hasNext() {
		return i < l;
	}
	public inline function next() : T {
		return a[i++];
	}
}