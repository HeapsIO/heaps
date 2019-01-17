package h2d.uikit;
import h2d.uikit.Property;

class Component<T:h2d.Object> {

	public var name : String;
	public var cl : Class<T>;
	public var make : h2d.Object -> T;
	public var parent : Component<Dynamic>;
	var propsHandler : Array<T -> Dynamic -> Void>;

	public function new(name, cl, make, parent) {
		this.name = name;
		this.cl = cl;
		this.make = make;
		this.parent = parent;
		propsHandler = parent == null ? [] : cast parent.propsHandler.copy();
		COMPONENTS.set(name, this);
	}

	public inline function getHandler<P>( p : Property<P> ) : T -> P -> Void {
		return propsHandler[p.id];
	}

	function invalidProp( ?msg ) : Dynamic {
		throw new InvalidProperty(msg);
	}

	function parseIdent( v : CssParser.Value ) {
		return switch( v ) { case VIdent(v): v; default: invalidProp(); }
	}

	function parseColor( v : CssParser.Value ) {
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
		return try hxd.res.Loader.currentInstance.load(path) catch( e : hxd.res.NotFound ) invalidProp("Resource not found "+path);
	}

	function parseTile( v : CssParser.Value ) {
		try {
			var c = parseColor(v);
			return h2d.Tile.fromColor(c,1,1,(c>>>24)/255);
		} catch( e : InvalidProperty ) {
			var path = parsePath(v);
			return loadResource(path).toTile();
		}
	}

	function parsePath( v : CssParser.Value ) {
		return switch( v ) {
		case VString(v): v;
		case VIdent(v): v;
		case VCall("url",[VIdent(v) | VString(v)]): v;
		default: invalidProp();
		}
	}

	function parseBool( v : CssParser.Value ) : Null<Bool> {
		return switch( v ) {
		case VIdent("true") | VInt(1): true;
		case VIdent("false") | VInt(0): false;
		default: invalidProp();
		}
	}

	function parseAuto<T>( either : CssParser.Value -> T, v : CssParser.Value ) : Null<T> {
		return v.match(VIdent("auto")) ? null : either(v);
	}

	function parseNone<T>( either : CssParser.Value -> T, v : CssParser.Value ) : Null<T> {
		return v.match(VIdent("none")) ? null : either(v);
	}

	function parseInt( v : CssParser.Value ) : Null<Int> {
		return switch( v ) {
		case VInt(i): i;
		default: invalidProp();
		}
	}

	function parseFloat( v : CssParser.Value ) : Float {
		return switch( v ) {
		case VInt(i): i;
		case VFloat(f): f;
		default: invalidProp();
		}
	}

	function parseXY( v : CssParser.Value ) {
		return switch( v ) {
		case VGroup([x,y]): { x : parseFloat(x), y : parseFloat(y) };
		default: invalidProp();
		}
	}

	function parseHAlign( value ) : h2d.Flow.FlowAlign {
		switch( parseIdent(value) ) {
		case "auto":
			return null;
		case "middle":
			return Middle;
		case "left":
			return Left;
		case "right":
			return Right;
		default:
			return invalidProp();
		}
	}

	function parseVAlign( value ) : h2d.Flow.FlowAlign {
		switch( parseIdent(value) ) {
		case "auto":
			return null;
		case "middle":
			return Middle;
		case "top":
			return Top;
		case "bottom":
			return Bottom;
		default:
			return invalidProp();
		}
	}

	function parseAlign( value : CssParser.Value ) {
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

	function parseBox( v : CssParser.Value ) {
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

	inline function defineProp<P>( name : String, parser : CssParser.Value -> P, def : P ) {
		return new Property<P>(name, parser, def);
	}

	function addHandler<P>( p : Property<P>, f : T -> P -> Void ) {
		propsHandler[p.id] = f;
	}

	public static function get( name : String ) {
		return COMPONENTS.get(name);
	}

	static var COMPONENTS = new Map<String,Component<Dynamic>>();

}
