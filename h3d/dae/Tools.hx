package h3d.dae;
import h3d.dae.DAE;

class Tools {
	
	public static function attr( n : DAE, name : String ) {
		if( n.attribs != null )
			for( a in n.attribs )
				if( a.n == name )
					return a.v;
		throw n.name + " has no attribute " + name;
	}
	
	public static function get( n : DAE, rq : String ) {
		return new Rule(n.name + "." + rq).matchSingle(n);
	}

	public static function getValue( n : DAE, rq : String, ?def : DAEValue ) {
		var n = new Rule(n.name + "." + rq).matchSingleOpt(n);
		if( n == null ) return def;
		return n.value;
	}
	
	public static function getAll( n : DAE, rq : String ) {
		return new Rule(n.name + "." + rq).match(n);
	}
	
	@:extern public static inline function makeTable<T>( a : Array<T> ) : DAETable<T> {
		#if flash
		return flash.Vector.ofArray(a);
		#else
		return a;
		#end
	}
	
	public static function toString(v:DAEValue) {
		if( v == null ) return "null";
		return switch( v ) {
		case DEmpty: "<empty>";
		case DInt(i): Std.string(i);
		case DFloat(f): Std.string(f);
		case DIntArray(a,_): a.join(" ");
		case DFloatArray(a,_): a.join(" ");
		case DBool(b): b?"true":"false";
		case DString(v): v;
		}
	}
	
	public static function toInt( v : DAEValue ) {
		if( v != null )
			switch( v ) {
			case DInt(i): return i;
			default:
			}
		throw "Invalid value " + Std.string(v);
	}
	
}
