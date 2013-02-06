package h3d.dae;
using h3d.dae.Tools;

class BAEBuild  {

	static function getVCount( poly : DAE ) {
		switch( Tools.get(poly, "vcount").value ) {
		case DIntArray(vl, _):
			var tot = 0;
			for( v in vl )
				tot += v;
			return tot;
		case DInt(n):
			return n;
		default:
			throw "assert";
		}
	}
	
	public static function build( d : DAE ) : DAE {
		var s = new Simplifier();
		
		// keep inputs for indexing
		s.keep("library_geometries.geometry.mesh.?.input[semantic=VERTEX]");
		s.keep("library_geometries.geometry.mesh.?.input[semantic=NORMAL]");
		s.keep("library_geometries.geometry.mesh.?.input[semantic=TEXCOORD]");
		s.keep("library_geometries.geometry.mesh.vertices.input[semantic=POSITION]");

		// keep sources
		s.keep("library_geometries.geometry.mesh.source[id=&{_.vertices[id=&{_.?.input[semantic=VERTEX].source}].input[semantic=POSITION].source}].float_array");
		s.keep("library_geometries.geometry.mesh.source[id=&{_.?.input[semantic=NORMAL].source}].float_array");
		s.keep("library_geometries.geometry.mesh.source[id=&{_.?.input[semantic=TEXCOORD].source}].float_array");
		
		// remove not needed indexes
		function filterMesh(isPoly, n:DAE) {
			var vcount = isPoly ? getVCount(n) : n.attr("count").toInt() * 3;
			var p = Tools.get(n, "p");
			switch( p.value ) {
			case DIntArray(vl, _):
				var vl2 = Tools.makeTable([]);
				var stride = Std.int(vl.length / vcount);
				if( stride <= 8 ) return false;
				var pos = 0;
				for( i in 0...vcount ) {
					for( i in 0...8 )
						vl2.push(vl[pos+i]);
					pos += stride;
				}
				p.value = DIntArray(vl2, 8);
			default:
			}
			return false;
		}
		s.filter("library_geometries.geometry.mesh.triangles", filterMesh.bind(false));
		s.filter("library_geometries.geometry.mesh.polylist", filterMesh.bind(true));
		
		s.keep("library_geometries.geometry.mesh.polylist.p");
		s.keep("library_geometries.geometry.mesh.polylist.vcount");
		s.keep("library_geometries.geometry.mesh.triangles.p");
		
		s.keep("library_controllers.controller.skin");
		s.keep("library_visual_scenes.visual_scene.node");
		d = s.simplify(d);
		return d;
	}
	
}