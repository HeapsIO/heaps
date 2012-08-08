package h3d.dae;

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
		s.keep("library_geometries.geometry.mesh.source[name=positions].float_array");
		s.keep("library_geometries.geometry.mesh.source[name=normals].float_array");
		s.keep("library_geometries.geometry.mesh.source[name=Texture].float_array");
		
		// remove not needed indexes
		s.filter("library_geometries.geometry.mesh.polylist", function(n:DAE) {
			var vcount = getVCount(n);
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
		});
		s.keep("library_geometries.geometry.mesh.polylist.p");
		s.keep("library_geometries.geometry.mesh.polylist.vcount");
		s.keep("library_controllers.controller.skin");
		d = s.simplify(d);
		return d;
	}
	
}