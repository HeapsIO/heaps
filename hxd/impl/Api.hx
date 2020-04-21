package hxd.impl;

class Api {

	public static inline function downcast<T:{},S:T>( value : T, c : Class<S> ) : S {
		#if haxe4
		return Std.downcast(value,c);
		#else
		return Std.instance(value,c);
		#end
	}

}