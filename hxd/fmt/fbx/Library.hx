package hxd.fmt.fbx;
using hxd.fmt.fbx.Data;

private typedef TmpObject = {
	var model : FbxNode;
	var parent : TmpObject;
	var isJoint : Bool;
	var isMesh : Bool;
	var childs : Array<TmpObject>;
	@:optional var obj : h3d.scene.Object;
	@:optional var joint : h3d.anim.Skin.Joint;
}

class Library extends BaseLibrary {


	public function makeObject( ?textureLoader : String -> FbxNode -> h3d.mat.MeshMaterial ) : h3d.scene.Object {
		var scene = new h3d.scene.Object();
		var hgeom = new Map();
		var hskins = new Map();
		var objects = new Array<TmpObject>();
		var hobjects = new Map<Int, TmpObject>();

		if( textureLoader == null ) {
			var tmpTex = null;
			textureLoader = function(_,_) {
				if( tmpTex == null )
					tmpTex = h3d.mat.Texture.fromColor(0xFF00FF);
				return new h3d.mat.MeshMaterial(tmpTex);
			}
		}

		autoMerge();

		// init objects
		var oroot : TmpObject = { model : null, isJoint : false, isMesh : false, childs : [], parent : null, obj : scene };
		hobjects.set(0, oroot);
		for( model in root.getAll("Objects.Model") ) {
			if( skipObjects.get(model.getName()) )
				continue;
			var mtype = model.getType();
			var isJoint = mtype == "LimbNode" && (!unskinnedJointsAsObjects || !isNullJoint(model));
			var o : TmpObject = { model : model, isJoint : isJoint, isMesh : mtype == "Mesh", parent : null, childs : [], obj : null };
			hobjects.set(model.getId(), o);
			objects.push(o);
		}

		// build hierarchy
		for( o in objects ) {
			var p = getParent(o.model, "Model", true);
			var pid = if( p == null ) 0 else p.getId();
			var op = hobjects.get(pid);
			if( op == null ) op = oroot; // if parent has been removed
			op.childs.push(o);
			o.parent = op;
		}

		// propagates joint flags
		var changed = true;
		while( changed ) {
			changed = false;
			for( o in objects ) {
				if( o.isJoint || o.isMesh ) continue;
				if( o.parent.isJoint ) {
					o.isJoint = true;
					changed = true;
					continue;
				}
				var hasJoint = false;
				for( c in o.childs )
					if( c.isJoint ) {
						hasJoint = true;
						break;
					}
				if( hasJoint )
					for( c in o.parent.childs )
						if( c.isJoint ) {
							o.isJoint = true;
							changed = true;
							break;
						}
			}
		}


		// create all models
		for( o in objects ) {
			var name = o.model.getName();
			if( o.isMesh ) {
				if( o.isJoint )
					throw "Model " + getModelPath(o.model) + " was tagged as joint but is mesh";
				// load geometry
				var g = getChild(o.model, "Geometry");
				var prim = hgeom.get(g.getId());
				if( prim == null ) {
					prim = new h3d.prim.FBXModel(new Geometry(this, g));
					hgeom.set(g.getId(), prim);
				}
				// load materials
				var mats = getChilds(o.model, "Material");
				var tmats = [];
				var vcolor = prim.geom.getColors() != null;
				var lastAdded = 0;
				for( mat in mats ) {
					var tex = getChilds(mat, "Texture")[0];
					if( tex == null ) {
						tmats.push(null);
						continue;
					}
					var mat = textureLoader(tex.get("FileName").props[0].toString(),mat);
					if( vcolor && allowVertexColor )
						mat.mainPass.addShader(new h3d.shader.VertexColor());
					tmats.push(mat);
					lastAdded = tmats.length;
				}
				while( tmats.length > lastAdded )
					tmats.pop();
				if( tmats.length == 0 )
					tmats.push(new h3d.mat.MeshMaterial(h3d.mat.Texture.fromColor(0xFF00FF)));
				// create object
				if( tmats.length == 1 )
					o.obj = new h3d.scene.Mesh(prim, tmats[0], scene);
				else {
					prim.multiMaterial = true;
					o.obj = new h3d.scene.MultiMaterial(prim, tmats, scene);
				}
			} else if( o.isJoint ) {
				var j = new h3d.anim.Skin.Joint();
				getDefaultMatrixes(o.model); // store for later usage in animation
				j.index = o.model.getId();
				j.name = o.model.getName();
				o.joint = j;
				continue;
			} else {
				var hasJoint = false;
				for( c in o.childs )
					if( c.isJoint ) {
						hasJoint = true;
						break;
					}
				if( hasJoint )
					o.obj = new h3d.scene.Skin(null);
				else
					o.obj = new h3d.scene.Object();
			}
			o.obj.name = name;
			var m = getDefaultMatrixes(o.model);
			if( m.trans != null || m.rotate != null || m.scale != null || m.preRot != null )
				o.obj.defaultTransform = m.toMatrix(leftHand);
		}
		// rebuild scene hierarchy
		for( o in objects ) {
			if( o.isJoint ) {
				if( o.parent.isJoint ) {
					o.joint.parent = o.parent.joint;
					o.parent.joint.subs.push(o.joint);
				}
			} else {
				// put it into the first non-joint parent
				var p = o.parent;
				while( p.obj == null )
					p = p.parent;
				p.obj.addChild(o.obj);
			}
		}
		// build skins
		for( o in objects ) {
			if( o.isJoint ) continue;


			// /!\ currently, childs of joints will work but will not cloned
			if( o.parent.isJoint )
				o.obj.follow = scene.getObjectByName(o.parent.joint.name);

			var skin = Std.instance(o.obj, h3d.scene.Skin);
			if( skin == null ) continue;
			var rootJoints = [];
			for( j in o.childs )
				if( j.isJoint )
					rootJoints.push(j.joint);
			var skinData = createSkin(hskins, hgeom, rootJoints, bonesPerVertex);
			// remove the corresponding Geometry-Model and copy its material
			for( o2 in objects ) {
				if( o2.obj == null || o2 == o || !o2.obj.isMesh() ) continue;
				var m = o2.obj.toMesh();
				if( m.primitive != skinData.primitive ) continue;

				var mt = Std.instance(m, h3d.scene.MultiMaterial);
				skin.materials = mt == null ? [m.material] : mt.materials;
				skin.material = skin.materials[0];
				m.remove();
				// ignore key frames for this object
				defaultModelMatrixes.get(m.name).wasRemoved = o.model.getId();
			}
			// set skin after materials
			if( skinData.boundJoints.length > maxBonesPerSkin ) {
				var model = Std.instance(skinData.primitive, h3d.prim.FBXModel);
				var idx = model.geom.getIndexes();
				skinData.split(maxBonesPerSkin, [for( i in idx.idx) idx.vidx[i]], model.multiMaterial ? model.getMaterialByTriangle() : null);
			}
			skin.setSkinData(skinData);
		}

		return scene.numChildren == 1 ? scene.getChildAt(0) : scene;
	}

}