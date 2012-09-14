package h3d.fbx;
using h3d.fbx.Data;

class Library {

	var root : FbxNode;
	var connect : IntHash<Array<Int>>;
	
	public function new() {
		root = { name : "root", props : [], childs : [] };
		connect = new IntHash();
	}
	
	public function loadTextFile( data : String ) {
		for( n in Parser.parse(data) )
			init(n);
	}
	
	function init( n : FbxNode ) {
		switch( n.name ) {
		case "Connections":
			for( c in n.childs ) {
				if( c.name != "C" )
					continue;
				var pid = c.props[1].toInt();
				var pid2 = c.props[2].toInt();
				var c = connect.get(pid);
				if( c == null ) {
					c = [];
					connect.set(pid, c);
				}
				c.push(pid2);
			}
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
	
}