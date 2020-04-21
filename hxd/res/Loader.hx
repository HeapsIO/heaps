package hxd.res;

class Loader {

	/**
		Set when initializing hxd.Res, or manually.
		Allows code to resolve resources without compiling hxd.Res
	*/
	public static var currentInstance : Loader;

	public var fs(default,null) : hxd.fs.FileSystem;
	var cache : Map<String,Dynamic>;

	public function new(fs) {
		this.fs = fs;
		cache = new Map<String,Dynamic>();
	}

	public function cleanCache() {
		cache = new Map();
	}

	public function dir( path : String ) : Array<Any> {
		var r : Array<Any> = [];
		var entries = fs.dir(path);
		for(e in entries)
			r.push(new Any(this, e));
		return r;
	}

	public function exists( path : String ) : Bool {
		return fs.exists(path);
	}

	public function load( path : String ) : Any {
		return new Any(this, fs.get(path));
	}

	public function loadCache<T:hxd.res.Resource>( path : String, c : Class<T> ) : T {
		var res : T = cache.get(path);
		if( res == null ) {
			var entry = fs.get(path);
			var old = currentInstance;
			currentInstance = this;
			res = Type.createInstance(c, [entry]);
			currentInstance = old;
			cache.set(path, res);
		} else {
			if( hxd.impl.Api.downcast(res,c) == null )
				throw path+" has been reintrepreted from "+Type.getClass(res)+" to "+c;
		}
		return res;
	}

	public function dispose() {
		cleanCache();
		fs.dispose();
	}

}