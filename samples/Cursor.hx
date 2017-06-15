class Cursor extends hxd.App {

	override function init() {

		engine.backgroundColor = 0xFF202020;

		var bmp = new hxd.BitmapData(32, 32);
		bmp.clear(0x80FF0000);
		bmp.line(0, 0, 31, 0, 0xFFFFFFFF);
		bmp.line(0, 0, 0, 31, 0xFF0000FF);
		bmp.line(0, 31, 31, 31, 0xFFFF0000);
		bmp.line(31, 0, 31, 31, 0xFF00FF00);

		var cursors : Array<hxd.Cursor> = [Default,Button,Move,TextInput,Hide,Custom(new hxd.Cursor.CustomCursor([bmp],0.,16,16))];
		var pos = 0;
		for( c in cursors ) {
			var i = new h2d.Interactive(100, 20, s2d);
			var tf = new h2d.Text(hxd.res.DefaultFont.get(), i);
			tf.text = c.getName();
			tf.x = 5;
			i.x = 0;
			i.y = pos++ * 20;
			i.cursor = c;
			i.backgroundColor = Std.random(0x1000000) | 0xFF000000;

			var supported = true;
			#if js
			if( c.match(Custom(_)) ) supported = false;
			#end

			if( !supported ) {
				tf.textColor = 0xFF0000;
				i.cursor = Default;
			}
		}
	}

	static function main() {
		new Cursor();
	}

}