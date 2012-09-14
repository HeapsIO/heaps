package h3d.fbx;

enum FbxProp {
	PInt( v : Int );
	PFloat( v : Float );
	PString( v : String );
	PIdent( i : String );
	PInts( v : Array<Int> );
	PFloats( v : Array<Float> );
}

typedef FbxNode = {
	var name : String;
	var props : Array<FbxProp>;
	var childs : Array<FbxNode>;
}

class FbxTools {

	public static function get( n : FbxNode, path : String ) {
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
			if( !found )
				throw n.name + " does not have " + path+" ("+p+" not found)";
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
		default: throw "Invalid prop " + n;
		}
	}
	
}