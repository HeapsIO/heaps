package hxd.fmt.h3d;

class Library {

	var entry : hxd.res.FileEntry;
	var header : Data;
	var cachedPrimitives : Array<h3d.prim.Primitive>;

	public function new(entry, header) {
		this.entry = entry;
		this.header = header;
		cachedPrimitives = [];
	}

	function makePrimitive( id : Int ) {
		var p = cachedPrimitives[id];
		if( p != null ) return p;
		p = new h3d.prim.H3DModel(header.geometries[id], header.dataPosition, entry);
		cachedPrimitives[id] = p;
		return p;
	}

	function makeMaterial( mid : Int, loadTexture : String -> h3d.mat.Texture ) {
		var m = header.materials[mid];
		var mat = new h3d.mat.MeshMaterial();
		mat.name = m.name;
		if( m.diffuseTexture != null ) {
			mat.texture = loadTexture(m.diffuseTexture);
			if( mat.texture == null ) mat.texture = h3d.mat.Texture.fromColor(0xFF00FF);
		}
		mat.blendMode = m.blendMode;
		mat.mainPass.culling = m.culling;
		if( m.killAlpha != null ) {
			var t = mat.mainPass.getShader(h3d.shader.Texture);
			t.killAlpha = true;
			t.killAlphaThreshold = m.killAlpha;
		}
		return mat;
	}

	public function makeObject( ?loadTexture : String -> h3d.mat.Texture ) : h3d.scene.Object {
		if( loadTexture == null )
			loadTexture = function(_) return h3d.mat.Texture.fromColor(0xFF00FF);
		if( header.models.length == 0 )
			throw "This file does not contain any model";
		var objs = [];
		for( m in header.models ) {
			var obj : h3d.scene.Object;
			if( m.geometries == null ) {
				obj = new h3d.scene.Object();
			} else {
				var prim = m.geometries.length == 1 ? makePrimitive(m.geometries[0]) : new h3d.prim.MultiPrimitive([for( g in m.geometries ) makePrimitive(g)]);
				if( m.materials.length == 1 )
					obj = new h3d.scene.Mesh(prim, makeMaterial(m.materials[0],loadTexture));
				else
					obj = new h3d.scene.MultiMaterial(prim, [for( m in m.materials ) makeMaterial(m,loadTexture)]);
			}
			obj.name = m.name;
			obj.defaultTransform = m.position.toMatrix();
			objs.push(obj);
			if( objs.length > 1 )
				objs[m.parent].addChild(obj);
		}
		return objs[0];
	}

	public function loadAnimation( mode : h3d.anim.Mode, ?name : String ) : h3d.anim.Animation {
		throw "TODO";
		return null;
	}

}