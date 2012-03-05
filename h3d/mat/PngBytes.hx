package h3d.mat;

class PngBytes extends flash.utils.ByteArray {

	public function getBitmapBytes() {
		var mem = new haxe.io.BytesInput(haxe.io.Bytes.ofData(this));
		var png = new format.png.Reader(mem);
		var data = png.read();
		var h = format.png.Tools.getHeader(data);
		var data = format.png.Tools.extract32(data);
		return new Bitmap(h.width, h.height, data);
	}
	
}