package hxd;

#if !cpp
typedef UString = String;
#else
typedef UString = UStringImpl;

abstract UStringImpl(String) from String to String {

	public var length(get,never) : Int;

	inline function get_length() : Int {
		return haxe.Utf8.length(this);
	}

	@:op(a + b) inline static function add( a : UStringImpl, b : UStringImpl ) : String {
		return (a:String) + (b:String);
	}

	public inline function charCodeAt( pos : Int ) : Int {
		return haxe.Utf8.charCodeAt( this, pos );
	}

	public inline function substr( pos : Int, #if (flash || hl || cpp) len = 0x7fffffff #else ?len : Int #end ) : UStringImpl {
		return haxe.Utf8.sub( this, pos, len );
	}

	public inline function charAt( pos : Int ) : UStringImpl {
		return haxe.Utf8.sub( this, pos, 1 );
	}

}

#end
