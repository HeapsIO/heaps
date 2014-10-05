package hxd.fmt.h3d;

class Library {

	var entry : hxd.res.FileEntry;
	var header : Data;

	public function new(entry, header) {
		this.entry = entry;
		this.header = header;
	}

	public function makeObject( ?loadTexture : String -> h3d.mat.Texture ) : h3d.scene.Object {
		if( loadTexture == null )
			loadTexture = function(_) return h3d.mat.Texture.fromColor(0xFF00FF);
		throw "TODO";
		return null;
	}

	public function loadAnimation( mode : h3d.anim.Mode, ?name : String ) : h3d.anim.Animation {
		throw "TODO";
		return null;
	}

}