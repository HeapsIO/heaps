package h3d.dae;

class BAEFile extends flash.utils.ByteArray {
	
	public function getModel() {
		return new h3d.prim.DAEModel(new BAEReader(new haxe.io.BytesInput(haxe.io.Bytes.ofData(this))).read());
	}
	
}