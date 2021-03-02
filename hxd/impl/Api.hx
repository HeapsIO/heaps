package hxd.impl;

class Api {

	public static inline function downcast<T:{},S:T>( value : T, c : Class<S> ) : S {
		#if haxe4
		return Std.downcast(value,c);
		#else
		return Std.instance(value,c);
		#end
	}

	public static inline function isOfType( v : Dynamic, t : Dynamic) : Bool {
		#if (haxe_ver >= 4.1)
		return Std.isOfType(v, t);
		#else
		return Std.is(v, t);
		#end
	}

}