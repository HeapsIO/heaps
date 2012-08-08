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
	
	static function buildBones( d : DAE, nbones : Int, cutoff : Float ) {
		for( geom in Tools.getAll(d, "library_geometries.geometry") ) {
			var name = Tools.toString(Tools.attr(geom, "name"));
			for( poly in Tools.getAll(geom, "mesh.polylist") ) {
				// get all envelops
				var bones = [];
				for( bone in Tools.getAll(poly, "input[semantic=WEIGHT]") ) {
					var source = Tools.toString(Tools.attr(bone, "source")).substr(1);
					if( source.indexOf("__item_locator") < 0 ) continue;
					var b = switch( Tools.get(geom, "mesh.source[id=" + source + "].float_array").value ) {
					case DFloatArray(vl, _): vl;
					case DFloat(v): Tools.makeTable([v]);
					case DInt(v): Tools.makeTable([v * 1.0]);
					default:
						throw "assert "+source;
					}
					bones.push( { id : bones.length, b : b, pos : Tools.toInt(Tools.attr(bone, "offset")) } );
				}
				if( bones.length == 0 )
					continue;
				// get weights indexes
				var vcount = getVCount(poly);
				var idx = switch( Tools.get(poly, "p").value ) {
				case DIntArray(idx,_): idx;
				default: throw "assert";
				}
				var stride = Std.int(idx.length / vcount);
				
				var bidx = Tools.makeTable([]);
				var bweights = Tools.makeTable([]);
				for( p in 0...vcount ) {
					var vbones = [];
					for( b in bones ) {
						var w = b.b[idx[p * stride + b.pos]];
						if( w < 0 )
							throw "assert " + w;
						if( w != 0 )
							vbones.push( { id : b.id, w : w } );
					}
					vbones.sort(function(b1, b2) return Reflect.compare(b1.w, b2.w));
					var rem = 0.;
					while( vbones.length > nbones )
						rem += vbones.shift().w;
					var tot = 0.;
					for( b in vbones )
						tot += b.w;
					for( b in vbones.copy() ) {
						var w = b.w / tot;
						if( w < cutoff ) {
							vbones.remove(b);
							tot -= b.w;
							rem += b.w;
						}
					}
					var remFactor = rem / (tot + rem);
					var count = 0;
					for( b in vbones ) {
						var w = b.w / tot;
						bidx.push(b.id);
						bweights.push(b.w / tot);
					}
					for( i in vbones.length...nbones ) {
						bidx.push(0);
						bweights.push(0.);
					}
				}
				poly.subs.push( { name : "bidx", value : DIntArray(bidx, nbones) } );
				poly.subs.push( { name : "bweight", value : DFloatArray(bweights, nbones) } );
			}
		}
	}
	
	public static function build( d : DAE ) : DAE {
		buildBones(d,3,0.1);
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
		s.keep("library_geometries.geometry.mesh.polylist.bidx");
		s.keep("library_geometries.geometry.mesh.polylist.bweight");
		d = s.simplify(d);
		return d;
	}
	
}