package hxsl;

class ShaderList {
	public var s : hxsl.Shader;
	public var next : ShaderList;
	public function new(s, ?n) {
		this.s = s;
		this.next = n;
	}
	public function clone() {
		return new ShaderList(s.clone(), next == null ? null : next.clone());
	}
	public inline function iterator() {
		return new ShaderIterator(this);
	}
}

private class ShaderIterator {
	var l : ShaderList;
	public inline function new(l) {
		this.l = l;
	}
	public inline function hasNext() {
		return l != null;
	}
	public inline function next() {
		var s = l.s;
		l = l.next;
		return s;
	}
}
