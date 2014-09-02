package hxsl;

abstract GlobalSlot<T>(Int) {
	public inline function new(name:String) {
		this = Globals.allocID(name);
	}
	public inline function toInt() {
		return this;
	}
	public inline function set( globals : Globals, v : T ) {
		globals.fastSet(toInt(), v);
	}
	public inline function get( globals : Globals ) : T {
		return globals.fastGet(toInt());
	}
}

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

	static var ALL;
	static var MAP;
	public static function allocID( path : String ) {
		if( MAP == null ) {
			#if flash
			MAP = new haxe.ds.UnsafeStringMap<Int>();
			#else
			MAP = new Map();
			#end
			ALL = [];
		}
		var id = MAP.get(path);
		if( id == null ) {
			id = ALL.length;
			ALL.push(path);
			MAP.set(path, id);
		}
		return id;
	}

}