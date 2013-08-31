package hxd;

private abstract Lazy(String) {
	public function new(resPath) {
		this = resPath;
	}
}

@:build(hxd.res.FileTree.build())
class Res {
	
	public static function load(name:String) {
		return loader.load(name);
	}
	
}
