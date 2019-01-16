package h2d.uikit;

enum Direction {
	Left;
	Right;
	Top;
	Bottom;
}

enum Constraint {
	Whole;
	Min;
	Max;
}

enum Property {
	// h2d.Object
	PClasses( cl : Array<String> );
	PName( name : String );
	PPosition( ?x : Float, ?y : Float );
	PScale( ?x : Float, ?y : Float );
	PRotation( v : Float );
	PAlpha( v : Float );
	PBlend( mode : h2d.BlendMode );
	PVisible( b : Bool );
	// Drawable
	PColor( r : Float, g : Float, b : Float, a : Float );
	PSmooth( v : Null<Bool> );
	PTileWrap( v : Bool );
	// FlowProperties
	PMargin( top : Int, right : Int, bottom : Int, left : Int );
	PMarginDir( dir : Direction, value : Int );
	// Flow
	PDebug( v : Bool );
	PPadding( top : Int, right : Int, bottom : Int, left : Int );
	PPaddingDir( dir : Direction, value : Int );
	PWidth( c : Constraint, ?v : Int );
	PHeight( c : Constraint, ?v : Int );
	PBackground( t : h2d.Tile, ?borderW : Int, ?borderH : Int );
	// Bitmap
	PSource( res : hxd.res.Any );
	// Other
	PImportant( p : Property );
	PCustom( name : String, value : Dynamic );
	PUnknown;
}

class PropertyParser {

	public function new() {
	}

	function parseBool( v : CssParser.Value ) : Null<Bool> {
		return switch( v ) {
		case VIdent("true") | VInt(1): true;
		case VIdent("false") | VInt(0): false;
		default: null;
		}
	}

	function parseInt( v : CssParser.Value ) : Null<Int> {
		return switch( v ) {
		case VInt(i): i;
		default: null;
		}
	}

	function parseFloat( v : CssParser.Value ) : Float {
		return switch( v ) {
		case VInt(i): i;
		case VFloat(f): f;
		default: Math.NaN;
		}
	}

	inline function isNaN( f : Float ) {
		return Math.isNaN(f);
	}

	function parseColor( v : CssParser.Value ) : Null<Int> {
		switch( v ) {
		case VHex(h,color):
			if( h.length == 3 ) {
				var r = color >> 8;
				var g = (color & 0xF0) >> 4;
				var b = color & 0xF;
				r |= r << 4;
				g |= g << 4;
				b |= b << 4;
				color = (r << 16) | (g << 8) | b;
			}
			return color | 0xFF000000;
		default:
			return null;
		}
	}

	function parseColorF( v : CssParser.Value ) : h3d.Vector {
		var c = parseColor(v);
		if( c != null ) {
			var v = new h3d.Vector();
			v.setColor(c);
			return v;
		}
		return null;
	}

	function parsePath( v : CssParser.Value ) {
		return switch( v ) {
		case VString(v): v;
		case VIdent(v): v;
		case VCall("url",[VIdent(v) | VString(v)]): v;
		default: null;
		}
	}

	function getIdent( v : CssParser.Value ) {
		return switch( v ) { case VIdent(v): v; default: null; }
	}

	function parseTile( v : CssParser.Value ) {
		var c = parseColor(v);
		if( c != null )
			return h2d.Tile.fromColor(c,1,1,(c>>>24)/255);
		var path = parsePath(v);
		if( path == null ) return null;
		var res = try hxd.res.Loader.currentInstance.load(path) catch( e : hxd.res.NotFound ) return null;
		return res.toTile();
	}

	function parsePadding( v : CssParser.Value ) {
		switch( v ) {
		case VInt(v):
			return { top : v, right : v, bottom : v, left : v };
		case VGroup([VInt(v),VInt(h)]):
			return { top : v, right : h, bottom : v, left : h };
		case VGroup([VInt(v),VInt(h),VInt(k)]):
			return { top : v, right : h, bottom : k, left : h };
		case VGroup([VInt(v),VInt(h),VInt(k),VInt(l)]):
			return { top : v, right : h, bottom : k, left : l };
		default:
			return null;
		}
	}

	public function parse( name : String, value : CssParser.Value ) : Property {
		switch( name ) {
		case "visible":
			var b = parseBool(value);
			return b == null ? null : PVisible(b);
		case "padding":
			var p = parsePadding(value);
			return p == null ? null : PPadding(p.top, p.right, p.bottom, p.left);
		case "padding-left":
			var v = parseInt(value);
			return v == null ? null : PPaddingDir(Left, v);
		case "padding-right":
			var v = parseInt(value);
			return v == null ? null : PPaddingDir(Right, v);
		case "padding-top":
			var v = parseInt(value);
			return v == null ? null : PPaddingDir(Top, v);
		case "padding-bottom":
			var v = parseInt(value);
			return v == null ? null : PPaddingDir(Bottom, v);
		case "margin":
			var p = parsePadding(value);
			return p == null ? null : PMargin(p.top, p.right, p.bottom, p.left);
		case "margin-left":
			var v = parseInt(value);
			return v == null ? null : PMarginDir(Left, v);
		case "margin-right":
			var v = parseInt(value);
			return v == null ? null : PMarginDir(Right, v);
		case "margin-top":
			var v = parseInt(value);
			return v == null ? null : PMarginDir(Top, v);
		case "margin-bottom":
			var v = parseInt(value);
			return v == null ? null : PMarginDir(Bottom, v);
		case "width":
			if( getIdent(value) == "auto" ) return PWidth(Whole);
			var v = parseInt(value);
			return v == null ? null : PWidth(Whole,v);
		case "height":
			if( getIdent(value) == "auto" ) return PHeight(Whole);
			var v = parseInt(value);
			return v == null ? null : PHeight(Whole,v);
		case "min-width":
			if( getIdent(value) == "auto" ) return PWidth(Min);
			var v = parseInt(value);
			return v == null ? null : PWidth(Min,v);
		case "min-height":
			if( getIdent(value) == "auto" ) return PHeight(Min);
			var v = parseInt(value);
			return v == null ? null : PHeight(Min,v);
		case "max-width":
			if( getIdent(value) == "auto" ) return PWidth(Max);
			var v = parseInt(value);
			return v == null ? null : PWidth(Max,v);
		case "max-height":
			if( getIdent(value) == "auto" ) return PHeight(Max);
			var v = parseInt(value);
			return v == null ? null : PHeight(Max,v);
		case "background":
			switch( value ) {
			case VGroup([url,VInt(w),VInt(h)]):
				var t = parseTile(url);
				if( t == null ) return null;
				return PBackground(t, w, h);
			default:
				var t = parseTile(value);
				if( t == null ) return null;
				return PBackground(t);
			}
		case "src":
			var path = parsePath(value);
			if( path == null ) return null;
			return try PSource(hxd.res.Loader.currentInstance.load(path)) catch( e : hxd.res.NotFound ) null;
		case "class":
			switch( value ) {
			case VIdent(i):
				return PClasses([i]);
			case VGroup(l):
				return PClasses([for( v in l ) { var id = getIdent(v); if( id == null ) return null; id; }]);
			default:
				return null;
			}
		case "name":
			var name = getIdent(value);
			if( name == null ) return null;
			return PName(name);
		case "position":
			switch( value ) {
			case VGroup([x,y]):
				var x = parseFloat(x);
				var y = parseFloat(y);
				if( isNaN(x) || isNaN(y) ) return null;
				return PPosition(x,y);
			default:
				return null;
			}
		case "x":
			var x = parseFloat(value);
			if( isNaN(x) ) return null;
			return PPosition(x,null);
		case "y":
			var y = parseFloat(value);
			if( isNaN(y) ) return null;
			return PPosition(null,y);
		case "scale":
			switch( value ) {
			case VGroup([sx,sy]):
				var sx = parseFloat(sx);
				var sy = parseFloat(sy);
				if( isNaN(sx) || isNaN(sy) ) return null;
				return PScale(sx,sy);
			default:
				var s = parseFloat(value);
				if( isNaN(s) ) return null;
				return PScale(s,s);
			}
		case "rotation":
			var r = parseFloat(value);
			if( isNaN(r) ) return null;
			return PRotation(r * Math.PI / 180);
		case "alpha":
			var a = parseFloat(value);
			if( isNaN(a) ) return null;
			return PAlpha(a);
		case "blend":
			var b : h2d.BlendMode = switch( getIdent(value) ) {
			case "add": Add;
			case "alpha": Alpha;
			case "none": None;
			default: return null;
			}
			return PBlend(b);
		case "color":
			var v = parseColorF(value);
			if( v == null ) return null;
			return PColor(v.r, v.g, v.b, v.a);
		case "smooth":
			if( getIdent(value) == "auto" ) return PSmooth(null);
			var b = parseBool(value);
			return if( b == null ) null else PSmooth(b);
		case "debug":
			var b = parseBool(value);
			return if( b == null ) null else PDebug(b);
		default:
			var p = customParsers.get(name);
			if( p == null )
				return PUnknown;
			var v = p(value);
			if( !v.valid ) return null;
			return PCustom(name,v);
		}
	}

	static var customParsers = new Map<String,CssParser.Value -> { value : Dynamic, valid : Bool }>();

}