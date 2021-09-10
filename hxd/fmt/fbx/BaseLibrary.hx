package hxd.fmt.fbx;
import haxe.io.Bytes;
using hxd.fmt.fbx.Data;
import h3d.col.Point;

#if (haxe_ver < 4)
import haxe.xml.Fast in Access;
#else
import haxe.xml.Access;
#end

class TmpObject {
	public var index : Int;
	public var model : FbxNode;
	public var parent : TmpObject;
	public var isJoint : Bool;
	public var isMesh : Bool;
	public var childs : Array<TmpObject>;
	#if !(dataOnly || macro)
	public var obj : h3d.scene.Object;
	#end
	public var joint : h3d.anim.Skin.Joint;
	public var skin : TmpObject;
	public function new() {
		childs = [];
	}
}

private class AnimCurve {
	public var def : DefaultMatrixes;
	public var object : String;
	public var t : { t : Array<Float>, x : Array<Float>, y : Array<Float>, z : Array<Float> };
	public var r : { t : Array<Float>, x : Array<Float>, y : Array<Float>, z : Array<Float> };
	public var s : { t : Array<Float>, x : Array<Float>, y : Array<Float>, z : Array<Float> };
	public var a : { t : Array<Float>, v : Array<Float> };
	public var fov : { t : Array<Float>, v : Array<Float> };
	public var roll : { t : Array<Float>, v : Array<Float> };
	public var uv : Array<{ t : Float, u : Float, v : Float }>;
	public function new(def, object) {
		this.def = def;
		this.object = object;
	}
}

class DefaultMatrixes {
	public var trans : Null<Point>;
	public var scale : Null<Point>;
	public var rotate : Null<Point>;
	public var preRot : Null<Point>;
	public var wasRemoved : Null<Int>;

	public var transPos : h3d.Matrix;

	public function new() {
	}

	public static inline function rightHandToLeft( m : h3d.Matrix ) {
		// if [x,y,z] is our original point and M the matrix
		// in right hand we have [x,y,z] * M = [x',y',z']
		// we need to ensure that left hand matrix convey the x axis flip,
		// in order to have [-x,y,z] * M = [-x',y',z']
		m._12 = -m._12;
		m._13 = -m._13;
		m._21 = -m._21;
		m._31 = -m._31;
		m._41 = -m._41;
	}

	public function toMatrix(leftHand) {
		var m = new h3d.Matrix();
		m.identity();
		if( scale != null ) m.scale(scale.x, scale.y, scale.z);
		if( rotate != null ) m.rotate(rotate.x, rotate.y, rotate.z);
		if( preRot != null ) m.rotate(preRot.x, preRot.y, preRot.z);
		if( trans != null ) m.translate(trans.x, trans.y, trans.z);
		if( leftHand ) rightHandToLeft(m);
		return m;
	}

	public function toQuaternion(leftHand) {
		var m = new h3d.Matrix();
		m.identity();
		if( rotate != null ) m.rotate(rotate.x, rotate.y, rotate.z);
		if( preRot != null ) m.rotate(preRot.x, preRot.y, preRot.z);
		if( leftHand ) rightHandToLeft(m);
		var q = new h3d.Quat();
		q.initRotateMatrix(m);
		return q;
	}

}

class BaseLibrary {

	var root : FbxNode;
	var ids : Map<Int,FbxNode>;
	var connect : Map<Int,Array<Int>>;
	var namedConnect : Map<Int,Map<String,Int>>;
	var invConnect : Map<Int,Array<Int>>;
	var leftHand : Bool;
	var defaultModelMatrixes : Map<Int,DefaultMatrixes>;
	var uvAnims : Map<String, Array<{ t : Float, u : Float, v : Float }>>;
	var animationEvents : Array<{ frame : Int, data : String }>;
	var isMaya : Bool;

	public var fileName : String;

	/**
		The FBX version that was decoded
	**/
	public var version : Float = 0.;

	/**
		Allows to prevent some terminal unskinned joints to be removed, for instance if we want to track their position
	**/
	public var keepJoints : Map<String,Bool>;

	/**
		Allows to skip some objects from being processed as if they were not part of the FBX
	**/
	public var skipObjects : Map<String,Bool>;

	/**
		Use 4 bones of influence per vertex instead of 3
	**/
	public var fourBonesByVertex = false;

	/**
		If there are too many bones, the model will be split in separate render passes.
	**/
	public var maxBonesPerSkin = 34;

	/**
		Consider unskinned joints to be simple objects
	**/
	public var unskinnedJointsAsObjects : Bool;

	public var allowVertexColor : Bool = true;

	/**
		Convert centimeters to meters and axis to Z-up (Maya FBX export)
	**/
	public var normalizeScaleOrient : Bool = true;

	/**
		Keep high precision values. Might increase animation data size and compressed size.
	**/
	public var highPrecision : Bool = false;

	public function new( fileName ) {
		this.fileName = fileName;
		root = { name : "Root", props : [], childs : [] };
		keepJoints = new Map();
		skipObjects = new Map();
		reset();
	}

	function reset() {
		ids = new Map();
		connect = new Map();
		namedConnect = new Map();
		invConnect = new Map();
		defaultModelMatrixes = new Map();
	}

	public function loadFile( data : Bytes ) {
		load(Parser.parse(data));
	}

	public function load( root : FbxNode ) {
		reset();
		this.root = root;

		version = root.get("FBXHeaderExtension.FBXVersion").props[0].toInt() / 1000;
		if( Std.int(version) != 7 )
			throw "FBX Version 7.x required : use FBX 2010 export";

		for( p in root.getAll("FBXHeaderExtension.SceneInfo.Properties70.P") )
			if( p.props[0].toString() == "Original|ApplicationName" ) {
				isMaya = p.props[4].toString().toLowerCase().indexOf("maya") >= 0;
				break;
			}

		for( c in root.childs )
			init(c);

		if( normalizeScaleOrient )
			updateModelScale();

		// init properties
		for( m in getAllModels() ) {
			for( p in m.getAll("Properties70.P") )
				switch( p.props[0].toString() ) {
				case "UDP3DSMAX" | "Events":
					var userProps = p.props[4].toString().split("&cr;&lf;");
					for( p in userProps ) {
						var pl = p.split("=");
						var pname = StringTools.trim(pl.shift());
						var pval = StringTools.trim(pl.join("="));
						switch( pname ) {
						case "UV" if( pval != "" ):
							var xml = try Xml.parse(pval) catch( e : Dynamic ) throw "Invalid UV data in " + m.getName();
							var frames = [for( f in new Access(xml.firstElement()).elements ) { var f = f.innerData.split(" ");  { t : Std.parseFloat(f[0]) * 9622116.25, u : Std.parseFloat(f[1]), v : Std.parseFloat(f[2]) }} ];
							if( uvAnims == null ) uvAnims = new Map();
							uvAnims.set(m.getName(), frames);
						case "Events":
							var xml = try Xml.parse(pval) catch( e : Dynamic ) throw "Invalid Events data in " + m.getName();
							animationEvents = [for( f in new Access(xml.firstElement()).elements ) { var f = f.innerData.split(" ");  { frame : Std.parseInt(f.shift()), data : StringTools.trim(f.join(" ")) }} ];
						default:
						}
					}
				default:
				}
		}
	}

	function toFloats( n : FbxNode ) {
		return switch( n.props[0] ) {
		case PInts(vl):
			var vl = [for( v in vl ) (v:Float)];
			n.props[0] = PFloats(vl);
			vl;
		case PFloats(vl):
			vl;
		default:
			throw n.props[0]+" should be floats ";
		}
	}

	function getAllModels() {
		return this.root.getAll("Objects.Model");
	}

	function getRootModels() {
		return [for( m in getAllModels() ) if( isRootModel(m) ) m];
	}

	function isRootModel( m ) {
		return getParent(m,"Model",true) == null;
	}

	function updateModelScale() {
		var unitScale = 1;
		var originScale = 1;
		var upAxis = 1;
		var originalUpAxis = 2;
		for( p in root.getAll("GlobalSettings.Properties70.P") ) {
			switch( p.props[0].toString() ) {
			case "UnitScaleFactor": unitScale = p.props[4].toInt();
			case "OriginalUnitScaleFactor": originScale = p.props[4].toInt();
			case "UpAxis": upAxis = p.props[4].toInt();
			case "OriginalUpAxis": originalUpAxis = p.props[4].toInt();
			default:
			}
		}
		var scaleFactor : Float = unitScale == 100 && originScale == 1 ? 100 : 1;
		var geometryScaleFactor = scaleFactor;

		if( upAxis == 1 ) // Y-up
			convertYupToZup(originalUpAxis);

		var app = "";
		for( p in root.getAll("FBXHeaderExtension.SceneInfo.Properties70.P") )
			switch( p.props[0].toString() ) {
			case "LastSaved|ApplicationName": app = p.props[4].toString();
			default:
			}
		if( app.indexOf("Blender") >= 0 && unitScale == originScale )
			scaleFactor = unitScale / 100; // Adjust blender output scaling

		if( scaleFactor == 1 && geometryScaleFactor == 1 )
			return;

		// scale on geometry
		if( geometryScaleFactor != 1 ) {
			for( g in this.root.getAll("Objects.Geometry.Vertices") ) {
				var v = toFloats(g);
				for( i in 0...v.length )
					v[i] = v[i] / geometryScaleFactor;
			}
		}

		if( scaleFactor == 1 )
			return;

		// scale on root models
		for( m in getAllModels() ) {
			var isRoot = isRootModel(m);
			for( p in m.getAll("Properties70.P") )
				switch( p.props[0].toString() ) {
				case "Lcl Scaling" if( isRoot ):
					for( idx in [4,5,6] ) {
						var v = p.props[idx].toFloat();
						p.props[idx] = PFloat(v * scaleFactor);
					}
				case "Lcl Translation", "GeometricTranslation" if( !isRoot ):
					for( idx in [4,5,6] ) {
						var v = p.props[idx].toFloat();
						p.props[idx] = PFloat(v / scaleFactor);
					}
				default:
				}
		}
		// scale on skin
		for( t in this.root.getAll("Objects.Deformer.Transform") ) {
			var m = toFloats(t);
			m[12] /= scaleFactor;
			m[13] /= scaleFactor;
			m[14] /= scaleFactor;
		}
		// scale on animation
		for( n in this.root.getAll("Objects.AnimationCurveNode") ) {
			var name = n.getName();
			var model = getParent(n,"Model",true);
			var isRoot = model != null && getParent(model,"Model",true) == null;
			for( p in n.getAll("Properties70.P") )
				switch( p.props[0].toString() ) {
				case "d|X", "d|Y", "d|Z" if( name == "T" && !isRoot ): p.props[4] = PFloat(p.props[4].toFloat() / scaleFactor);
				case "d|X", "d|Y", "d|Z" if( name == "S" && isRoot ): p.props[4] = PFloat(p.props[4].toFloat() * scaleFactor);
				default:
				}
			for( c in getChilds(n,"AnimationCurve") ) {
				var vl = toFloats(c.get("KeyValueFloat"));
				switch( name ) {
				case "T" if( !isRoot ):
					for( i in 0...vl.length )
						vl[i] = vl[i] / scaleFactor;
				case "S" if( isRoot ):
					for( i in 0...vl.length )
						vl[i] = vl[i] * scaleFactor;
				default:
				}
			}
		}
	}

	function convertYupToZup( originalUpAxis : Int ) {
		switch( originalUpAxis ) {
			case 2: // Original Axis Z - Maya & 3DS Max
				for( rootObject in getRootModels() ) {
					var props = rootObject.get("Properties70");
					for( c in props.childs ) {
						if( c.props[0].toString() == "PreRotation" && c.props[4].toFloat() == -90 && c.props[5].toFloat()== 0 && c.props[6].toFloat() == 0 ) {
							props.childs.remove(c);
							break;
						}
					}
				}
			case -1, 1: // Original Axis -Y or Y - Blender & Maya
				for( m in getRootModels() ) {
					var needPreRot = true;
					for( c in root.getAll("GlobalSettings.Properties70.P") ) {
						if( c.props[0].toString() == "PreRotation" && c.props[4].toFloat() == 90 && c.props[5].toFloat()== 0 && c.props[6].toFloat() == 0 ) {
							needPreRot = false;
							break;
						}
					}
					if( needPreRot ) {
						var preRotProp : FbxNode = {name : "P", props : [PString("PreRotation"), PString("Vector3D"), PString("Vector"), PString(""), PFloat(90),PFloat(0),PFloat(0)], childs : []};
						m.get("Properties70").childs.insert(0, preRotProp);
					}
				}
			default:
				throw "From Y-up to Z-up with orginalUpAxis = " + originalUpAxis + " not implemented.";
		}
	}

	function convertPoints( a : Array<Float> ) {
		var p = 0;
		for( i in 0...Std.int(a.length / 3) ) {
			a[p] = -a[p]; // inverse X axis
			p += 3;
		}
	}

	public function leftHandConvert() {
		if( leftHand ) return;
		leftHand = true;
		for( g in root.getAll("Objects.Geometry") ) {
			for( v in g.getAll("Vertices") )
				convertPoints(v.getFloats());
			for( v in g.getAll("LayerElementNormal.Normals") )
				convertPoints(v.getFloats());
			for( v in g.getAll("LayerElementTangent.Tangents") )
				convertPoints(v.getFloats());
			for( v in g.getAll("LayerElementBinormal.Binormals") )
				convertPoints(v.getFloats());
		}
	}

	function init( n : FbxNode ) {
		switch( n.name ) {
		case "Connections":
			for( c in n.childs ) {
				if( c.name != "C" )
					continue;
				var child = c.props[1].toInt();
				var parent = c.props[2].toInt();

				// Maya exports invalid references
				if( ids.get(child) == null || ids.get(parent) == null ) continue;

				var name = c.props[3];

				if( name != null ) {
					var name = name.toString();
					var nc = namedConnect.get(parent);
					if( nc == null ) {
						nc = new Map();
						namedConnect.set(parent, nc);
					}
					nc.set(name, child);
					// don't register as a parent, since the target can also be the child of something else
					if( name == "LookAtProperty" ) continue;
				}

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
			throw node.getName() + " has " + p.length + " " + nodeName + " parents "+[for( o in p ) o.getName()].join(",");
		if( p.length == 0 && !opt )
			throw "Missing " + node.getName() + " " + nodeName + " parent";
		return p[0];
	}

	public function getChild( node : FbxNode, nodeName : String, ?opt : Bool ) {
		var c = getChilds(node, nodeName);
		if( c.length > 1 )
			throw node.getName() + " has " + c.length + " " + nodeName + " childs "+[for( o in c ) o.getName()].join(",");
		if( c.length == 0 && !opt )
			throw "Missing " + node.getName() + " " + nodeName + " child";
		return c[0];
	}

	public function getSpecChild( node : FbxNode, name : String ) {
		var nc = namedConnect.get(node.getId());
		if( nc == null )
			return null;
		var id = nc.get(name);
		if( id == null )
			return null;
		return ids.get(id);
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

	function ignoreMissingObject( id : Int ) {
		var def = defaultModelMatrixes.get(id);
		if( def == null ) {
			def = new DefaultMatrixes();
			def.wasRemoved = -2;
			defaultModelMatrixes.set(id, def);
		}
	}

	function buildHierarchy() {
		// init objects
		var oroot = new TmpObject();
		var objects = new Array<TmpObject>();
		var hobjects = new Map<Int, TmpObject>();

		hobjects.set(0, oroot);
		for( model in getAllModels() ) {
			if( skipObjects.get(model.getName()) )
				continue;
			var mtype = model.getType();
			var isJoint = mtype == "LimbNode" && (!unskinnedJointsAsObjects || !isNullJoint(model));
			var o = new TmpObject();
			o.model = model;
			o.isJoint = isJoint;
			o.isMesh = mtype == "Mesh";
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

		inline function getDepth( o : TmpObject ) {
			var k = 0;
			while( o != oroot ) {
				o = o.parent;
				k++;
			}
			return k;
		}

		// look for common skin ancestor
		for( o in objects ) {
			if( !o.isMesh ) continue;
			var g = getChild(o.model, "Geometry");
			var def = getChild(g, "Deformer", true);
			if( def == null ) continue;
			var bones = [for( d in getChilds(def, "Deformer") ) hobjects.get(getChild(d, "Model").getId())];
			if( bones.length == 0 ) continue;


			// first let's go the minimal depth for all bones
			var minDepth = getDepth(bones[0]);
			for( i in 1...bones.length ) {
				var d = getDepth(bones[i]);
				if( d < minDepth ) minDepth = d;
			}
			var out = [];
			for( i in 0...bones.length ) {
				var b = bones[i];
				var n = getDepth(b) - minDepth;
				for( i in 0...n ) {
					b.isJoint = true;
					b = b.parent;
				}
				out.remove(b);
				out.push(b);
			}
			bones = out;

			while( bones.length > 1 ) {
				for( b in bones )
					b.isJoint = true;
				var parents = [];
				for( b in bones ) {
					if( b.parent == oroot || b.parent.isMesh ) continue;
					parents.remove(b.parent);
					parents.push(b.parent);
				}
				bones = parents;
			}
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
		return { root : oroot, objects : objects };
	}

	function getObjectCurve( curves : Map < Int, AnimCurve > , model : FbxNode, curveName : String, animName : String ) : AnimCurve {
		var c = curves.get(model.getId());
		if( c != null )
			return c;
		var name = model.getName();
		if( skipObjects.get(name) )
			return null;
		var def = getDefaultMatrixes(model);
		if( def == null )
			return null;
		// if it's a move animation on a terminal unskinned joint, let's skip it
		var isMove = curveName != "Visibility" && curveName != "UV";
		if( def.wasRemoved != null && (isMove || def.wasRemoved == -1) )
			return null;
		// allow not move animations on root model
		if( def.wasRemoved != null && def.wasRemoved != -2 ) {
			// apply it on the skin instead
			model = ids.get(def.wasRemoved);
			name = model.getName();
			c = curves.get(def.wasRemoved);
			def = getDefaultMatrixes(model);
			// todo : change behavior not to remove the mesh but the skin instead!
			if( def == null ) throw "assert";
		}
		if( c == null ) {
			c = new AnimCurve(def, name);
			curves.set(model.getId(), c);
		}
		return c;
	}


	public function mergeModels( modelNames : Array<String> ) {
		if( modelNames.length <= 1 )
			return;
		var models = getAllModels();
		function getModel(name) {
			for( m in models )
				if( m.getName() == name )
					return m;
			throw "Model not found " + name;
			return null;
		}
		var m = getModel(modelNames[0]);
		var geom = new Geometry(this, getChild(m, "Geometry"));
		var def = getChild(geom.getRoot(), "Deformer", true);
		var subDefs = getChilds(def, "Deformer");
		for( i in 1...modelNames.length ) {
			var name = modelNames[i];
			var m2 = getModel(name);
			var geom2 = new Geometry(this, getChild(m2, "Geometry"));
			var vcount = Std.int(geom.getVertices().length / 3);

			skipObjects.set(name, true);

			// merge materials
			var mindex = [];
			var materials = getChilds(m, "Material");
			for( mat in getChilds(m2, "Material") ) {
				var idx = materials.indexOf(mat);
				if( idx < 0 ) {
					idx = materials.length;
					materials.push(mat);
					addLink(m, mat);
				}
				mindex.push(idx);
			}

			// merge geometry
			geom.merge(geom2, mindex);

			// merge skinning
			var def2 = getChild(geom2.getRoot(), "Deformer", true);
			if( def2 != null ) {
				if( def == null ) throw m.getName() + " does not have a deformer but " + name + " has one";
				for( subDef in getChilds(def2, "Deformer") ) {
					var subModel = getChild(subDef, "Model");
					var prevDef = null;
					for( s in subDefs )
						if( getChild(s, "Model") == subModel ) {
							prevDef = s;
							break;
						}

					if( prevDef != null )
						removeLink(subDef, subModel);

					var idx = subDef.get("Indexes", true);
					if( idx == null ) continue;

					if( prevDef == null ) {
						addLink(def, subDef);
						removeLink(def2, subDef);
						subDefs.push(subDef);
						var idx = idx.getInts();
						for( i in 0...idx.length )
							idx[i] += vcount;
					} else {
						var pidx = prevDef.get("Indexes").getInts();
						for( i in idx.getInts() )
							pidx.push(i + vcount);
						var weights = prevDef.get("Weights").getFloats();
						for( w in subDef.get("Weights").getFloats() )
							weights.push(w);
					}
				}
			}
		}
	}

	function addLink( parent : FbxNode, child : FbxNode ) {
		var pid = parent.getId();
		var nid = child.getId();
		connect.get(pid).push(nid);
		invConnect.get(nid).push(pid);
	}

	function removeLink( parent : FbxNode, child : FbxNode ) {
		var pid = parent.getId();
		var nid = child.getId();
		connect.get(pid).remove(nid);
		invConnect.get(nid).remove(pid);
	}

	function checkData( t : { x : Array<Float>, y :Array<Float>, z:Array<Float> } ) {
		if( t == null )
			return true;
		if( t.x != null ) {
			var v = t.x[0];
			for( v2 in t.x )
				if( v != v2 )
					return false;
		}
		if( t.y != null ) {
			var v = t.y[0];
			for( v2 in t.y )
				if( v != v2 )
					return false;
		}
		if( t.z != null ) {
			var v = t.z[0];
			for( v2 in t.z )
				if( v != v2 )
					return false;
		}
		return true;
	}

	function roundValues( data : Array<Float>, def : Float, mult : Float = 1. ) {
		var hasValue = false;
		var epsi = highPrecision ? 0 : 1e-3;
		for( i in 0...data.length ) {
			var v = data[i] * mult;
			if( Math.abs(v - def) > epsi )
				hasValue = true;
			else
				v = def;
			data[i] = round(v);
		}
		return hasValue;
	}

	/**
		Returns an array of names with all animations present in FBX file.
	**/
	public function getAnimationNames() : Array<String> {
		var names = [];
		for ( a in this.root.getAll("Objects.AnimationStack") ) {
			if( getChilds(a, "AnimationLayer").length > 0 )
				names.push(a.getName());
		}
		return names;
	}

	public function loadAnimation( ?animName : String, ?root : FbxNode, ?lib : BaseLibrary ) : h3d.anim.Animation {
		if( lib != null ) {
			lib.defaultModelMatrixes = defaultModelMatrixes;
			return lib.loadAnimation(animName);
		}
		if( root != null ) {
			var l = new BaseLibrary(fileName);
			l.normalizeScaleOrient = normalizeScaleOrient;
			l.load(root);
			if( leftHand ) l.leftHandConvert();
			l.defaultModelMatrixes = defaultModelMatrixes;
			return l.loadAnimation(animName);
		}
		var defNode = null;
		var animNodes = [];
		for( a in this.root.getAll("Objects.AnimationStack") )
			if( animName == null || a.getName()	== animName ) {
				for( n in getChilds(a, "AnimationLayer") ) {
					defNode = n;
					if( getChilds(n,"AnimationCurveNode").length > 0 )
						animNodes.push(n);
				}
			}
		var animNode = switch( animNodes.length ) {
		case 0:
			defNode;
		case 1:
			animNodes[0];
		default:
			trace("Multiple animation layers curves are currently not supported");
			animNodes[0];
		}

		if( animNode == null ) {
			if( animName != null )
				throw "Animation not found " + animName;
			if( uvAnims == null )
				return null;
		}

		if( animName == null ) animName = getParent(animNode,"AnimationStack").getName();

		var curves = new Map();
		var P0 = new Point();
		var P1 = new Point(1, 1, 1);
		var F = Math.PI / 180;
		var allTimes = new Map();

		if( animNode != null ) for( cn in getChilds(animNode, "AnimationCurveNode") ) {
			var model = getParent(cn, "Model", true);
			if( model == null ) {
				switch( cn.getName() ) {
				case "Roll", "FieldOfView":
					// the parent is not a Model but a NodeAttribute
					var nattr = getParent(cn, "NodeAttribute", true);
					model = nattr == null ? null : getParent(nattr, "Model", true);
					if( model == null ) continue;
				default:
					continue; //morph support
				}
			}

			var c = getObjectCurve(curves, model, cn.getName(), animName);
			if( c == null )
				continue;

			var dataCurves = getChilds(cn, "AnimationCurve");
			if( dataCurves.length == 0 ) continue;

			var cname = cn.getName();
			// collect all the timestamps
			var times = dataCurves[0].get("KeyTime").getFloats();
			for( i in 0...times.length ) {
				var t = times[i];
				// fix rounding error
				if( t % 100 != 0 ) {
					t += 100 - (t % 100);
					times[i] = t;
				}
				// this should give significant-enough key
				var it = Std.int(t / 200000);
				allTimes.set(it, t);
			}

			// handle special curves
			if( dataCurves.length != 3 ) {
				var values = dataCurves[0].get("KeyValueFloat").getFloats();
				switch( cname ) {
				case "Visibility":
					if( !roundValues(values, 1) )
						continue;
					c.a = {
						v : values,
						t : times,
					};
					continue;
				case "Roll":
					if( !roundValues(values, 0) )
						continue;
					c.roll = {
						v : values,
						t : times,
					};
					continue;
				case "FieldOfView":
					var ratio = 16/9, fov = 45.;
					for( p in getChild(model, "NodeAttribute").getAll("Properties70.P") ) {
						switch( p.props[0].toString() ) {
						case "FilmAspectRatio": ratio = p.props[4].toFloat();
						case "FieldOfView": fov = p.props[4].toFloat();
						default:
						}
					}
					inline function fovXtoY(v:Float) {
						return 2 * Math.atan( Math.tan(v * 0.5 * Math.PI / 180) / ratio ) * 180 / Math.PI;
					}
					for( i in 0...values.length )
						values[i] = fovXtoY(values[i]);
					if( !roundValues(values, fovXtoY(fov)) )
						continue;
					c.fov = {
						v : values,
						t : times,
					};
					continue;
				default:
				}
			}
			// handle TRS curves
			var data = {
				x : null,
				y : null,
				z : null,
				t : times,
			};

			var curves = namedConnect.get(cn.getId());
			for( cname in curves.keys() ) {
				var values = ids.get(curves.get(cname)).get("KeyValueFloat").getFloats();
				switch( cname ) {
				case "d|X": data.x = values;
				case "d|Y": data.y = values;
				case "d|Z": data.z = values;
				default:
					trace("Unsupported key name "+cname);
				}
			}

			// this can happen when resampling anims due to rounding errors, let's ignore it for now
			//if( data.y.length != times.length || data.z.length != times.length )
			//	throw "Unsynchronized curve components on " + model.getName()+"."+cname+" (" + data.x.length + "/" + data.y.length + "/" + data.z.length + ")";
			// optimize empty animations out
			var M = 1.0;
			var def = switch( cname ) {
			case "T":
				if( c.def.trans == null ) P0 else c.def.trans;
			case "R":
				M = F;
				if( c.def.rotate == null && c.def.preRot == null ) P0 else
				if( c.def.rotate == null ) c.def.preRot else
				if( c.def.preRot == null ) c.def.rotate else
				{
					var q = new h3d.Quat(), q2 = new h3d.Quat();
					q2.initRotation(c.def.preRot.x, c.def.preRot.y, c.def.preRot.z);
					q.initRotation(c.def.rotate.x, c.def.rotate.y, c.def.rotate.z);
					q.multiply(q2,q);
					q.toEuler().toPoint();
				}
			case "S":
				if( c.def.scale == null ) P1 else c.def.scale;
			default:
				trace("Unknown curve " + model.getName()+"."+cname);
				continue;
			}
			var hasValue = false;
			if( data.x != null && roundValues(data.x, def.x, M) )
				hasValue = true;
			if( data.y != null && roundValues(data.y, def.y, M) )
				hasValue = true;
			if( data.z != null && roundValues(data.z, def.z, M) )
				hasValue = true;
			// no meaningful value found
			if( !hasValue )
				continue;
			var keyCount = 0;
			if( data.x != null ) keyCount = data.x.length;
			if( data.y != null ) keyCount = data.y.length;
			if( data.z != null ) keyCount = data.z.length;
			if( data.x == null ) data.x = [for( i in 0...keyCount ) def.x];
			if( data.y == null ) data.y = [for( i in 0...keyCount ) def.y];
			if( data.z == null ) data.z = [for( i in 0...keyCount ) def.z];
			switch( cname ) {
			case "T": c.t = data;
			case "R": c.r = data;
			case "S": c.s = data;
			default: throw "assert";
			}
		}

		// process UVs
		if( uvAnims != null ) {
			var modelByName = new Map();
			for( obj in getAllModels() )
				modelByName.set(obj.getName(), obj);
			for( obj in uvAnims.keys() ) {
				var frames = uvAnims.get(obj);
				var model = modelByName.get(obj);
				if( model == null ) throw "Missing model '" + obj + "' required by UV animation";
				var c = getObjectCurve(curves, model, "UV", animName);
				if( c == null ) continue;
				c.uv = frames;
				for( f in frames )
					allTimes.set(Std.int(f.t / 200000), f.t);
			}
		}

		var allTimes = [for( a in allTimes ) a];

		// no animation curve was found
		if( allTimes.length == 0 )
			return null;

		allTimes.sort(sortDistinctFloats);
		var maxTime = allTimes[allTimes.length - 1];
		var minDT = maxTime;
		var curT = allTimes[0];
		for( i in 1...allTimes.length ) {
			var t = allTimes[i];
			var dt = t - curT;
			if( dt < minDT ) minDT = dt;
			curT = t;
		}
		var numFrames = maxTime == 0 ? 1 : 1 + Std.int((maxTime - allTimes[0]) / minDT);
		var sampling = 15.0 / (minDT / 3079077200); // this is the DT value we get from Max when using 15 FPS export

		// if we have some holes in our timeline, pad them
		if( allTimes.length < numFrames ) {
			var t = allTimes[0];
			while( t < maxTime ) {
				if( allTimes.indexOf(t) < 0 )
					allTimes.push(t);
				t += minDT;
			}
			allTimes.sort(Reflect.compare);
			if( allTimes.length > numFrames ) throw 'Animation $animName($fileName) is not baked on a fixed framerate (detected ${Std.int(sampling)})';
			if( allTimes.length < numFrames ) throw "assert";
		}

		var anim = new h3d.anim.LinearAnimation(animName, numFrames, sampling);
		var q = new h3d.Quat(), q2 = new h3d.Quat();

		var sortedCurves = [for( c in curves ) c];
		function curveName(c) {
			return c.roll != null ? "roll" : c.fov != null ? "fov" : c.uv != null ? "uv" : "position";
		}
		sortedCurves.sort(function(c1, c2) {
			var r = Reflect.compare(c1.object, c2.object);
			if( r != 0 ) return r;
			return Reflect.compare(curveName(c1), curveName(c2));
		});
		for( c in sortedCurves ) {
			var numFrames = numFrames;
			var sameData = true;
			if( c.t == null && c.r == null && c.s == null && c.a == null && c.uv == null && c.roll == null && c.fov == null )
				numFrames = 1;
			else {
				if( sameData )
					sameData = checkData(c.t);
				if( sameData )
					sameData = checkData(c.r);
				if( sameData )
					sameData = checkData(c.s);
			}
			var frames = new haxe.ds.Vector(sameData ? 1 : numFrames);
			var alpha = c.a == null ? null : new haxe.ds.Vector(numFrames);
			var uvs = c.uv == null ? null : new haxe.ds.Vector(numFrames * 2);
			var roll = c.roll == null ? null : new haxe.ds.Vector(numFrames);
			var fov = c.fov == null ? null : new haxe.ds.Vector(numFrames);
			// skip empty curves
			if( frames == null && alpha == null && uvs == null && roll == null && fov == null )
				continue;
			var ctx = c.t == null ? null : c.t.x;
			var cty = c.t == null ? null : c.t.y;
			var ctz = c.t == null ? null : c.t.z;
			var ctt = c.t == null ? [-1.] : c.t.t;
			var crx = c.r == null ? null : c.r.x;
			var cry = c.r == null ? null : c.r.y;
			var crz = c.r == null ? null : c.r.z;
			var crt = c.r == null ? [-1.] : c.r.t;
			var csx = c.s == null ? null : c.s.x;
			var csy = c.s == null ? null : c.s.y;
			var csz = c.s == null ? null : c.s.z;
			var cst = c.s == null ? [ -1.] : c.s.t;
			var cav = c.a == null ? null : c.a.v;
			var cat = c.a == null ? null : c.a.t;
			var cuv = c.uv;
			var def = c.def;
			var tp = 0, rp = 0, sp = 0, ap = 0, uvp = 0, fovp = 0, rollp = 0;
			var curFrame = null;
			for( f in 0...numFrames ) {
				var changed = curFrame == null;
				if( allTimes[f] == ctt[tp] ) {
					changed = true;
					tp++;
				}
				if( allTimes[f] == crt[rp] ) {
					changed = true;
					rp++;
				}
				if( allTimes[f] == cst[sp] ) {
					changed = true;
					sp++;
				}
				if( changed ) {
					var f = new h3d.anim.LinearAnimation.LinearFrame();
					if( c.s == null || sp == 0 ) {
						if( def.scale != null ) {
							f.sx = def.scale.x;
							f.sy = def.scale.y;
							f.sz = def.scale.z;
						} else {
							f.sx = 1;
							f.sy = 1;
							f.sz = 1;
						}
					} else {
						f.sx = csx[sp - 1];
						f.sy = csy[sp - 1];
						f.sz = csz[sp - 1];
					}

					if( c.r == null || rp == 0 ) {
						if( def.rotate != null ) {
							q.initRotation(def.rotate.x, def.rotate.y, def.rotate.z);
						} else
							q.identity();
					} else
						q.initRotation(crx[rp-1], cry[rp-1], crz[rp-1]);

					if( def.preRot != null ) {
						q2.initRotation(def.preRot.x, def.preRot.y, def.preRot.z);
						q.multiply(q2,q);
					}

					f.qx = q.x;
					f.qy = q.y;
					f.qz = q.z;
					f.qw = q.w;

					if( c.t == null || tp == 0 ) {
						if( def.trans != null ) {
							f.tx = def.trans.x;
							f.ty = def.trans.y;
							f.tz = def.trans.z;
						} else {
							f.tx = 0;
							f.ty = 0;
							f.tz = 0;
						}
					} else {
						f.tx = ctx[tp - 1];
						f.ty = cty[tp - 1];
						f.tz = ctz[tp - 1];
					}

					if( leftHand ) {
						f.tx = -f.tx;
						f.qy = -f.qy;
						f.qz = -f.qz;
					}

					curFrame = f;
				}
				if( frames != null && f < frames.length )
					frames[f] = curFrame;
				if( alpha != null ) {
					if( allTimes[f] == cat[ap] )
						ap++;
					alpha[f] = cav[ap - 1];
				}
				if( uvs != null ) {
					if( uvp < cuv.length && allTimes[f] == cuv[uvp].t )
						uvp++;
					uvs[f<<1] = cuv[uvp - 1].u;
					uvs[(f<<1)|1] = cuv[uvp - 1].v;
				}
				if( roll != null ) {
					if( allTimes[f] == c.roll.t[rollp] )
						rollp++;
					roll[f] = c.roll.v[rollp - 1];
				}
				if( fov != null ) {
					if( allTimes[f] == c.fov.t[fovp] )
						fovp++;
					fov[f] = c.fov.v[fovp - 1];
				}
			}
			if( frames != null ) {
				var hasTrans = c.t != null;
				var hasRot = c.r != null || def.rotate != null || def.preRot != null;
				var hasScale = c.s != null || def.scale != null;
				// force position for objects unless it's default to skin
				if( !hasTrans && def.transPos == null )
					hasTrans = true;
				anim.addCurve(c.object, frames, hasTrans, hasRot, hasScale);
			}
			if( alpha != null )
				anim.addAlphaCurve(c.object, alpha);
			if( uvs != null )
				anim.addUVCurve(c.object, uvs);
			if( roll != null )
				anim.addPropCurve(c.object, "Roll", roll);
			if( fov != null )
				anim.addPropCurve(c.object, "FOVY", fov);
		}
		return anim;
	}

	function sortDistinctFloats( a : Float, b : Float ) {
		return if( a > b ) 1 else -1;
	}

	function isNullJoint( model : FbxNode ) {
		if( getParents(model, "Deformer").length > 0 )
			return false;
		var parent = getParent(model, "Model", true);
		if( parent == null )
			return true;
		var t = parent.getType();
		if( t == "LimbNode" || t == "Root" )
			return false;
		return true;
	}

	function getModelPath( model : FbxNode ) {
		var parent = getParent(model, "Model", true);
		var name = model.getName();
		if( parent == null )
			return name;
		return getModelPath(parent) + "." + name;
	}

	function autoMerge() {
		// if we have multiple deformers on the same joint, let's merge the geometries
		var toMerge = [], mergeGroups = new Map<Int,Array<FbxNode>>();
		for( model in getAllModels() ) {
			if( skipObjects.get(model.getName()) )
				continue;
			var mtype = model.getType();
			var isJoint = mtype == "LimbNode" && (!unskinnedJointsAsObjects || !isNullJoint(model));
			if( !isJoint ) continue;
			var deformers = getParents(model, "Deformer");
			if( deformers.length <= 1 ) continue;
			var group = [];
			for( d in deformers ) {
				var def = getParent(d, "Deformer");
				if( def == null ) continue;
				var geom = getParent(def, "Geometry");
				if( geom == null ) continue;
				var model2 = getParent(geom, "Model");
				if( model2 == null ) continue;

				var id = model2.getId();
				var g = mergeGroups.get(id);
				if( g != null ) {
					for( g in g ) {
						group.remove(g);
						group.push(g);
					}
					toMerge.remove(g);
				}
				group.remove(model2);
				group.push(model2);
				mergeGroups.set(id, group);
			}
			toMerge.push(group);
		}
		for( group in toMerge ) {
			group.sort(function(m1, m2) return Reflect.compare(m1.getName(), m2.getName()));
			for( g in toMerge )
				if( g != group ) {
					var found = false;
					for( m in group )
						if( g.remove(m) )
							found = true;
					if( found )
						g.push(group[0]);
				}
			mergeModels([for( g in group ) g.getName()]);
		}
	}

	function keepJoint( j : h3d.anim.Skin.Joint ) : Bool {
		return keepJoints.get(j.name);
	}

	function createSkin( hskins : Map<Int,h3d.anim.Skin>, hgeom : Map<Int,{
		function vertexCount():Int; function setSkin(s:h3d.anim.Skin):Void;
	}>, rootJoints : Array<h3d.anim.Skin.Joint> ) {
		var allJoints = [];
		function collectJoints(j:h3d.anim.Skin.Joint) {
			// collect subs first (allow easy removal of terminal unskinned joints)
			for( j in j.subs )
				collectJoints(cast j);
			allJoints.push(j);
		}
		for( j in rootJoints )
			collectJoints(j);
		var skin = null;
		var geomTrans = null;
		var iterJoints = allJoints.copy();
		for( j in iterJoints ) {
			var jModel = ids.get(j.index);
			var subDef = getParent(jModel, "Deformer", true);
			var defMat = defaultModelMatrixes.get(jModel.getId());
			j.defMat = defMat.toMatrix(leftHand);

			if( subDef == null ) {
				// if we have skinned subs, we need to keep in joint hierarchy
				if( j.subs.length > 0 || keepJoint(j) )
					continue;
				// otherwise we're an ending bone, we can safely be removed
				if( j.parent == null )
					rootJoints.remove(j);
				else
					j.parent.subs.remove(j);
				allJoints.remove(j);
				// ignore key frames for this joint
				defMat.wasRemoved = -1;
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
				skin = new h3d.anim.Skin(null, geom.vertexCount(), fourBonesByVertex ? 4 : 3);
				geom.setSkin(skin);
				hskins.set(def.getId(), skin);
			}
			j.transPos = defMat.transPos;

			var weights = subDef.getAll("Weights");
			if( weights.length > 0 ) {
				var weights = weights[0].getFloats();
				var vertex = subDef.get("Indexes").getInts();
				for( i in 0...vertex.length ) {
					var w = weights[i];
					if( w < 0.01 )
						continue;
					skin.addInfluence(vertex[i], j, w);
				}
			}
		}
		if( skin == null )
			throw "No joint is skinned ("+[for( j in iterJoints ) j.name].join(",")+")";
		allJoints.reverse();
		for( i in 0...allJoints.length )
			allJoints[i].index = i;
		skin.setJoints(allJoints, rootJoints);
		skin.initWeights();
		return skin;
	}

	function round(v:Float) {
		if( v != v ) throw "NaN found";
		return highPrecision ? v : std.Math.fround(v * 131072) / 131072;
	}

	function updateDefaultMatrix( model : FbxNode, d : DefaultMatrixes ) {
		// default matrix should be skinning position (not frame 0 objects position)
		var subDef = getParent(model, "Deformer", true);
		if( subDef == null )
			return; // exporting without model will not export Deformer :'(

		var transPos = h3d.Matrix.L(subDef.get("Transform").getFloats());
		if( leftHand ) DefaultMatrixes.rightHandToLeft(transPos);
		d.transPos = transPos;

		/*
			This code was meant to reconstruct the default matrix,
			not based on the first animation frame but based on the
			model bind pose.

			It seems works correctly although in Maya it does not seem
			possible to reconstruct exactly the bind pose rotation
			(have to set it to null manualy)

			However it is a bit complex and potentially error prone.
			It also gives slighly different results in terms of translation
			(between reconstructed bind pose and first animation frame)
			that forces some extra position data in animation because of the
			small delta.

			I prefer to disable for now, it could still be useful if having
			some animations with a constant translation that is only
			set on first animation frame - this will be removed from animation data
			instead of kept for overriding bind pose.
		*/

		/*
		var m = new h3d.Matrix();
		var parent = getParent(model, "Model", true);
		m.identity();
		while( parent != null ) {
			var mp = getDefaultMatrixes(parent);
			if( mp.transPos != null ) {
				var inv = new h3d.Matrix();
				inv.initInverse(mp.transPos);
				m.multiply(m, inv);
				break;
			}
			if( isMaya ) break;
			m.multiply(m, mp.toMatrix(leftHand));
			parent = getParent(parent, "Model", true);
		}
		m.multiply(m, transPos);
		m.invert();

		// we have  d.toMatrix(leftHand) == m  (in skin position only)
		// revert m to feed default matrix
		if( leftHand ) DefaultMatrixes.rightHandToLeft(m); // undo LH/RH transform

		var trans = m.getPosition().toPoint();
		var tlen = trans.length();
		var dist = d.trans == null ? tlen : d.trans.sub(trans).length();
		if( dist > 1e-2 )
			d.trans = tlen < 1e-3 ? null : trans;

		var q = new h3d.Quat();
		q.initRotateMatrix(m);

		var rot = q.toEuler().toPoint();
		if( hxd.Math.abs(rot.x) < 1e-4 ) rot.x = 0;
		if( hxd.Math.abs(rot.y) < 1e-4 ) rot.y = 0;
		if( hxd.Math.abs(rot.z) < 1e-4 ) rot.z = 0;

		var rlen = rot.length();
		var dist = d.rotate == null ? rlen : d.rotate.sub(rot).length();
		if( dist > 1e-3 )
			d.rotate = rlen < 1e-3 ? null : rot;
		if( isMaya )
			d.rotate = null;
		*/
	}

	function getDefaultMatrixes( model : FbxNode ) {
		var id = model.getId();
		var d = defaultModelMatrixes.get(id);
		if( d != null )
			return d;
		d = new DefaultMatrixes();
		var F = Math.PI / 180;
		for( p in model.getAll("Properties70.P") )
			switch( p.props[0].toString() ) {
			case "GeometricTranslation":
				// handle in Geometry directly
			case "PreRotation":
				d.preRot = new Point(round(p.props[4].toFloat() * F), round(p.props[5].toFloat() * F), round(p.props[6].toFloat() * F));
				if( d.preRot.x == 0 && d.preRot.y == 0 && d.preRot.z == 0 )
					d.preRot = null;
			case "Lcl Rotation":
				d.rotate = new Point(round(p.props[4].toFloat() * F), round(p.props[5].toFloat() * F), round(p.props[6].toFloat() * F));
				if( d.rotate.x == 0 && d.rotate.y == 0 && d.rotate.z == 0 )
					d.rotate = null;
			case "Lcl Translation":
				d.trans = new Point(round(p.props[4].toFloat()), round(p.props[5].toFloat()), round(p.props[6].toFloat()));
				if( d.trans.x == 0 && d.trans.y == 0 && d.trans.z == 0 )
					d.trans = null;
			case "Lcl Scaling":
				d.scale = new Point(round(p.props[4].toFloat()), round(p.props[5].toFloat()), round(p.props[6].toFloat()));
				if( d.scale.x == 1 && d.scale.y == 1 && d.scale.z == 1 )
					d.scale = null;
			default:
			}
		if( model.getType() == "LimbNode" )
			updateDefaultMatrix(model, d);

		defaultModelMatrixes.set(id, d);
		return d;
	}

}
