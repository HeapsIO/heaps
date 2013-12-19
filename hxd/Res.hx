package hxd;


@:build(hxd.res.FileTree.build())
class Res {
	
	public static function load(name:String) {
		return loader.load(name);
	}
	
}
