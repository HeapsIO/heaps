package hxd;
import hxd.impl.TypedArray;

private typedef InnerData = #if flash flash.Vector<Float> #elseif js Float32Expand #else Array<hxd.impl.Float32> #end

#if js
private abstract Float32Expand({ pos : Int, array : hxd.impl.TypedArray.Float32Array }) {

	public var length(get, set) : Int;

	public function new(length) {
		this = { pos : length, array : new Float32Array(new ArrayBuffer(length<<2)) };
	}

	inline function get_length() return this.pos;
	inline function set_length(v:Int) {
		if( length != v ) {
			var newArray = new Float32Array(v);
			newArray.set(this.array);
			this.array = newArray;
		}
		this.pos = v;
		return v;
	}

	public inline function push(v:Float) {
		if( this.pos == this.array.length ) {
			var newSize = this.array.length << 1;
			if( newSize < 128 ) newSize = 128;
			var newArray = new Float32Array(newSize);
			newArray.set(this.array);
			this.array = newArray;
		}
		this.array[this.pos++] = v;
	}

	@:arrayAccess inline function get(index) return this.array[index];
	@:arrayAccess inline function set(index,v:Float) return this.array[index] = v;

	@:to inline function toF32Array() return this.array;
	@:to inline function toArray() return [for( i in 0...this.pos ) this.array[i]];

}
#end

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
		#if (flash || js)
		this = new InnerData(length);
		#else
		this = new InnerData();
		if( length > 0 ) grow(length);
		#end
	}

	public inline function push( v : hxd.impl.Float32 ) {
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
		for( i in this.length...v )
			this.push(0.);
		#else
		if( v > this.length ) this[v - 1] = 0.;
		#end
	}

	public inline function resize( v : Int ) {
		#if (flash||js)
		this.length = v;
		#else
		if( this.length > v ) this.splice(v, this.length - v) else grow(v);
		#end
	}


	@:arrayAccess inline function arrayRead(key:Int) : hxd.impl.Float32 {
		return this[key];
	}

	@:arrayAccess inline function arrayWrite(key:Int, value : hxd.impl.Float32) : hxd.impl.Float32 {
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