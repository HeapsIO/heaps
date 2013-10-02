package hxd.res;

@:access(hxd.res.Loader)
class Any extends Resource {

	var loader : Loader;
	
	public function new(loader, entry) {
		super(entry);
		this.loader = loader;
	}
	
	public function toModel() {
		return loader.loadModel(entry.path);
	}
	
	public function toFbx() {
		return loader.loadModel(entry.path).toFbx();
	}

	public function toTexture() {
		return loader.loadTexture(entry.path).toTexture();
	}
	
	public function toTile() {
		return loader.loadTexture(entry.path).toTile();
	}
	
	public function toString() {
		return entry.getBytes().toString();
	}

	public function getTexture() {
		return loader.loadTexture(entry.path);
	}
	
	public function toSound() {
		return loader.loadSound(entry.path);
	}

	public function toFont() {
		return loader.loadFont(entry.path);
	}

	public function toBitmapFont() {
		return loader.loadBitmapFont(entry.path);
	}

	public inline function iterator() {
		return new hxd.impl.ArrayIterator([for( f in entry ) new Any(loader,f)]);
	}

}