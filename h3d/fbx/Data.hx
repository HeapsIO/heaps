package h3d.fbx;

enum FbxProp {
	PInt( v : Int );
	PFloat( v : Float );
	PString( v : String );
	PIdent( i : String );
	PInts( v : Array<Int> );
	PFloats( v : Array<Float> );
}

@:publicFields
class FbxNode {
	var name : String;
	var props : Array<FbxProp>;
	var childs : Array<FbxNode>;
	
	/**
	 * 
	 * @param	n
	 * @param	p
	 * @param	c
	 */
	public function new(n,p,c) {
		name = n;
		props = p;
		childs = c;
	}
	
	public inline function toString() {
		return '$name \n $props \n $childs';
	}
}

class FbxTools {

	public static function get( n : FbxNode, path : String, opt = false ) {
		var parts = path.split(".");
		var cur = n;
		for( p in parts ) {
			var found = false;
			for( c in cur.childs )
				if( c.name == p ) {
					cur = c;
					found = true;
					break;
				}
			if( !found ) {
				if( opt )
					return null;
				throw n.name + " does not have " + path+" ("+p+" not found)";
			}
		}
		return cur;
	}

	public static function getAll( n : FbxNode, path : String ) {
		var parts = path.split(".");
		var cur = [n];
		for( p in parts ) {
			var out = [];
			for( n in cur )
				for( c in n.childs )
					if( c.name == p )
						out.push(c);
			cur = out;
			if( cur.length == 0 )
				return cur;
		}
		return cur;
	}
	
	public static function getInts( n : FbxNode ) {
		if( n.props.length != 1 )
			throw n.name + " has " + n.props + " props";
		switch( n.props[0] ) {
		case PInts(v):
			return v;
		default:
			throw n.name + " has " + n.props + " props";
		}
	}

	public static function getFloats( n : FbxNode ) {
		if( n.props.length != 1 )
			throw n.name + " has " + n.props + " props";
		switch( n.props[0] ) {
		case PFloats(v):
			return v;
		case PInts(i):
			var fl = new Array<Float>();
			for( x in i )
				fl.push(x);
			return fl;
		default:
			throw n.name + " has " + n.props + " props";
		}
	}
	
	public static function hasProp( n : FbxNode, p : FbxProp ) {
		for( p2 in n.props )
			if( Type.enumEq(p, p2) )
				return true;
		return false;
	}
	
	public static function toInt( n : FbxProp ) {
		if( n == null ) throw "null prop";
		return switch( n ) {
		case PInt(v): v;
		case PFloat(f): return Std.int( f );
		default: throw "Invalid prop " + n;
		}
	}

	public static function toFloat( n : FbxProp ) {
		if( n == null ) throw "null prop";
		return switch( n ) {
		case PInt(v): v * 1.0;
		case PFloat(v): v;
		default: throw "Invalid prop " + n;
		}
	}

	public static function toString( n : FbxProp ) {
		if( n == null ) throw "null prop";
		return switch( n ) {
		case PString(v): v;
		default: throw "Invalid prop " + n;
		}
	}
	
	public static function getId( n : FbxNode ) {
		if( n.props.length != 3 )
			throw n.name + " is not an object";
		return switch( n.props[0] ) {
		case PInt(id): id;
		case PFloat(id) : Std.int( id );
		default: throw n.name + " is not an object " + n.props;
		}
	}

	public static function getName( n : FbxNode ) {
		if( n.props.length != 3 )
			throw n.name + " is not an object";
		return switch( n.props[1] ) {
		case PString(n): n.split("::").pop();
		default: throw n.name + " is not an object";
		}
	}

	public static function getType( n : FbxNode ) {
		if( n.props.length != 3 )
			throw n.name + " is not an object";
		return switch( n.props[2] ) {
		case PString(n): n;
		default: throw n.name + " is not an object";
		}
	}
	
}