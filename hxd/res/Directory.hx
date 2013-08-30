package hxd.res;

class Directory {
	
	var loader : Loader;
	var path : String;
	var dir : {};
	
	function new(loader, path, dir) {
		this.loader = loader;
		this.path = path;
		this.dir = dir;
	}
	
	public inline function iterator() {
		return new hxd.impl.ArrayIterator([for( f in Reflect.fields(dir) ) loader.load(path+"/"+f)]);
	}
	
	public function exists( name : String ) {
		return loader.load(path + "/" + name);
	}
	
}