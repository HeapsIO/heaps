import h2d.Font;
import h2d.Font.FontChar;
import h2d.Tile;

@:access(h2d.Tile)
class FakeFallback implements h2d.Font.FontFallback {
	public var calls = 0;
	public function new() {}
	public function resolveGlyph( font : Font, code : Int ) : Null<FontChar> {
		calls++;
		return code == 0x4E2D ? new FontChar(new Tile(null, 0, 0, 10, 20), 11) : null;
	}
}

@:access(h2d.Tile) @:access(h2d.Font)
class FontFallbackTest {
	static var failures = 0;

	static function check( cond : Bool, msg : String ) {
		if( !cond ) {
			failures++;
			Sys.println("FAIL: " + msg);
		}
	}

	static function makeFont( withFallback : FakeFallback ) : Font {
		var f = new Font("t", 32);
		f.defaultChar = new FontChar(new Tile(null, 0, 0, 5, 5), 6);
		f.glyphs.set('"'.code, new FontChar(new Tile(null, 0, 0, 4, 8), 5));
		f.tile = new Tile(null, 0, 0, 1, 1);
		f.fallback = withFallback;
		return f;
	}

	static function main() {
		var fb = new FakeFallback();
		var f = makeFont(fb);

		var g = f.getChar(0x4E2D);
		check(g.width == 11, "fallback glyph width");
		f.getChar(0x4E2D);
		check(fb.calls == 1, "fallback result cached, calls=" + fb.calls);

		check(f.getChar(0x10FFFD) == f.defaultChar, "unknown -> defaultChar");

		var fb2 = new FakeFallback();
		var f2 = makeFont(fb2);
		var q = f2.glyphs.get('"'.code);
		check(f2.getChar(0x201C) == q, "charset resolves before fallback");
		check(fb2.calls == 0, "fallback not called for charset-resolved");
		check(f2.getChar("\n".code) == f2.nullChar, "newline -> nullChar");
		check(f2.getChar("\r".code) == f2.nullChar, "CR -> nullChar");
		check(fb2.calls == 0, "fallback not called for newline");

		check(makeFont(fb).clone().fallback == fb, "clone keeps fallback");

		var fb3 = new FakeFallback();
		var f3 = makeFont(fb3);
		f3.getChar(0x4E2D);
		var c = f3.clone();
		c.resizeTo(64);
		var cg = c.getChar(0x4E2D);
		check(cg.t.width == 20, "resized tile width " + cg.t.width);
		check(cg.width == 22, "resized advance " + cg.width);

		var fb4 = new FakeFallback();
		var f4 = makeFont(fb4);
		check(f4.canDraw(0x4E2D), "canDraw fallback");
		check(!f4.canDraw(0x10FFFD), "!canDraw unknown");
		check(f4.canDraw('"'.code), "canDraw baked");

		// control: no fallback
		var n = makeFont(null);
		check(n.getChar(0x4E2D) == n.defaultChar, "nofb: unknown -> default");
		check(n.getChar(0x10FFFD) == n.defaultChar, "nofb: unknown2 -> default");
		check(n.getChar(0x201C) == n.glyphs.get('"'.code), "nofb: charset");
		check(n.getChar("\n".code) == n.nullChar, "nofb: newline");
		check(n.clone().fallback == null, "nofb: clone");
		check(!n.canDraw(0x4E2D), "nofb: !canDraw");
		check(n.canDraw('"'.code), "nofb: canDraw baked");

		if( failures > 0 ) Sys.exit(1);
		Sys.println("FontFallbackTest: all passed");
	}
}
