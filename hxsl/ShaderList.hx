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
		return new ShaderIterator(this,null);
	}
	public inline function iterateTo(s) {
		return new ShaderIterator(this,s);
	}
}

private class ShaderIterator {
	var l : ShaderList;
	var last : ShaderList;
	public inline function new(l,last) {
		this.l = l;
		this.last = last;
	}
	public inline function hasNext() {
		return l != last;
	}
	public inline function next() {
		var s = l.s;
		l = l.next;
		return s;
	}
}
