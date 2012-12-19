package h3d.fbx;
using h3d.fbx.Data;

class Library {

	var root : FbxNode;
	var ids : IntHash<FbxNode>;
	var connect : IntHash<Array<Int>>;
	var invConnect : IntHash<Array<Int>>;
	
	public function new() {
		root = { name : "Root", props : [], childs : [] };
		reset();
	}
	
	function reset() {
		ids = new IntHash();
		connect = new IntHash();
		invConnect = new IntHash();
	}
	
	public function loadTextFile( data : String ) {
		load(Parser.parse(data));
	}
	
	public function load( root : FbxNode ) {
		reset();
		this.root = root;
		for( c in root.childs )
			init(c);
	}
	
	function init( n : FbxNode ) {
		switch( n.name ) {
		case "Connections":
			for( c in n.childs ) {
				if( c.name != "C" )
					continue;
				var child = c.props[1].toInt();
				var parent = c.props[2].toInt();
				
				var c = connect.get(parent);
				if( c == null ) {
					c = [];
					connect.set(parent, c);
				}
				c.push(child);

				if( parent == 0 )
					continue;
								
				var c = invConnect.get(child);
				if( c == null ) {
					c = [];
					invConnect.set(child, c);
				}
				c.push(parent);
			}
		case "Objects":
			for( c in n.childs )
				ids.set(c.getId(), c);
		default:
		}
	}
	
	public function getGeometry( name : String = "" ) {
		var geom = null;
		for( g in root.getAll("Objects.Geometry") )
			if( g.hasProp(PString("Geometry::" + name)) ) {
				geom = g;
				break;
			}
		if( geom == null )
			throw "Geometry " + name + " not found";
		return new Geometry(this, geom);
	}

	public function getParent( node : FbxNode, nodeName : String, ?opt : Bool ) {
		var p = getParents(node, nodeName);
		if( p.length > 1 )
			throw node.getName() + " has " + p.length + " " + nodeName + " parents";
		if( p.length == 0 && !opt )
			throw "Missing " + node.getName() + " " + nodeName + " parent";
		return p[0];
	}

	public function getChild( node : FbxNode, nodeName : String, ?opt : Bool ) {
		var c = getChilds(node, nodeName);
		if( c.length > 1 )
			throw node.getName() + " has " + c.length + " " + nodeName + " childs";
		if( c.length == 0 && !opt )
			throw "Missing " + node.getName() + " " + nodeName + " child";
		return c[0];
	}
	
	public function getChilds( node : FbxNode, ?nodeName : String ) {
		var c = connect.get(node.getId());
		var subs = [];
		if( c != null )
			for( id in c ) {
				var n = ids.get(id);
				if( n == null ) throw id + " not found";
				if( nodeName != null && n.name != nodeName ) continue;
				subs.push(n);
			}
		return subs;
	}

	public function getParents( node : FbxNode, ?nodeName : String ) {
		var c = invConnect.get(node.getId());
		var pl = [];
		if( c != null )
			for( id in c ) {
				var n = ids.get(id);
				if( n == null ) throw id + " not found";
				if( nodeName != null && n.name != nodeName ) continue;
				pl.push(n);
			}
		return pl;
	}
	
	public function getRoot() {
		return root;
	}

	public function makeScene( ?textureLoader : String -> h3d.mat.Texture, ?bonesPerVertex = 3 ) : h3d.scene.Scene {
		var scene = new h3d.scene.Scene();
		var hobjects = new IntHash();
		var hgeom = new IntHash();
		var objects = new Array();
		var hjoints = new IntHash();
		var joints = new Array();
		var hskins = new IntHash();
		
		if( textureLoader == null ) {
			var tmpTex = null;
			textureLoader = function(_) {
				if( tmpTex == null ) {
					tmpTex = h3d.Engine.getCurrent().mem.allocTexture(1, 1);
					var bytes = haxe.io.Bytes.alloc(4);
					bytes.set(0, 0xFF);
					bytes.set(2, 0xFF);
					bytes.set(3, 0xFF);
					tmpTex.uploadBytes(bytes);
				}
				return tmpTex;
			}
		}
		// create all models
		for( model in root.getAll("Objects.Model") ) {
			var o : h3d.scene.Object;
			switch( model.getType() ) {
			case "Null":
				o = new h3d.scene.Object(scene);
			case "Root":
				o = new h3d.scene.Skin(null,null,scene);
			case "LimbNode":
				var j = new h3d.prim.Skin.Joint();
				var m = getMatrixes(model);
				if( m.t != null )
					j.defTrans = m.t;
				if( m.r != null )
					j.defRotate = m.r;
				if( m.s != null )
					j.defScale = m.s;
				if( m.preRot != null )
					throw "Invalid Joint Transform";
				j.index = model.getId();
				hjoints.set(j.index, j);
				joints.push({ model : model, joint : j });
				continue;
			case "Mesh":
				// load geometry
				var g = getChild(model, "Geometry");
				var prim = hgeom.get(g.getId());
				if( prim == null ) {
					prim = new h3d.prim.FBXModel(new Geometry(this, g));
					hgeom.set(g.getId(), prim);
				}
				// load material
				var mat = getChild(model, "Material");
				var tex = getChilds(mat, "Texture")[0];
				if( tex == null ) throw "No texture found for " + model.getName();
				var tex = textureLoader(tex.get("RelativeFilename").props[0].toString());
				o = new h3d.scene.Mesh(prim, new h3d.mat.MeshMaterial(tex), scene);
			case type:
				throw "Unknown model type " + type+" for "+model.getName();
			}
			o.name = model.getName().split("::")[1];
			var m = getMatrixes(model);
			if( m.t != null || m.r != null || m.s != null || m.preRot != null )
				o.defaultTransform = makeMatrix(m.t, m.r, m.s, m.preRot);
			hobjects.set(model.getId(), o);
			objects.push( { model : model, obj : o } );
		}
		// rebuild joints hierarchy
		for( j in joints ) {
			var p = getParent(j.model, "Model");
			var jparent = hjoints.get(p.getId());
			if( jparent != null ) {
				jparent.subs.push(j.joint);
				j.joint.parent = jparent;
			} else if( p.getType() != "Root" )
				throw "Parent joint not found " + p.getName();
		}
		// rebuild model hierarchy and additional inits
		for( o in objects ) {
			var rootJoints = [];
			for( sub in getChilds(o.model, "Model") ) {
				var sobj = hobjects.get(sub.getId());
				if( sobj == null ) {
					if( sub.getType() == "LimbNode" ) {
						var j = hjoints.get(sub.getId());
						if( j == null ) throw "Missing sub joint " + sub.getName();
						rootJoints.push(j);
						continue;
					}
					throw "Missing sub " + sub.getName();
				}
				o.obj.addChild(sobj);
			}
			if( rootJoints.length != 0 ) {
				if( o.model.getType() != "Root" )
					throw o.obj.name + ":" + o.model.getType() + " should be Root";
				var skin : h3d.scene.Skin = cast o.obj;
				var skinData = createSkin(hskins, hgeom, rootJoints, bonesPerVertex);
				skin.setSkinData(skinData);
				// if we have a skinned object, remove it (only keep the skin)
				for( o in objects ) {
					if( !o.obj.isMesh() ) continue;
					var m = o.obj.toMesh();
					if( m.primitive != skinData.primitive || m == skin )
						continue;
					var absPos = h3d.Matrix.I();
					var cur : h3d.scene.Object = m;
					while( cur != null ) {
						if( cur.defaultTransform != null )
							absPos.multiply(absPos, cur.defaultTransform);
						cur = cur.parent;
					}
					skin.material = m.material;
					scene.removeChild(m);
				}
			}
		}
		return scene;
	}
	
	function createSkin( hskins : IntHash<h3d.prim.Skin>, hgeom : IntHash<h3d.prim.FBXModel>, rootJoints : Array<h3d.prim.Skin.Joint>, bonesPerVertex ) {
		var allJoints = [];
		function collectJoints(j:h3d.prim.Skin.Joint) {
			// collect subs first (allow easy removal of terminal unskinned joints)
			for( j in j.subs )
				collectJoints(cast j);
			allJoints.push(j);
		}
		for( j in rootJoints )
			collectJoints(j);
		var skin = null;
		var geomTrans = null;
		for( j in allJoints.copy() ) {
			var subDef = getParent(ids.get(j.index), "Deformer", true);
			if( subDef == null ) {
				// if we have skinned subs, we need to keep in joint hierarchy
				if( j.subs.length > 0 )
					continue;
				// otherwise we're an ending bone, we can safely be removed
				if( j.parent == null )
					rootJoints.remove(j);
				else
					j.parent.subs.remove(j);
				allJoints.remove(j);
				continue;
			}
			// create skin
			if( skin == null ) {
				var def = getParent(subDef, "Deformer");
				skin = hskins.get(def.getId());
				// shared skin between same instances
				if( skin != null )
					return skin;
				var geom = hgeom.get(getParent(def, "Geometry").getId());
				skin = new h3d.prim.Skin(geom.getVerticesCount(), bonesPerVertex);
				geom.skin = skin;
				skin.primitive = geom;
				hskins.set(def.getId(), skin);
			}
			j.transPos = h3d.Matrix.L(subDef.get("Transform").getFloats());
			
			var weights = subDef.get("Weights").getFloats();
			var vertex = subDef.get("Indexes").getInts();
			for( i in 0...vertex.length ) {
				var w = weights[i];
				if( w < 0.01 )
					continue;
				skin.addInfluence(vertex[i], j, w);
			}
		}
		if( skin == null )
			throw "No joint is skinned";
		allJoints.reverse();
		for( i in 0...allJoints.length )
			allJoints[i].index = i;
		skin.rootJoints = rootJoints;
		skin.allJoints = allJoints;
		skin.initWeights();
		return skin;
	}
	
	function getMatrixes( model : FbxNode ) {
		var preRot = null, trans = null, rot = null, scale = null, geomTrans = null;
		var F = Math.PI / 180;
		for( p in model.getAll("Properties70.P") )
			switch( p.props[0].toString() ) {
			case "GeometricTranslation":
				// handle in Geometry directly
			case "PreRotation":
				preRot = new h3d.Point(p.props[4].toFloat() * F, p.props[5].toFloat() * F, p.props[6].toFloat() * F);
			case "Lcl Rotation":
				rot = new h3d.Point(p.props[4].toFloat() * F, p.props[5].toFloat() * F, p.props[6].toFloat() * F);
			case "Lcl Translation":
				trans = new h3d.Point(p.props[4].toFloat(), p.props[5].toFloat(), p.props[6].toFloat());
			case "Lcl Scaling":
				scale = new h3d.Point(p.props[4].toFloat(), p.props[5].toFloat(), p.props[6].toFloat());
			case "RotationActive", "InheritType", "ScalingMin", "MaxHandle", "DefaultAttributeIndex", "Show", "UDP3DSMAX":
			case "RotationMinX","RotationMinY","RotationMinZ","RotationMaxX","RotationMaxY","RotationMaxZ":
			default:
				#if debug
				trace(p.props[0].toString());
				#end
			}
		return { t : trans, r : rot, s : scale, preRot : preRot };
	}
	
	function getMatrix(model) {
		var m = getMatrixes(model);
		return makeMatrix(m.t, m.r, m.s, m.preRot);
	}

	function makeMatrix( trans : h3d.Point, rot : h3d.Point, scale : h3d.Point, ?preRot : h3d.Point ) {
		var m = new h3d.Matrix();
		m.identity();
		
		if( scale != null )
			m.scale(scale.x, scale.y, scale.z);
			
		if( rot != null )
			m.rotate(rot.x, rot.y, rot.z);

		if( preRot != null )
			m.rotate(preRot.x, preRot.y, preRot.z);
			
		if( trans != null )
			m.translate(trans.x,trans.y,trans.z);
		
		return m;
	}
	
}