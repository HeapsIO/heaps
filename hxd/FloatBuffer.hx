package hxd;

private typedef InnerData = #if flash flash.Vector<Float> #else Array<Float> #end

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
	public inline function next() {
		return b[pos++];
	}
}

abstract FloatBuffer(InnerData) {

	public var length(get, never) : Int;

	public inline function new(length = 0) {
		#if js
		this = untyped __new__(Array, length);
		#elseif cpp
		this = new InnerData();
		#else
		this = new InnerData(length);
		#end
	}

	public inline function push( v : Float ) {
		#if flash
		this[this.length] = v;
		#else
		this.push(v);
		#end
	}

	public inline function grow( v : Int ) {
		#if flash
		if( v > this.length ) this.length = v;
		#else
		while( this.length < v ) this.push(0.);
		#end
	}

	public inline function resize( v : Int ) {
		#if flash
		this.length = v;
		#else
		while( this.length < v ) this.push(0.);
		if( this.length > v ) this.splice(v, this.length - v);
		#end
	}


	@:arrayAccess inline function arrayRead(key:Int) : Float {
		return this[key];
	}

	@:arrayAccess inline function arrayWrite(key:Int, value : Float) : Float {
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