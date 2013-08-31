package hxd.res;

class Directory extends Resource {
	
	public inline function iterator() {
		return new hxd.impl.ArrayIterator([for( f in entry ) new Any(f)]);
	}
	
	public function exists( name : String ) {
		return entry.exists(name);
	}

	public function get( name : String ) {
		return new Any(entry.get(name));
	}

}