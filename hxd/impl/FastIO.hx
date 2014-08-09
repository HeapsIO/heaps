package hxd.impl;

@:generic
class FastIO<T> {

	var read : Int;
	var write : Int;
	var max : Int;
	var table : #if flash flash.Vector<T> #else Array<T> #end;

	public inline function new() {
		reset();
		table = #if flash new flash.Vector() #else [] #end;
	}

	public inline function reset() {
		read = 0;
		write = 0;
		max = 0;
	}

	public inline function hasNext() {
		return read < max;
	}

	public inline function next() : T {
		return table[read++];
	}

	public inline function add( v : T ) {
		table[write++] = v;
	}

	public inline function flush( count = 1000 ) {
		if( read == write ) {
			read = write = max = 0;
		} else {
			max = write;
			if( write < read ) read = 0 else if( read > count ) write = 0;
		}
	}

}

class FastIntIO extends FastIO<Int> {

	public inline function add2d( x, y, bits ) {
		add(x | (y << bits));
	}

	public inline function add2di( x, y, d, bits ) {
		add(x | ((y | (d << bits)) << bits));
	}

	public inline function loop(callb) {
		while( true ) {
			flush((write < read ? write : (write - read)) * 4);
			if( !hasNext() )
				break;
			for( id in this )
				callb(id);
		}
	}

	public inline function rec2d( x, y, bits, callb ) {
		add2d(x, y, bits);
		while( true ) {
			flush((write < read ? write : (write - read)) * 4);
			if( !hasNext() )
				break;
			for( id in this ) {
				var x = id & ((1 << bits) - 1);
				var y = id >>> bits;
				if( !callb(x,y) )
					continue;
				add2d(x + 1, y, bits);
				add2d(x - 1, y, bits);
				add2d(x, y + 1, bits);
				add2d(x, y - 1, bits);
			}
		}
	}

	public inline function rec2di( x, y, d, bits, callb ) {
		add2di(x, y, d, bits);
		while( true ) {
			flush((write < read ? write : (write - read)) * 4);
			if( !hasNext() )
				break;
			for( id in this ) {
				var x = id & ((1 << bits) - 1);
				var y = (id >>> bits) & ((1 << bits) - 1);
				var d = id >>> (bits << 1);
				d = callb(x, y, d);
				if( d < 0 )
					continue;
				add2di(x + 1, y, d, bits);
				add2di(x - 1, y, d, bits);
				add2di(x, y + 1, d, bits);
				add2di(x, y - 1, d, bits);
			}
		}
	}

}