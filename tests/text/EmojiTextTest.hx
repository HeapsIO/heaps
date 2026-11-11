import h2d.Font;
import h2d.Font.FontChar;
import h2d.Tile;

/**
	Stands in for an OS emoji font: a few emoji and the heart, 20 wide; nothing else. Joins four
	sequences into one 30 wide colour glyph, like a font with those ligatures.
**/
@:access(h2d.Tile)
class EmojiFallback implements h2d.Font.FontFallback implements h2d.Font.ClusterFallback {
	public var clusterCalls = 0;
	public function new() {}
	public function resolveCluster( font : Font, cluster : String, emoji : Bool ) : Null<FontChar> {
		clusterCalls++;
		if( !emoji ) return null;
		return switch( cluster ) {
			case "\u{1F44D}\u{1F3FD}", "\u{1F468}\u{200D}\u{1F469}", "\u{31}\u{FE0F}\u{20E3}", "\u{1F1EC}\u{1F1E7}":
				var c = new FontChar(new Tile(null, 0, 0, 28, 28), 30);
				c.isColor = true;
				c;
			default: null;
		}
	}
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
		f.glyphs.set("1".code, new FontChar(new Tile(null, 0, 0, 8, 10), 10));
		f.tile = new Tile(null, 0, 0, 1, 1);
		f.fallback = new EmojiFallback();
		return f;
	}

	static inline var GRIN = "\u{1F600}";
	static inline var FIRE = "\u{1F525}";
	static inline var VS16 = "\u{FE0F}";
	static inline var ZWJ = "\u{200D}";
	static inline var S = 32; // makeFont's size
	static inline var THUMB_TONE = "\u{1F44D}\u{1F3FD}";

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
		eq("ZWJ pair joined", t.calcTextWidth("\u{1F468}" + ZWJ + "\u{1F469}"), 30.);
		eq("joined thumb width", t.calcTextWidth(THUMB_TONE), 30.);
		eq("keycap beats app font 1", t.calcTextWidth("1\u{FE0F}\u{20E3}"), 30.);
		eq("bare 1 stays in the app font", t.calcTextWidth("1"), 10.);
		eq("miss draws parts", t.calcTextWidth("\u{1F469}" + ZWJ + GRIN), 40.); // 20 + 20, ZWJ invisible
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

		// emoji clusters (UTS #51 sequences)
		eq("cluster modifier", hxd.Charset.clusterEnd(THUMB_TONE + "x", 0), 4);
		eq("cluster zwj family", hxd.Charset.clusterEnd("\u{1F468}\u{200D}\u{1F469}\u{200D}\u{1F467}", 0), 8);
		eq("cluster keycap", hxd.Charset.clusterEnd("1\u{FE0F}\u{20E3}2", 0), 3);
		eq("cluster flags pair only", hxd.Charset.clusterEnd("\u{1F1EC}\u{1F1E7}\u{1F1EB}\u{1F1F7}", 0), 4);
		eq("cluster tag flag", hxd.Charset.clusterEnd("\u{1F3F4}\u{E0067}\u{E0062}\u{E0073}\u{E0063}\u{E0074}\u{E007F}", 0), 14);
		eq("cluster latin", hxd.Charset.clusterEnd("ab", 0), 1);
		eq("cluster cjk ivs", hxd.Charset.clusterEnd("\u{845B}\u{E0100}x", 0), 3);
		eq("cluster zwj never joins a newline", hxd.Charset.clusterEnd("a\u{200D}\nb", 0), 2);
		eq("emoji cluster keycap", hxd.Charset.isEmojiCluster("1\u{FE0F}\u{20E3}", 0, 3), true);
		eq("not emoji cluster ivs", hxd.Charset.isEmojiCluster("\u{845B}\u{E0100}", 0, 3), false);

		// a cluster is never split across lines
		var cw = new h2d.Text(font);
		cw.wordBreak = true;
		cw.maxWidth = 25;
		eq("wrap: lone cluster wider than maxWidth", cw.splitText(THUMB_TONE + THUMB_TONE), THUMB_TONE + "\n" + THUMB_TONE);
		eq("wrap: miss parts stay together", cw.splitText("a\u{1F469}" + ZWJ + GRIN), "a\n\u{1F469}" + ZWJ + GRIN);

		// clone + resize: a cluster glyph resolved before the clone is scaled with it, not resolved again
		var cf = makeFont();
		var fb : EmojiFallback = cast cf.fallback;
		fb.clusterCalls = 0;
		cf.getCluster(THUMB_TONE, 0, 4);
		var f3 = cf.clone();
		f3.resizeTo(S * 2);
		eq("cluster glyph follows clone + resizeTo", f3.getCluster(THUMB_TONE, 0, 4).width, 60.);
		eq("cluster colour flag survives clone", f3.getCluster(THUMB_TONE, 0, 4).isColor, true);
		eq("cluster resolved once", fb.clusterCalls, 1);
		cf.getCluster("\u{1F469}" + ZWJ + GRIN, 0, 5);
		cf.getCluster("\u{1F469}" + ZWJ + GRIN, 0, 5);
		eq("cluster miss resolved once", fb.clusterCalls, 2);
		eq("text-style cluster uses the app font", cf.getCluster("1\u{FE0E}", 0, 2) == cf.getChar("1".code), true);

		// colour glyphs go on their own untinted layer, which follows the text's alpha
		var ct = new h2d.Text(font);
		ct.text = "a" + THUMB_TONE + "a";
		@:privateAccess ct.updateSize();
		eq("colour glyph not in text glyphs", ct.glyphs.count(), 2);
		eq("colour glyph on colour layer", ct.colorGlyphs.count(), 1);
		ct.textColor = 0x000000;
		ct.color.a = 0.5;
		ct.syncColorLayer();
		eq("colour layer follows text alpha, ignores rgb", [ct.colorGlyphs.color.r, ct.colorGlyphs.color.g, ct.colorGlyphs.color.b, ct.colorGlyphs.color.a].join(","), "1,1,1,0.5");
		eq("colour layer is smooth", ct.colorGlyphs.smooth, true);
		ct.text = "aa";
		@:privateAccess ct.updateSize();
		eq("colour layer cleared on rebuild", ct.colorGlyphs.count(), 0);
		var ch = new h2d.HtmlText(font);
		ch.text = "a<font color='#ff0000'>" + THUMB_TONE + "</font>a";
		@:privateAccess ch.updateSize();
		eq("html colour glyph on colour layer", ch.colorGlyphs.count(), 1);

		// HtmlText lays emoji out the same way
		var h = new h2d.HtmlText(font);
		h.text = "a" + GRIN + VS16 + "a";
		eq("html width", h.textWidth, 40.);
		eq("html glyphs", h.glyphs.count(), 3);
		var hj = new h2d.HtmlText(font);
		hj.text = "a" + THUMB_TONE + "a";
		eq("html joined width", hj.textWidth, 50.);
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

		// TextInput: one stop per cluster, joined or drawn as parts
		ti.text = "a\u{1F468}\u{200D}\u{1F469}b";
		eq("next over family", ti.nextCursor(1), 6);
		eq("prev over family", ti.prevCursor(6), 1);
		eq("snap inside family", ti.snapCursor(3), 6);
		ti.text = "a\u{1F469}" + ZWJ + GRIN; // a miss: drawn as parts, still one cluster
		eq("backspace removes whole cluster", ti.prevCursor(6), 1); // backspace deletes [prevCursor(cursor), cursor)
		var p = ti.textPos(25, 0); // x inside the parts (a = 10, woman 10..30)
		eq("click lands on cluster boundary", p == 1 || p == 6, true);

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
