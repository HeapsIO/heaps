package hxd.res;

class Resource {

	public static var LIVE_UPDATE = #if debug true #else false #end;

	public var name(get, never) : String;
	public var entry(default,null) : hxd.fs.FileEntry;

	public function new(entry) {
		this.entry = entry;
	}

	inline function get_name() {
		return entry.name;
	}

	function toString() {
		return entry.path;
	}

	public function watch( onChanged : Null < Void -> Void > ) {
		if( LIVE_UPDATE	) entry.watch(onChanged);
	}

}