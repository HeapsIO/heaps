package h3d.dae;

class BAEFile extends flash.utils.ByteArray {
	
	public function getLibrary() {
		return new Library(new BAEReader(new haxe.io.BytesInput(haxe.io.Bytes.ofData(this))).read());
	}
	
}