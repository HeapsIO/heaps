package hxd.res;

class Model extends Resource {
	
	public static var isLeftHanded = true;
	
	public function toFbx() : h3d.fbx.Library {
		var lib = new h3d.fbx.Library();
		switch( entry.getSign() & 0xFF ) {
		case ';'.code: // FBX
			lib.load(h3d.fbx.Parser.parse(entry.getBytes().toString()));
		case 'X'.code: // XBX
			var f = new haxe.io.BytesInput(entry.getBytes());
			var xbx = new h3d.fbx.XBXReader(f).read();
			lib.load(xbx);
			f.close();
		default:
			throw "Unsupported model format " + entry.path;
		}
		if( isLeftHanded ) lib.leftHandConvert();
		return lib;
	}
	
}