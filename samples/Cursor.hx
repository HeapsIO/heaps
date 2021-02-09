class Cursor extends SampleApp {

	override function init() {
		super.init();

		engine.backgroundColor = 0xFF202020;

		var bmp = new hxd.BitmapData(32, 32);
		bmp.clear(0x80FF0000);
		bmp.line(0, 0, 31, 0, 0xFFFFFFFF);
		bmp.line(0, 0, 0, 31, 0xFF0000FF);
		bmp.line(0, 31, 31, 31, 0xFFFF0000);
		bmp.line(31, 0, 31, 31, 0xFF00FF00);

		var animationSupported = false;
		#if (flash || js || hldx || hlsdl)
		animationSupported = true;
		#end

		var animatedFrames = [bmp];
		if (animationSupported)
		{
			var bmp2 = new hxd.BitmapData(32, 32);
			bmp2.clear(0x80800000);
			bmp2.line(0, 0, 31, 0, 0xFFFFFFFF);
			bmp2.line(0, 0, 0, 31, 0xFF0000FF);
			bmp2.line(0, 31, 31, 31, 0xFFFF0000);
			bmp2.line(31, 0, 31, 31, 0xFF00FF00);
			bmp2.fill(15, 15, 2, 2, 0xFFFF00FF);
			animatedFrames.push(bmp2);
		}

		var cursors : Array<hxd.Cursor> = [Default,Button,Move,TextInput,Hide,Custom(new hxd.Cursor.CustomCursor([bmp],10,16,16)),Custom(new hxd.Cursor.CustomCursor(animatedFrames,10,16,16))];
		var pos = 3;
		for( c in cursors ) {
			var i = new h2d.Interactive(120, 20, s2d);
			var tf = new h2d.Text(hxd.res.DefaultFont.get(), i);
			tf.text = c.getName();
			tf.dropShadow = { dx: 1, dy: 1, color: 0, alpha: 1 };
			tf.x = 5;
			i.x = 0;
			i.y = pos++ * 20;
			i.cursor = c;
			i.backgroundColor = Std.random(0x1000000) | 0xFF000000;
			i.onOver = function(_) tf.alpha = 0.5;
			i.onOut = function(_) tf.alpha = 1;

			switch(c) {
				case Custom(cur):

					if (@:privateAccess cur.frames.length > 1) {
						tf.text = "Custom (animated)";
						if (!animationSupported) {
							i.cursor = Default;
							tf.textColor = 0xFF0000;
						}
					}

				default:
			}
		}

		// It's possible to override default cursors by custom ones by setting
		// `hxd.System.setCursor` function.
		// Useful when game utilizes stylized cursors for everything.

		// HLSDL note: Cursor offsetX and offsetY should remain inside frame bounds.
		// This is a limitation of SDL (most likely for portability reasons).

		var doOverride = false;
		var defOverride = new hxd.BitmapData(10, 10);
		defOverride.line(0, 0, 5, 0, 0xffff0000);
		defOverride.line(0, 1, 0, 5, 0xffff0000);
		defOverride.line(0, 0, 10, 10, 0xffff0000);
		var overrideCursor:hxd.Cursor = Custom(new hxd.Cursor.CustomCursor([defOverride], 0, 0, 0));

		hxd.System.setCursor = function( cur : hxd.Cursor ) {
			if (doOverride && cur == Default) {
				hxd.System.setNativeCursor(overrideCursor);
			} else {
				hxd.System.setNativeCursor(cur);
			}
		}

		addText("Override Default cursor by Custom");
		addCheck("Enable", function() { return doOverride; }, function(v) { doOverride = v; });
	}

	static function main() {
		new Cursor();
	}

}