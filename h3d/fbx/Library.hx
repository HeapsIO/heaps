package h3d.fbx;
using h3d.fbx.Data;

class Library {

	var root : FbxNode;
	var ids : IntHash<FbxNode>;
	var connect : IntHash<Array<Int>>;
	var invConnect : IntHash<Array<Int>>;
	
	public function new() {
		root = { name : "root", props : [], childs : [] };
		ids = new IntHash();
		connect = new IntHash();
		invConnect = new IntHash();
	}
	
	public function loadTextFile( data : String ) {
		for( n in Parser.parse(data) )
			init(n);
	}
	
	public function load( x : Iterable<FbxNode> ) {
		for ( r in x ) init( r );
	}
	
	function init( n : FbxNode ) {
		switch( n.name ) {
		case "Connections":
			for( c in n.childs ) {
				if( c.name != "C" )
					continue;
				var child = c.props[1].toInt();
				var parent = c.props[2].toInt();
				
				var c = connect.get(parent);
				if( c == null ) {
					c = [];
					connect.set(parent, c);
				}
				c.push(child);

				if( parent == 0 )
					continue;
								
				var c = invConnect.get(child);
				if( c == null ) {
					c = [];
					invConnect.set(child, c);
				}
				c.push(parent);
			}
		case "Objects":
			for( c in n.childs )
				ids.set(c.getId(), c);
			root.childs.push(n);
		default:
			root.childs.push(n);
		}
	}
	
	public function getMesh( name : String ) {
		var geom = null;
		for( g in root.getAll("Objects.Geometry") )
			if( g.hasProp(PString("Geometry::" + name)) ) {
				geom = g;
				break;
			}
		if( geom == null )
			throw "Mesh " + name + " not found";
		return new Mesh(this, geom);
	}
	
	public function getSubs( node : FbxNode, ?nodeName : String ) {
		var c = connect.get(node.getId());
		var subs = [];
		if( c != null )
			for( id in c ) {
				var n = ids.get(id);
				if( n == null ) throw id + " not found";
				if( nodeName != null && n.name != nodeName ) continue;
				subs.push(n);
			}
		return subs;
	}

	public function getParents( node : FbxNode, ?nodeName : String ) {
		var c = invConnect.get(node.getId());
		var pl = [];
		if( c != null )
			for( id in c ) {
				var n = ids.get(id);
				if( n == null ) throw id + " not found";
				if( nodeName != null && n.name != nodeName ) continue;
				pl.push(n);
			}
		return pl;
	}
	
	public function getRoot() {
		return root;
	}
	
}