package hxd.res;

class FbxModel extends Resource {

	public static var isLeftHanded = true;

	public function toFbx( ?loader : Loader ) : hxd.fmt.fbx.Library {
		var lib = new hxd.fmt.fbx.Library();
		switch( entry.getSign() & 0xFF ) {
		case ';'.code: // FBX
			lib.load(hxd.fmt.fbx.Parser.parse(entry.getBytes().toString()));
		case 'X'.code: // XBX
			var f = new haxe.io.BytesInput(entry.getBytes());
			var xbx = new hxd.fmt.fbx.XBXReader(f).read();
			lib.load(xbx);
			f.close();
		case '<'.code: // XTRA
			if( loader == null ) throw "Loader parameter required for XTRA";
			lib = loader.load(entry.path.substr(0, -4) + "FBX").toFbx();
			lib.loadXtra(entry.getBytes().toString());
		case 'H'.code:
			throw "FBX model was converted to H3D : use res.toH3d()";
		default:
			throw "Unsupported model format " + entry.path;
		}
		if( isLeftHanded ) lib.leftHandConvert();
		return lib;
	}

	public function toH3d() : hxd.fmt.h3d.Library {
		var h3d = new hxd.fmt.h3d.Reader(new FileInput(entry)).readHeader();
		return new hxd.fmt.h3d.Library(entry, h3d);
	}

}