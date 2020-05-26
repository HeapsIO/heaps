import h2d.RenderContext;
import h2d.Object;

class Mask extends hxd.App {

	var obj : h2d.Object;
	var mask : h2d.Mask;
	var time : Float = 0.;

	var apiMask : MaskWithSample;

	override function init() {
		mask = new h2d.Mask(160, 160, s2d);
		mask.x = 20;
		mask.y = 50;

		// Mask-sized rectangle to display mask boundaries
		// and make scroll movement more apparent.
		new h2d.Bitmap(h2d.Tile.fromColor(0x222222, mask.width, mask.height), mask);
		// Limit scroll
		mask.scrollBounds = h2d.col.Bounds.fromValues(-mask.width/2, -mask.height/2,mask.width*2, mask.height*2);

		obj = new h2d.Object(mask);
		obj.x = obj.y = 80;
		for( i in 0...10 ) {
			var b = new h2d.Bitmap(hxd.Res.hxlogo.toTile(), obj);
			b.scale(0.4);
			b.x = Std.random(200) - 100;
			b.y = Std.random(200) - 100;
		}
		var info = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
		info.setPosition(5, 5);
		info.text = "Arrows: move scrollX/Y\nSpace: reset scroll to 0,0";

		// Content masking also possible with advanced `Mask.maskWith` and `Mask.unmask` methods.
		apiMask = new MaskWithSample(s2d);
		apiMask.setPosition(200, 50);
	}

	override function update(dt:Float) {
		time += dt;
		obj.rotation += 0.6 * dt;
		apiMask.sx = Math.cos(time) * 100 + 100;
		apiMask.sy = Math.sin(time) * 100 + 100;

		if (hxd.Key.isDown(hxd.Key.LEFT)) mask.scrollX -= 100 * dt;
		if (hxd.Key.isDown(hxd.Key.RIGHT)) mask.scrollX += 100 * dt;
		if (hxd.Key.isDown(hxd.Key.UP)) mask.scrollY -= 100 * dt;
		if (hxd.Key.isDown(hxd.Key.DOWN)) mask.scrollY += 100 * dt;
		if (hxd.Key.isReleased(hxd.Key.SPACE)) mask.scrollTo(0, 0);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Mask();
	}

}

class MaskWithSample extends Object {

	public var sx:Float = 0;
	public var sy:Float = 0;

	public function new(?parent:Object) {
		super(parent);
		new h2d.Bitmap(hxd.Res.hxlogo.toTile(), this);
	}

	override function drawRec(ctx:RenderContext)
	{
		// Masking with advanced API allows to mask contents with objects that cannot use Mask as intermediary or extend from it.
		// For practical usage sample see h2d.Flow Hidden overflow mode.
		h2d.Mask.maskWith(ctx, this, 50, 50, sx, sy);
		super.drawRec(ctx);
		// Unmask should be called after `maskWith` in order to restore previous renderZone state.
		h2d.Mask.unmask(ctx);
	}

}