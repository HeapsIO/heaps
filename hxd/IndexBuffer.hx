package hxd;

private typedef InnerData = #if flash flash.Vector<UInt> #else Array<hxd.impl.UInt16> #end

private class InnerIterator {
	var b : InnerData;
	var len : Int;
	var pos : Int;
	public inline function new( b : InnerData )  {
		this.b = b;
		this.len = this.b.length;
		this.pos = 0;
	}
	public inline function hasNext() {
		return pos < len;
	}
	public inline function next() : Int {
		return b[pos++];
	}
}

abstract IndexBuffer(InnerData) {

	public var length(get, never) : Int;

	public inline function new(length = 0) {
		#if js
		this = #if (haxe_ver >= 4) js.Syntax.construct #else untyped __new__ #end(Array, length);
		#elseif flash
		this = new InnerData(length);
		#else
		this = new InnerData();
		if( length > 0 ) grow(length);
		#end
	}

	public inline function push( v : Int ) {
		#if flash
		this[this.length] = v;
		#else
		this.push(v);
		#end
	}

	public inline function grow( v : Int ) {
		#if flash
		if( v > this.length ) this.length = v;
		#elseif js
		while( this.length < v ) this.push(0);
		#else
		if( v > this.length ) this[v - 1] = 0;
		#end
	}

	@:arrayAccess inline function arrayRead(key:Int) : Int {
		return this[key];
	}

	@:arrayAccess inline function arrayWrite(key:Int, value : Int) : Int {
		return this[key] = value;
	}

	public inline function getNative() : InnerData {
		return this;
	}

	public inline function iterator() {
		return new InnerIterator(this);
	}

	inline function get_length() : Int {
		return this.length;
	}

}