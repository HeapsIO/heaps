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

	public function parseString( v : CssValue ) {
		return switch( v ) {
		case VIdent(i): i;
		case VString(s): s;
		default: invalidProp();
		}
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

	function parseColorF( v : CssValue ) : h3d.Vector {
		var c = parseColor(v);
		var v = new h3d.Vector();
		v.setColor(c);
		return v;
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

	public function makeEnumParser<T:EnumValue>( e : Enum<T> ) : CssValue -> T {
		var h = new Map();
		var all = [];
		for( v in e.createAll() ) {
			var id = v.getName().toLowerCase();
			h.set(id, v);
			all.push(id);
		}
		var choices = all.join("|");
		return function( v : CssValue ) {
			return switch( v ) {
			case VIdent(i):
				var v = h.get(i);
				if( v == null ) invalidProp(i+" should be "+choices);
				return v;
			default:
				invalidProp();
			}
		}

	}

}