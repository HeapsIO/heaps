package hxd.res;

private class SingleFileSystem extends hxd.fs.BytesFileSystem {

	var path : String;
	var bytes : haxe.io.Bytes;

	public function new(path, bytes) {
		super();
		this.path = path;
		this.bytes = bytes;
	}

	override function getBytes(p) {
		return p == path ? bytes : null;
	}

}

@:access(hxd.res.Loader)
class Any extends Resource {

	var loader : Loader;

	public function new(loader, entry) {
		super(entry);
		this.loader = loader;
	}

	public function toModel() {
		return loader.loadCache(entry.path, hxd.res.Model);
	}

	public function toTexture() {
		return toImage().toTexture();
	}

	public function toTile() {
		return toImage().toTile();
	}

	public function toText() {
		return entry.getText();
	}

	public function toImage() {
		return loader.loadCache(entry.path, hxd.res.Image);
	}

	public function toSound() {
		return loader.loadCache(entry.path, hxd.res.Sound);
	}

	public function toPrefab() {
		return loader.loadCache(entry.path, hxd.res.Prefab);
	}

	public function to<T:hxd.res.Resource>( c : Class<T> ) : T {
		return loader.loadCache(entry.path, c);
	}

	public inline function iterator() {
		return new hxd.impl.ArrayIterator([for( f in entry ) new Any(loader,f)]);
	}

	public static function fromBytes( path : String, bytes : haxe.io.Bytes ) {
		var fs = new SingleFileSystem(path,bytes);
		return new Loader(fs).load(path);
	}

}