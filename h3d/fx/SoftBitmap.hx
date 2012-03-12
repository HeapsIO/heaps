package h3d.fx;

class SoftBitmap extends Bitmap {

	var root : flash.display.Sprite;
	var bdata : flash.display.BitmapData;
	var view : flash.display.Bitmap;
	
	public function new(bmp,root) {
		super(bmp);
		this.root = root;
		bdata = new flash.display.BitmapData(bmp.width, bmp.height);
		var bytes = bmp.bytes.getData();
		bytes.position = 0;
		bytes.endian = flash.utils.Endian.LITTLE_ENDIAN;
		bdata.setPixels(bdata.rect, bytes);
		view = new flash.display.Bitmap(bdata);
	}
	
	override function render(engine:h3d.Engine) {
		view.visible = visible;
		if( !visible ) return;
		
		root.addChild(view);
		view.alpha = alpha;
		view.x = x;
		view.y = y;
		view.scaleX = scaleX;
		view.scaleY = scaleY;
	}
	
}