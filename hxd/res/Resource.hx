package hxd.res;

class Resource {
	
	public var name(get, never) : String;
	var entry : FileEntry;
	
	public function new(entry) {
		this.entry = entry;
	}
	
	inline function get_name() {
		return entry.name;
	}
	
}