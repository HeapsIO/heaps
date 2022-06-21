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

	public static function addSort( s : Shader, shaders : ShaderList ) {
		var prev = null;
		var hd = shaders;
		// sort by ascending priority
		while( hd != null && hd.s.priority < s.priority ) {
			prev = hd;
			hd = hd.next;
		}
		if( prev == null ) {
			var l = new ShaderList(s, shaders);
			checkSize(l);
			return l;
		}
		prev.next = new ShaderList(s, prev.next);
		checkSize(shaders);
		return shaders;
	}

	public static var MAX_LIST_SIZE = 0;
	public static var ALLOW_DUPLICATES = true;
	static function checkSize(list : ShaderList) {
		if(MAX_LIST_SIZE <= 0)
			return;
		var hd = list;
		var count = 0;
		while(hd != null) {
			if(!ALLOW_DUPLICATES && hd.next != null && hd.next.s == hd.s)
				throw "Duplicate shader " + Std.string(hd.s);
			++count;
			hd = hd.next;
		}
		if(count > MAX_LIST_SIZE)
			throw "Too many shaders";
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
