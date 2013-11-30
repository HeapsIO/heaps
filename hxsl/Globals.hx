package hxsl;

class Globals {

	var map : Map<Int,Dynamic>;
	
	public function new() {
		map = new Map<Int,Dynamic>();
	}
	
	public function set( path : String, v : Dynamic ) {
		map.set(allocID(path), v);
	}

	public function get( path : String) : Dynamic {
		return map.get(allocID(path));
	}

	public inline function fastSet( id : Int, v : Dynamic ) {
		map.set(id, v);
	}

	public inline function fastGet( id : Int ) : Dynamic {
		return map.get(id);
	}

	static var ALL = [];
	static var MAP = new Map();
	public static function allocID( path : String ) {
		var id = MAP.get(path);
		if( id == null ) {
			id = ALL.length;
			ALL.push(path);
			MAP.set(path, id);
		}
		return id;
	}
	
}