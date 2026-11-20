import h2d.Font;
import h2d.Font.FontChar;

/**
	A thin stroke of an SDF font stays visible at every sub-pixel position when the font is drawn
	well below its authored size with automatic smoothing (`smoothing = -1`).

	The glyph is a horizontal bar 3.4 texels thick in an atlas authored at 48 px with an 8 px
	spread, like an em dash in Roboto Regular, drawn at 12 px: about 0.85 px thick on screen, so
	at some rows it lies between two pixel centres. Each row is drawn black on white at a different
	vertical offset (whole pixels, for both rows of a 2x2 derivative block, and quarters), and must
	leave a visible mark: the darkest pixel under the bar below `MAX_DARKEST`.

	Opens a real window (a GPU context) and exits 0 when every row passed, 1 otherwise.
**/
@:access(h2d.Font) @:access(h2d.Tile)
class SdfThinStrokeTest extends hxd.App {
	/** Authored size, spread and bar half-thickness, in atlas texels. **/
	static inline var EM = 48;
	static inline var SPREAD = 8;
	static inline var HALF_THICK = 1.7;
	/** Drawn size: a quarter of EM. **/
	static inline var SIZE = 12;
	static inline var BAR = "-".code;
	/** 0.85 px of black over two rows of white leaves about 40% coverage: 150 or darker. **/
	static inline var MAX_DARKEST = 200;

	static var failures = 0;
	var frame = 0;
	var rows : Array<{ t : h2d.Text, y : Float }> = [];

	static function main() {
		new SdfThinStrokeTest();
	}

	/** An EM-sized cell holding a horizontal bar across its middle, as an SDF in alpha (RGB white). **/
	static function barFont() : Font {
		var w = 48, h = 48, cy = 24.0, x0 = 4.0, x1 = 44.0;
		var px = hxd.Pixels.alloc(w, h, RGBA);
		for( y in 0...h )
			for( x in 0...w ) {
				var fx = x + 0.5, fy = y + 0.5;
				// box distance: positive outside the bar, negative inside
				var dy = Math.abs(fy - cy) - HALF_THICK;
				var dx = Math.max(x0 - fx, fx - x1);
				var d = Math.max(dx, dy);
				var a = 0.5 - d / (2 * SPREAD);
				a = a < 0 ? 0 : a > 1 ? 1 : a;
				px.setPixel(x, y, (Std.int(a * 255) << 24) | 0xFFFFFF);
			}
		var tile = h2d.Tile.fromPixels(px);
		var f = new Font("bar", EM, SignedDistanceField(Alpha, 0.5, -1));
		f.tile = tile;
		f.lineHeight = EM;
		f.baseLine = 38;
		f.glyphs.set(BAR, new FontChar(tile.sub(0, 0, w, h), w));
		f.resizeTo(SIZE);
		return f;
	}

	override function init() {
		new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF, 400, 400), s2d);
		var font = barFont();
		var y = 4;
		// whole-pixel offsets 0..3 (both parities of a 2x2 block), then quarter offsets
		for( off in [0.0, 1.0, 2.0, 3.0, 0.25, 0.5, 0.75, 1.25, 1.5, 1.75] ) {
			var t = new h2d.Text(font, s2d);
			t.textColor = 0;
			t.x = 10;
			t.y = y + off;
			t.text = String.fromCharCode(BAR);
			rows.push({ t : t, y : t.y });
			y += 20;
		}
	}

	override function update( dt : Float ) {
		if( ++frame < 3 ) return;
		var px = s2d.captureBitmap().tile.getTexture().capturePixels();
		for( r in rows ) {
			var b = r.t.getBounds();
			var darkest = 255;
			// the bar's middle half, away from its ends
			for( y in Std.int(b.yMin)...Std.int(Math.ceil(b.yMax)) )
				for( x in Std.int(b.xMin + b.width / 4)...Std.int(b.xMax - b.width / 4) ) {
					var c = px.getPixel(x, y) & 0xFF;
					if( c < darkest ) darkest = c;
				}
			var ok = darkest < MAX_DARKEST;
			if( !ok ) failures++;
			Sys.println((ok ? "PASS" : "FAIL") + " - bar at y=" + r.y + ": darkest " + darkest + " (expected < " + MAX_DARKEST + ")");
		}
		Sys.println(failures == 0 ? "ok" : "FAILED");
		Sys.exit(failures == 0 ? 0 : 1);
	}
}
