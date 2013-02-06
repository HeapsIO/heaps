package h3d.dae;
using h3d.dae.Tools;

class Library {
	
	public var root : DAE;
	var hmeshes : Map<String,Mesh>;
	var meshes : Array<Mesh>;
	var hnodes : Map<String,DAE>;
	
	public function new( d : DAE ) {
		root = d;
		hmeshes = new Map();
		meshes = [];
		for( m in root.getAll("library_geometries.geometry") ) {
			var m = new Mesh(this,m);
			var node = root.getAll("library_visual_scenes.visual_scene.node[name=" + m.name + "]")[0];
			if( node != null )
				m.controller = root.get("library_controllers.controller[id=" + node.get("instance_controller").attr("url").toString().substr(1) + "]");
			hmeshes.set(m.name, m);
			meshes.push(m);
		}
	}
	
	public function get( name : String ) {
		return hmeshes.get(name);
	}
	
	public function getAll() {
		return meshes;
	}
	
}