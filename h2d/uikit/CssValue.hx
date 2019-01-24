package h2d.uikit;
import h2d.uikit.Property.InvalidProperty;

enum CssValue {
	VIdent( i : String );
	VString( s : String );
	VUnit( v : Float, unit : String );
	VFloat( v : Float );
	VInt( v : Int );
	VHex( h : String, v : Int );
	VList( l : Array<CssValue> );
	VGroup( l : Array<CssValue> );
	VCall( f : String, vl : Array<CssValue> );
	VLabel( v : String, val : CssValue );
	VSlash;
}

class ValueParser {

	public function new() {
	}

	public function invalidProp( ?msg ) : Dynamic {
		throw new InvalidProperty(msg);
	}

	public function parseIdent( v : CssValue ) {
		return switch( v ) { case VIdent(v): v; default: invalidProp(); }
	}

	public function parseColor( v : CssValue ) {
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
			return invalidProp();
		}
	}

	function loadResource( path : String ) {
		#if macro
		// TODO : compile-time path check?
		return true;
		#else
		return try hxd.res.Loader.currentInstance.load(path) catch( e : hxd.res.NotFound ) invalidProp("Resource not found "+path);
		#end
	}

	public function parseTile( v : CssValue) {
		try {
			var c = parseColor(v);
			return #if macro true #else h2d.Tile.fromColor(c,1,1,(c>>>24)/255) #end;
		} catch( e : InvalidProperty ) {
			var path = parsePath(v);
			var p = loadResource(path);
			return #if macro p #else p.toTile() #end;
		}
	}

	public function parseArray<T>( elt : CssValue -> T, v : CssValue ) : Array<T> {
		return switch( v ) {
		case VGroup(vl): [for( v in vl ) elt(v)];
		default: [elt(v)];
		}
	}

	public function parsePath( v : CssValue ) {
		return switch( v ) {
		case VString(v): v;
		case VIdent(v): v;
		case VCall("url",[VIdent(v) | VString(v)]): v;
		default: invalidProp();
		}
	}

	public function parseBool( v : CssValue ) : Null<Bool> {
		return switch( v ) {
		case VIdent("true") | VInt(1): true;
		case VIdent("false") | VInt(0): false;
		default: invalidProp();
		}
	}

	public function parseAuto<T>( either : CssValue -> T, v : CssValue ) : Null<T> {
		return v.match(VIdent("auto")) ? null : either(v);
	}

	public function parseNone<T>( either : CssValue -> T, v : CssValue ) : Null<T> {
		return v.match(VIdent("none")) ? null : either(v);
	}

	public function parseInt( v : CssValue ) : Null<Int> {
		return switch( v ) {
		case VInt(i): i;
		default: invalidProp();
		}
	}

	public function parseFloat( v : CssValue ) : Float {
		return switch( v ) {
		case VInt(i): i;
		case VFloat(f): f;
		default: invalidProp();
		}
	}

	public function parseXY( v : CssValue ) {
		return switch( v ) {
		case VGroup([x,y]): { x : parseFloat(x), y : parseFloat(y) };
		default: invalidProp();
		}
	}

	public function parseHAlign( value ) : #if macro Bool #else h2d.Flow.FlowAlign #end {
		switch( parseIdent(value) ) {
		case "auto":
			return null;
		case "middle":
			return #if macro true #else Middle #end;
		case "left":
			return #if macro true #else Left #end;
		case "right":
			return #if macro true #else Right #end;
		case x:
			return invalidProp(x+" should be auto|left|middle|right");
		}
	}

	public function parseVAlign( value ) : #if macro Bool #else h2d.Flow.FlowAlign #end {
		switch( parseIdent(value) ) {
		case "auto":
			return null;
		case "middle":
			return #if macro true #else Middle #end;
		case "top":
			return #if macro true #else Top #end;
		case "bottom":
			return #if macro true #else Bottom #end;
		case x:
			return invalidProp(x+" should be auto|top|middle|bottom");
		}
	}

	public function parseAlign( value : CssValue ) {
		switch( value ) {
		case VIdent("auto"):
			return { h : null, v : null };
		case VIdent(_):
			try {
				return { h : parseHAlign(value), v : null };
			} catch( e : InvalidProperty ) {
				return { h : null, v : parseVAlign(value) };
			}
		case VGroup([h,v]):
			try {
				return { h : parseHAlign(h), v : parseVAlign(v) };
			} catch( e : InvalidProperty ) {
				return { h : parseHAlign(v), v : parseVAlign(h) };
			}
		default:
			return invalidProp();
		}
	}

	public function parseBox( v : CssValue ) {
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
			return invalidProp();
		}
	}

}