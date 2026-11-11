import h2d.Font;
import h2d.Font.FontChar;
import h2d.Tile;

/** Stands in for an OS emoji font: a few emoji and the heart, 20 wide; nothing else. **/
@:access(h2d.Tile)
class EmojiFallback implements h2d.Font.FontFallback {
	public function new() {}
	public function resolveGlyph( font : Font, code : Int ) : Null<FontChar> {
		return switch( code ) {
			case 0x1F600, 0x1F525, 0x1F468, 0x1F469, 0x2764, 0x1F44D, 0x1F3FD: new FontChar(new Tile(null, 0, 0, 18, 18), 20);
			default: null;
		}
	}
}

/**
	Text outside the Basic Multilingual Plane (emoji) is laid out one code point at a time: a
	surrogate pair is one glyph, joiners and variation selectors take no space and draw nothing,
	and TextInput's caret never stops inside an emoji or before its selectors.
**/
@:access(h2d.Tile) @:access(h2d.Font) @:access(h2d.Text) @:access(h2d.TextInput) @:access(h2d.HtmlText)
class EmojiTextTest {
	static var failures = 0;

	static function eq<T>( name : String, got : T, exp : T ) {
		if( got != exp ) {
			failures++;
			Sys.println("FAIL " + name + ": got " + got + ", expected " + exp);
		}
	}

	static function makeFont() : Font {
		var f = new Font("t", 32);
		f.lineHeight = 32;
		f.baseLine = 26;
		f.defaultChar = new FontChar(new Tile(null, 0, 0, 5, 5), 6);
		f.glyphs.set("a".code, new FontChar(new Tile(null, 0, 0, 8, 10), 10));
		f.glyphs.set(" ".code, new FontChar(new Tile(null, 0, 0, 0, 0), 10));
		f.tile = new Tile(null, 0, 0, 1, 1);
		f.fallback = new EmojiFallback();
		return f;
	}

	static inline var GRIN = "\u{1F600}";
	static inline var FIRE = "\u{1F525}";
	static inline var VS16 = "\u{FE0F}";
	static inline var ZWJ = "\u{200D}";

	static function main() {
		// TextInput's cursor tile needs an engine; nothing is drawn
		@:privateAccess {
			var e : h3d.Engine = Type.createEmptyInstance(h3d.Engine);
			var tex : h3d.mat.Texture = Type.createEmptyInstance(h3d.mat.Texture);
			tex.width = tex.height = 1;
			e.textureColorCache = [0xFFFFFF | (255 << 24) => tex, 0x3399FF | (255 << 24) => tex];
			h3d.Engine.CURRENT = e;
		}
		var font = makeFont();
		var t = new h2d.Text(font);

		// one glyph per emoji, not one box per UTF-16 unit
		eq("pair width", t.calcTextWidth(GRIN), 20.);
		eq("pair in latin", t.calcTextWidth("a" + GRIN + "a"), 40.);
		// variation selector and joiner: zero width
		eq("heart + VS16", t.calcTextWidth("\u{2764}" + VS16), 20.);
		eq("ZWJ family drawn as parts", t.calcTextWidth("\u{1F468}" + ZWJ + "\u{1F469}"), 40.);
		eq("skin tone is its own glyph", t.calcTextWidth("\u{1F44D}\u{1F3FD}"), 40.);
		eq("tag characters", t.calcTextWidth(FIRE + "\u{E0067}\u{E007F}"), 20.);
		// a lone surrogate is still a box
		eq("lone high surrogate", t.calcTextWidth(GRIN.substr(0, 1)), 6.);
		// latin unchanged
		eq("latin", t.calcTextWidth("aa a"), 40.);

		t.letterSpacing = 1;
		eq("VS adds no letter spacing", t.calcTextWidth("a" + VS16 + "a"), t.calcTextWidth("aa"));
		t.letterSpacing = 0;

		t.text = GRIN + VS16 + "a" + ZWJ;
		@:privateAccess t.updateSize();
		eq("glyph count", t.glyphs.count(), 2);

		// word wrap keeps a pair and its selector together
		var w = new h2d.Text(font);
		w.maxWidth = 45;
		w.wordBreak = true;
		eq("wrap pairs", w.splitText(GRIN + VS16 + GRIN + VS16 + GRIN), GRIN + VS16 + GRIN + VS16 + "\n" + GRIN);
		eq("wrap latin", w.splitText("aa aa aa"), "aa \naa \naa");
		// CJK Extension B (one surrogate pair each) breaks between characters, never inside one
		var ext = "\u{20000}";
		var c = new h2d.Text(font);
		c.maxWidth = 15;
		eq("wrap ext B", c.splitText(ext + ext + ext), ext + ext + "\n" + ext);
		var hc = new h2d.HtmlText(font);
		hc.maxWidth = 15;
		hc.text = ext + ext + ext;
		eq("html wrap ext B lines", hc.textHeight, 64.);
		eq("html wrap ext B glyphs", hc.glyphs.count(), 3);

		// HtmlText lays emoji out the same way
		var h = new h2d.HtmlText(font);
		h.text = "a" + GRIN + VS16 + "a";
		eq("html width", h.textWidth, 40.);
		eq("html glyphs", h.glyphs.count(), 3);
		h.maxWidth = 45;
		h.text = GRIN + VS16 + " " + GRIN + " " + GRIN;
		eq("html wrap lines", h.textHeight, 96.);

		// TextInput: the caret steps over an emoji and its selectors as one character
		var ti = new h2d.TextInput(font);
		ti.text = "a\u{2764}" + VS16 + "a";
		eq("next over heart+VS", ti.nextCursor(1), 3);
		eq("prev over heart+VS", ti.prevCursor(3), 1);
		eq("snap before VS", ti.snapCursor(2), 3);
		ti.text = GRIN + VS16 + "a";
		eq("next over pair+VS", ti.nextCursor(0), 3);
		eq("prev over pair+VS", ti.prevCursor(3), 0);
		eq("snap inside pair", ti.snapCursor(1), 3);
		ti.cursorIndex = 3;
		eq("caret x after emoji", ti.getCursorXOffset(), 20.);
		// clicks: left part of the emoji -> before it, past it -> after it and its selector
		eq("click on emoji", ti.textPos(10, 0), 0);
		eq("click on a", ti.textPos(25, 0), 3);
		// backspace after "heart+VS" removes both
		ti.text = "a\u{2764}" + VS16;
		ti.cursorIndex = 3;
		ti.selectionRange = { start : ti.prevCursor(3), length : 3 - ti.prevCursor(3) };
		ti.cutSelection(true);
		eq("backspace heart+VS", ti.text, "a");

		// vertical moves measure emoji as one glyph
		var m = new h2d.TextInput(font);
		m.multiline = true;
		m.text = GRIN + GRIN + "a\naaaaa";
		m.cursorIndex = 4;
		m.moveCursorVertically(1);
		eq("down from after two emoji", m.cursorIndex, 10);

		if( failures > 0 ) {
			Sys.println("EmojiTextTest: " + failures + " failure(s)");
			Sys.exit(1);
		}
		Sys.println("EmojiTextTest: all passed");
	}
}
