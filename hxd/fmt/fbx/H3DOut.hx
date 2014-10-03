package hxd.fmt.fbx;
using hxd.fmt.fbx.Data;
import hxd.fmt.fbx.BaseLibrary;
import hxd.fmt.h3d.Data;

class H3DOut extends BaseLibrary {

	public function new() {
		super();
	}

	public function toH3D( filePath : String ) : Data {

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
						trace(path);
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
				var geom = new hxd.fmt.fbx.Geometry(this, g);
				throw "TODO";
			}
			model.geometries = gdata.gids.copy();
			model.materials = [];
			for( i in gdata.mindexes ) {
				if( mids[i] == null ) throw "assert"; // TODO : create a null material color
				model.materials.push(mids[i]);
			}
		}
		return d;
	}

}