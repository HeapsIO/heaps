package hxd.fmt.fbx;
using hxd.fmt.fbx.Data;
import hxd.fmt.fbx.BaseLibrary;
import hxd.fmt.h3d.Data;

class H3DOut extends BaseLibrary {

	function buildGeom( geom : hxd.fmt.fbx.Geometry, dataOut : haxe.io.BytesOutput ) {
		var g = new Geometry();

		var verts = geom.getVertices();
		var normals = geom.getNormals();
		var uvs = geom.getUVs();
		var colors = geom.getColors();

		// build format
		g.vertexFormat = [
			new GeometryFormat("position", DVec3),
		];
		if( normals != null )
			g.vertexFormat.push(new GeometryFormat("normal", DVec3));
		for( i in 0...uvs.length )
			g.vertexFormat.push(new GeometryFormat("uv" + (i == 0 ? "" : "" + (i + 1)), DVec2));
		if( colors != null )
			g.vertexFormat.push(new GeometryFormat("color", DVec3));

		var stride = 3 + (normals == null ? 2 : 0) + uvs.length * 2 + (colors == null ? 0 : 3);
		g.vertexStride = stride;
		g.vertexCount = 0;

		// build geometry
		var gt = geom.getGeomTranslate();
		if( gt == null ) gt = new h3d.col.Point();

		var vbuf = new hxd.FloatBuffer();
		var ibuf = new hxd.IndexBuffer();

		var tmpBuf = new haxe.ds.Vector(stride);
		var vertexRemap = [];
		var index = geom.getPolygons();
		var count = 0;
		for( pos in 0...index.length ) {
			var i = index[pos];
			count++;
			if( i >= 0 )
				continue;
			index[pos] = -i - 1;
			var start = pos - count + 1;
			for( n in 0...count ) {
				var k = n + start;
				var vidx = index[k];
				var p = 0;

				var x = verts[vidx * 3] + gt.x;
				var y = verts[vidx * 3 + 1] + gt.y;
				var z = verts[vidx * 3 + 2] + gt.z;
				tmpBuf[p++] = x;
				tmpBuf[p++] = y;
				tmpBuf[p++] = z;

				if( normals != null ) {
					var nx = normals[k * 3];
					var ny = normals[k * 3 + 1];
					var nz = normals[k * 3 + 2];
					tmpBuf[p++] = nx;
					tmpBuf[p++] = ny;
					tmpBuf[p++] = nz;
				}

				for( tuvs in uvs ) {
					var iuv = tuvs.index[k];
					tmpBuf[p++] = tuvs.values[iuv * 2];
					tmpBuf[p++] = 1 - tuvs.values[iuv * 2 + 1];
				}

				if( colors != null ) {
					var icol = colors.index[k];
					tmpBuf[p++] = colors.values[icol * 4];
					tmpBuf[p++] = colors.values[icol * 4 + 1];
					tmpBuf[p++] = colors.values[icol * 4 + 2];
				}

				// look if the vertex already exists
				var found = null;
				for( vid in 0...g.vertexCount ) {
					var same = true;
					var p = vid * stride;
					for( i in 0...stride )
						if( vbuf[p++] != tmpBuf[i] ) {
							same = false;
							break;
						}
					if( same ) {
						found = vid;
						break;
					}
				}
				if( found == null ) {
					found = g.vertexCount;
					g.vertexCount++;
					for( i in 0...stride )
						vbuf.push(tmpBuf[i]);
				}
				vertexRemap.push(found);
			}

			for( n in 0...count - 2 ) {
				ibuf.push(vertexRemap[start + n]);
				ibuf.push(vertexRemap[start + count - 1]);
				ibuf.push(vertexRemap[start + n + 1]);
			}

			index[pos] = i; // restore
			count = 0;
		}

		// write data
		g.vertexPosition = dataOut.length;
		for( i in 0...vbuf.length )
			dataOut.writeFloat(vbuf[i]);
		g.indexPosition = dataOut.length;
		g.indexCount = ibuf.length;
		for( i in 0...ibuf.length )
			dataOut.writeUInt16(ibuf[i]);

		return g;
	}

	public function toH3D( filePath : String ) : Data {

		leftHandConvert();
		autoMerge();

		if( filePath != null ) {
			filePath = filePath.split("\\").join("/").toLowerCase();
			if( !StringTools.endsWith(filePath, "/") )
				filePath += "/";
		}

		var root = buildHierarchy().root;
		if( root.childs.length == 1 ) {
			root = root.childs[0];
			root.parent = null;
		}

		var objects = [];
		function indexRec( t : TmpObject ) {
			t.index = objects.length;
			objects.push(t);
			for( c in t.childs )
				indexRec(c);
		}
		indexRec(root);

		var d = new Data();
		d.version = 1;
		d.geometries = [];
		d.materials = [];
		d.models = [];

		var dataOut = new haxe.io.BytesOutput();

		var hgeom = new Map<Int,{ gids : Array<Int>, mindexes : Array<Int> }>();
		var hmat = new Map<Int,Int>();
		for( o in objects ) {
			var model = new Model();
			model.name = o.model.getName();
			model.parent = o.parent == null ? 0 : o.parent.index;
			var m = getDefaultMatrixes(o.model);
			var p = new Position();
			p.x = m.trans == null ? 0 : -m.trans.x;
			p.y = m.trans == null ? 0 : m.trans.y;
			p.z = m.trans == null ? 0 : m.trans.z;
			p.sx = m.scale == null ? 1 : m.scale.x;
			p.sy = m.scale == null ? 1 : m.scale.y;
			p.sz = m.scale == null ? 1 : m.scale.z;
			// TODO : rotate in left hand and handle pre-rot
			p.rx = 0;
			p.ry = 0;
			p.rz = 0;
			model.position = p;
			d.models.push(model);

			if( !o.isMesh ) continue;

			var mids = [];
			for( m in getChilds(o.model, "Material") ) {
				var mid = hmat.get(m.getId());
				if( mid != null ) {
					mids.push(mid);
					continue;
				}
				var mat = new Material();
				mid = d.materials.length;
				mids.push(mid);
				hmat.set(m.getId(), mid);
				d.materials.push(mat);

				mat.name = m.getName();
				mat.culling = Back; // don't use FBX Culling infos (OFF by default)
				mat.blendMode = None;

				// if there's a slight amount of opacity on the material
				// it's usually meant to perform additive blending on 3DSMax
				for( p in m.getAll("Properties70.P") )
					if( p.props[0].toString() == "Opacity" ) {
						var v = p.props[4].toFloat();
						if( v < 1 && v > 0.98 ) mat.blendMode = Add;
					}

				// get texture
				var texture = getSpecChild(m, "DiffuseColor");
				if( texture != null ) {
					var path = texture.get("FileName").props[0].toString();
					if( path != "" ) {
						path = path.split("\\").join("/");
						if( filePath != null && StringTools.startsWith(path.toLowerCase(), filePath) )
							path = path.substr(filePath.length);
						else {
							// relative resource path
							var k = path.split("/res/");
							if( k.length > 1 ) {
								k.shift();
								path = k.join("/res/");
							}
						}
						mat.diffuseTexture = path;
					}
				}

				// get alpha map
				var transp = getSpecChild(m, "TransparentColor");
				if( transp != null ) {
					var path = transp.get("FileName").props[0].toString();
					if( path != "" ) {
						if( texture != null && path.toLowerCase() == texture.get("FileName").props[0].toString().toLowerCase() ) {
							// if that's the same file, we're doing alpha blending
							mat.blendMode = Alpha;
						} else
							throw "TODO : alpha texture";
					}
				}
			}

			var g = getChild(o.model, "Geometry");
			var gdata = hgeom.get(g.getId());
			if( gdata == null ) {
				var geom = buildGeom(new hxd.fmt.fbx.Geometry(this, g), dataOut);
				var gid = d.geometries.length;
				d.geometries.push(geom);
				gdata = {
					gids : [gid],
					mindexes : [0],
				};
				hgeom.set(g.getId(), gdata);
			}
			model.geometries = gdata.gids.copy();
			model.materials = [];
			for( i in gdata.mindexes ) {
				if( mids[i] == null ) throw "assert"; // TODO : create a null material color
				model.materials.push(mids[i]);
			}
		}

		d.data = dataOut.getBytes();
		return d;
	}

}