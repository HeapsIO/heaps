package hxd.res;

class Any {
	
	var path : String;
	var r : Dynamic;
	
	public function new(path, r) {
		this.path = path;
		this.r = r;
	}
	
	public function toModel() {
		var m = Std.instance(r, Model);
		if( m == null ) throw path + " is not a model";
		return m.get();
	}

	public function toTexture() {
		var t = Std.instance(r, Texture);
		if( t == null ) throw path + " is not a texture";
		return t.load();
	}

	public function toSound() {
		var s = Std.instance(r, Sound);
		if( s == null ) throw path + " is not a sound";
		return s;
	}
	
	public function toDir() {
		var d = Std.instance(r, Directory);
		if( d == null ) throw path + " is not a directory";
		return d;
	}

	public function get() {
		return r;
	}
	
}