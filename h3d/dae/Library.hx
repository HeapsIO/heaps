package h3d.dae;
using h3d.dae.Tools;

class Library {
	
	var root : DAE;
	var hmeshes : Hash<Mesh>;
	var meshes : Array<Mesh>;
	
	public function new( d : DAE ) {
		root = d;
		hmeshes = new Hash();
		meshes = [];
		for( m in root.getAll("library_geometries.geometry") ) {
			var m = new Mesh(m);
			hmeshes.set(m.name, m);
			meshes.push(m);
		}
		for( c in root.getAll("library_controllers.controller") ) {
			var name = c.attr("name").toString();
			get(name).controller = c;
		}
	}
	
	public function get( name : String ) {
		return hmeshes.get(name);
	}
	
	public function getAll() {
		return meshes;
	}
	
}