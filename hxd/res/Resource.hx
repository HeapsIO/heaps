package hxd.res;

class Resource {
	
	public var name(get, never) : String;
	public var entry(default,null) : FileEntry;
	
	public function new(entry) {
		this.entry = entry;
	}
	
	inline function get_name() {
		return entry.name;
	}
	
	function toString() {
		return entry.path;
	}

	
}