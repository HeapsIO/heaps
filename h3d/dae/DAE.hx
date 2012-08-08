package h3d.dae;

typedef DAE = {
	var name : String;
	@:optional var attribs : Null<Array<{ n : String, v : DAEValue }>>;
	@:optional var subs : Null<Array<DAE>>;
	@:optional var value : Null<DAEValue>;
}

typedef DAETable<T> = #if flash flash.Vector<T> #else Array<T> #end

enum DAEValue {
	DEmpty;
	DInt( v : Int );
	DFloat( v : Float );
	DBool( b : Bool );
	DString( v : String );
	DIntArray( v : DAETable<Int>, group : Int );
	DFloatArray( v : DAETable<Float>, group : Int );
}
