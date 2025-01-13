package hxsl;

class Debug {

	public static var VAR_IDS = #if shader_debug_var_ids true #else false #end;
	public static var TRACE = #if shader_debug_dump true #else false #end;

	public static macro function trace(str) {
		return macro if( hxsl.Debug.TRACE ) trace($str);
	}

	public static function varName( v : Ast.TVar, swizBits = 15 ) {
		var name = v.name;
		if( swizBits != 15 ) name += swizStr(swizBits);
		return VAR_IDS ? v.name+"@"+v.id : v.name;
	}

	static function swizStr( bits : Int ) {
		var str = ".";
		if( bits & 1 != 0 ) str += "x";
		if( bits & 2 != 0 ) str += "y";
		if( bits & 4 != 0 ) str += "z";
		if( bits & 8 != 0 ) str += "w";
		return str;
	}

	public static macro function traceDepth(str) {
		return macro if( hxsl.Debug.TRACE ) {
			var msg = $str;
			for( i in 0...debugDepth ) msg = "    " + msg;
			trace(msg);
		};
	}

}