package hxd.res;

class Any extends Resource {
		
	public function toFbx() {
		return new Model(entry).toFbx();
	}

	public function toTexture() {
		return new Texture(entry).toTexture();
	}
	
	public function toTile() {
		return new Texture(entry).toTile();
	}

	public function toSound() {
		return new Sound(entry);
	}
	
	public function toDir() {
		if( !entry.isDirectory ) throw entry.path + " is not a directory ";
		return new Directory(entry);
	}
	
}