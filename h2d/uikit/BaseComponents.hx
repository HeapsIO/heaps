package h2d.uikit;
import h2d.uikit.Property;
import h2d.uikit.CssValue;

final class Object2D extends Component<h2d.Object> {

	function new() {
		super("object",h2d.Object.new,null);

		// h2d.Object properties
		addHandler( "name", parseIdent, null, (o,v) -> o.name = v);
		addHandler( "x", parseFloat, 0, (o,v) -> o.x = v);
		addHandler( "y", parseFloat, 0, (o,v) -> o.y = v);
		addHandler( "alpha", parseFloat, 1, (o,v) -> o.alpha = v);
		addHandler( "rotation", parseFloat, 0, (o,v) -> o.rotation = v * Math.PI / 180);
		addHandler( "visible", parseBool, true, (o,v) -> o.visible = v);
		addHandler( "scale", parseScale, { x : 1, y : 1 }, (o,v) -> { o.scaleX = v.x; o.scaleY = v.y; });
		addHandler( "blend", parseBlend, Alpha, (o,v) -> o.blendMode = v);

		// flow properties
		addHandler( "margin", parseBox, { left : 0, top : 0, right : 0, bottom : 0 }, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) {
				p.paddingLeft = v.left;
				p.paddingRight = v.right;
				p.paddingTop = v.top;
				p.paddingBottom = v.bottom;
			}
		});
		addHandler( "margin-left", parseInt, 0, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.paddingLeft = v;
		});
		addHandler( "margin-top", parseInt, 0, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.paddingTop = v;
		});
		addHandler( "margin-right", parseInt, 0, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.paddingRight = v;
		});
		addHandler( "margin-bottom", parseInt, 0, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.paddingBottom = v;
		});
		addHandler( "align", parseAlign, { h : null, v : null }, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) {
				p.horizontalAlign = v.h;
				p.verticalAlign = v.v;
			}
		});
		addHandler( "halign", parseHAlign, null, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.horizontalAlign = v;
		});
		addHandler( "valign", parseVAlign, null, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.verticalAlign = v;
		});
		addHandler( "position",parsePosition, false, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.isAbsolute = v;
		});
		addHandler( "offset", parseXY, { x : 0, y : 0 }, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) {
				p.offsetX = Std.int(v.x);
				p.offsetY = Std.int(v.y);
			}
		});
		addHandler( "offset-x", parseInt, 0, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.offsetX = v;
		});
		addHandler( "offset-y", parseInt, 0, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.offsetY = v;
		});
		addHandler( "min-width",parseNone.bind(parseInt),null, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.minWidth = v;
		});
		addHandler( "min-height",parseNone.bind(parseInt),null, (o,v) -> {
			var p = getFlowProps(o);
			if( p != null ) p.minHeight = v;
		});
	}

	function getFlowProps( o : h2d.Object ) {
		var p = Std.instance(o.parent, h2d.Flow);
		return p == null ? null : p.getProperties(o);
	}

	function parsePosition( value ) {
		switch( value ) {
		case VIdent("auto"):
			return false;
		case VIdent("absolute"):
			return true;
		default:
			return invalidProp();
		}
	}

	function parseScale( value ) {
		switch( value ) {
		case VGroup([x,y]):
			return { x : parseFloat(x), y : parseFloat(y) };
		default:
			var s = parseFloat(value);
			return { x : s, y : s };
		}
	}

	function parseBlend( value ) : h2d.BlendMode {
		return switch( parseIdent(value) ) {
		case "add": Add;
		case "alpha": Alpha;
		case "none": None;
		default: invalidProp();
		}
	}

	public static var inst = new Object2D();
}

final class Drawable extends Component<h2d.Drawable> {

	function new() {
		super("drawable",function(_) throw "assert",Object2D.inst);
		addHandler("color", parseColorF, new h3d.Vector(1,1,1,1), (o,v) -> o.color.load(v));
		addHandler("smooth", parseAuto.bind(parseBool), null, (o,v) -> o.smooth = v);
		addHandler("tilewrap", parseBool, false, (o,v) -> o.tileWrap = v);
	}

	function parseColorF( v : CssValue ) : h3d.Vector {
		var c = parseColor(v);
		var v = new h3d.Vector();
		v.setColor(c);
		return v;
	}

	public static var inst = new Drawable();

}

final class Bitmap extends Component<h2d.Bitmap> {

	public function new() {
		super("bitmap",function(p) return new h2d.Bitmap(h2d.Tile.fromColor(0xFF00FF,16,16),p), Drawable.inst);
		addHandler("src",parseTile,null,(o,v) -> o.tile = v);
	}

	static var inst = new Bitmap();

}

final class Flow extends Component<h2d.Flow> {

	public function new() {
		super("flow",h2d.Flow.new, Object2D.inst);
		addHandler("width",parseAuto.bind(parseInt),null,(o,v) -> { o.minWidth = o.maxWidth = v; });
		addHandler("height",parseAuto.bind(parseInt),null,(o,v) -> { o.minHeight = o.maxHeight = v; });
		addHandler("min-width",parseNone.bind(parseInt),null,(o,v) -> o.minWidth = v);
		addHandler("max-width",parseNone.bind(parseInt),null,(o,v) -> o.maxWidth = v);
		addHandler("min-height",parseNone.bind(parseInt),null,(o,v) -> o.minHeight = v);
		addHandler("max-height",parseNone.bind(parseInt),null,(o,v) -> o.maxHeight = v);
		addHandler("background",parseBackground,null,(o,v) -> {
			if( v == null ) {
				o.backgroundTile = null;
				o.borderWidth = o.borderHeight = 0;
			} else {
				o.backgroundTile = v.tile;
				o.borderWidth = v.borderW;
				o.borderHeight = v.borderH;
			}
		});
		addHandler("debug", parseBool, false, (o,v) -> o.debug = v);
		addHandler("padding", parseBox, { left : 0, top : 0, bottom : 0, right : 0 }, (o,v) -> {
			o.paddingLeft = v.left;
			o.paddingRight = v.right;
			o.paddingTop = v.top;
			o.paddingBottom = v.bottom;
		});
		addHandler("padding-left", parseInt, 0, (o,v) -> o.paddingLeft = v);
		addHandler("padding-right", parseInt, 0, (o,v) -> o.paddingRight = v);
		addHandler("padding-top", parseInt, 0, (o,v) -> o.paddingTop = v);
		addHandler("padding-bottom", parseInt, 0, (o,v) -> o.paddingBottom = v);
		addHandler("content-align", parseAlign, { h : null, v : null }, (o,v) -> {
			o.horizontalAlign = v.h;
			o.verticalAlign = v.v;
		});
		addHandler("content-halign", parseVAlign, null, (o,v) -> o.horizontalAlign = v);
		addHandler("content-valign", parseHAlign, null, (o,v) -> o.verticalAlign = v);
	}

	function parseBackground(value) {
		return switch( value ) {
		case VIdent("transparent"): null;
		case VGroup([tile,VInt(x),VInt(y)]):
			{ tile : parseTile(tile), borderW : x, borderH : y };
		default:
			{ tile : parseTile(value), borderW : 0, borderH : 0 };
		}
	}

	static var inst = new Flow();

}

final class Text extends Component<h2d.Text> {

	public function new() {
		super("text",function(p) return new h2d.Text(hxd.res.DefaultFont.get(),p), Drawable.inst);
		addHandler("text",parseText,"", (o,v) -> o.text = v);
		addHandler("font",parseFont,null, (o,v) -> o.font = v == null ? hxd.res.DefaultFont.get() : v );
		addHandler("letter-spacing",parseInt,1, (o,v) -> o.letterSpacing = v);
		addHandler("line-spacing",parseInt,0, (o,v) -> o.lineSpacing = v);
		addHandler("max-width",parseNone.bind(parseInt),null,(o,v) -> o.maxWidth = v);
		addHandler("text-align",parseTextAlign, Left, (o,v) -> o.textAlign = v);
		addHandler("text-shadow",parseNone.bind(parseTextShadow), null, (o,v) -> o.dropShadow = v);
	}

	function parseTextAlign( value : CssValue ) : h2d.Text.Align {
		return switch( parseIdent(value) ) {
		case "left": Left;
		case "right": Right;
		case "center": Center;
		default: invalidProp();
		}
	}

	function parseText( value : CssValue ) {
		return switch( value ) {
		case VString(str): str;
		case VIdent(i): i;
		default: invalidProp();
		}
	}

	function parseTextShadow( value : CssValue ) {
		return switch( value ) {
		case VGroup(vl):
			return { dx : parseFloat(vl[0]), dy : parseFloat(vl[1]), color : vl.length >= 3 ? parseColor(vl[2]) : 0, alpha : vl.length >= 4 ? parseFloat(vl[3]) : 1 };
		default:
			return { dx : 1, dy : 1, color : parseColor(value), alpha : 1 };
		}
	}

	function parseFont( value : CssValue ) {
		var path = parsePath(value);
		return loadResource(path).to(hxd.res.BitmapFont).toFont();
	}

	static var inst = new Text();

}