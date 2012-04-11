package h3d.prim;

class BAEFile extends flash.utils.ByteArray {
	
	public function getModel() {
		return new DAEModel(new h3d.impl.DAE.BAEReader(new haxe.io.BytesInput(haxe.io.Bytes.ofData(this))).read());
	}
	
}