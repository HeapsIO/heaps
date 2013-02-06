package h3d.fbx;
using h3d.fbx.Data;

class DefaultMatrixes {
	public var trans : Null<h3d.Point>;
	public var scale : Null<h3d.Point>;
	public var rotate : Null<h3d.Point>;
	public var preRot : Null<h3d.Point>;
	public var removedJoint : Bool;
	
	public function new() {
	}

	public static inline function rightHandToLeft( m : h3d.Matrix ) {
		// if [x,y,z] is our original point and M the matrix
		// in right hand we have [x,y,z] * M = [x',y',z']
		// we need to ensure that left hand matrix convey the x axis flip,
		// in order to have [-x,y,z] * M = [-x',y',z']
		m._12 *= -1;
		m._13 *= -1;
		m._21 *= -1;
		m._31 *= -1;
		m._41 *= -1;
	}
	
	public function toMatrix(leftHand) {
		var m = new h3d.Matrix();
		m.identity();
		if( scale != null ) m.scale(scale.x, scale.y, scale.z);
		if( rotate != null ) m.rotate(rotate.x, rotate.y, rotate.z);
		if( preRot != null ) m.rotate(preRot.x, preRot.y, preRot.z);
		if( trans != null ) m.translate(trans.x * (leftHand ? -1 : 1), trans.y, trans.z);
		if( leftHand ) rightHandToLeft(m);
		return m;
	}
	
}

class Library {

	var root : FbxNode;
	var ids : Map<Int,FbxNode>;
	var connect : Map<Int,Array<Int>>;
	var invConnect : Map<Int,Array<Int>>;
	var leftHand : Bool;
	
	var defaultModelMatrixes : Map<String,DefaultMatrixes>;
	
	public function new() {
		root = { name : "Root", props : [], childs : [] };
		reset();
	}
	
	function reset() {
		ids = new Map();
		connect = new Map();
		invConnect = new Map();
		defaultModelMatrixes = new Map();
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
	
	function convertPoints( a : Array<Float> ) {
		var p = 0;
		for( i in 0...Std.int(a.length / 3) ) {
			a[p] = -a[p];
			p++;
			a[p] = a[p];
			p++;
			a[p] = a[p];
			p++;
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
	
	public function loadAnimation( ?animName : String, ?root : FbxNode, ?lib : Library ) {
		if( lib != null ) {
			lib.defaultModelMatrixes = defaultModelMatrixes;
			return lib.loadAnimation(animName);
		}
		if( root != null ) {
			var l = new Library();
			l.load(root);
			if( leftHand ) l.leftHandConvert();
			l.defaultModelMatrixes = defaultModelMatrixes;
			return l.loadAnimation(animName);
		}
		var animNode = null;
		for( a in this.root.getAll("Objects.AnimationStack") )
			if( animName == null || a.getName()	== animName ) {
				if( animName == null )
					animName = a.getName();
				animNode = getChild(a, "AnimationLayer");
				break;
			}
		if( animNode == null )
			throw "Animation not found " + animName;

		var curves = new Map();
		var P0 = new h3d.Point();
		var P1 = new h3d.Point(1, 1, 1);
		var F = Math.PI / 180;
		var allTimes = new Map();
		for( cn in getChilds(animNode, "AnimationCurveNode") ) {
			var model = getParent(cn, "Model");
			var c = curves.get(model.getId());
			if( c == null ) {
				var name = model.getName();
				// if it's an empty model with no sub nodes, let's ignore it (ex : Camera)
				if( model.getType() == "Null" && getChilds(model, "Model").length == 0 )
					continue;
				var def = defaultModelMatrixes.get(name);
				if( def == null )
					throw "Default Matrixes not found for " + name + " in " + animName;
				// if it's an animation on a terminal unskinned joint, let's skip it
				if( def.removedJoint )
					continue;
				c = { def : def, t : null, r : null, s : null, a : null, name : name };
				curves.set(model.getId(), c);
			}
			var data = getChilds(cn, "AnimationCurve");
			var cname = cn.getName();
			// collect all the timestamps
			var times = data[0].get("KeyTime").getFloats();
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
			if( data.length != 3 ) {
				switch( cname ) {
				case "Visibility":
					c.a = {
						v : data[0].get("KeyValueFloat").getFloats(),
						t : times,
					};
					continue;
				default:
				}
				throw model.getName()+"."+cname + " has " + data.length + " curves";
			}
			// handle TRS curves
			var data = {
				x : data[0].get("KeyValueFloat").getFloats(),
				y : data[1].get("KeyValueFloat").getFloats(),
				z : data[2].get("KeyValueFloat").getFloats(),
				t : times,
			};
			// this can happen when resampling anims due to rounding errors, let's ignore it for now
			//if( data.y.length != times.length || data.z.length != times.length )
			//	throw "Unsynchronized curve components on " + model.getName()+"."+cname+" (" + data.x.length + "/" + data.y.length + "/" + data.z.length + ")";
			// optimize empty animations out
			var E = 1e-10, M = 1.0;
			var def = switch( cname ) {
			case "T": if( c.def.trans == null ) P0 else c.def.trans;
			case "R": M = F; if( c.def.rotate == null ) P0 else c.def.rotate;
			case "S": if( c.def.scale == null ) P1 else c.def.scale;
			default:
				throw "Unknown curve " + model.getName()+"."+cname;
			}
			var hasValue = false;
			for( v in data.x )
				if( v*M < def.x-E || v*M > def.x+E ) {
					hasValue = true;
					break;
				}
			if( !hasValue ) {
				for( v in data.y )
					if( v*M < def.y-E || v*M > def.y+E ) {
						hasValue = true;
						break;
					}
			}
			if( !hasValue ) {
				for( v in data.z )
					if( v*M < def.z-E || v*M > def.z+E ) {
						hasValue = true;
						break;
					}
			}
			// no meaningful value found
			if( !hasValue )
				continue;
			switch( cname ) {
			case "T": c.t = data;
			case "R": c.r = data;
			case "S": c.s = data;
			default: throw "assert";
			}
		}
		
		var allTimes = Lambda.array(allTimes);
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
		var numFrames = maxTime == 0 ? 1 : 1 + Std.int(maxTime / minDT);
		var anim = new h3d.prim.Animation(animName, numFrames);
		anim.sampling = 15.0 / (minDT / 3079077200); // this is the DT value we get from Max when using 15 FPS export
		
		for( c in curves ) {
			// skip empty curves
			if( c.t == null && c.r == null && c.s == null )
				continue;
			var frames = new flash.Vector(numFrames);
			var alpha = c.a == null ? null : new flash.Vector(numFrames);
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
			var def = c.def;
			var tp = 0, rp = 0, sp = 0, ap = 0;
			var curMat = null;
			for( f in 0...numFrames ) {
				var changed = false;
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
					var m = new h3d.Matrix();
					m.identity();
					if( c.s == null ) {
						if( def.scale != null )
							m.scale(def.scale.x, def.scale.y, def.scale.z);
					} else
						m.scale(csx[sp-1], csy[sp-1], csz[sp-1]);

					if( c.r == null ) {
						if( def.rotate != null )
							m.rotate(def.rotate.x, def.rotate.y, def.rotate.z);
					} else
						m.rotate(crx[rp-1] * F, cry[rp-1] * F, crz[rp-1] * F);
						
					if( def.preRot != null )
						m.rotate(def.preRot.x, def.preRot.y, def.preRot.z);

					if( c.t == null ) {
						if( def.trans != null )
							m.translate(def.trans.x, def.trans.y, def.trans.z);
					} else
						m.translate(ctx[tp-1], cty[tp-1], ctz[tp-1]);

					if( leftHand )
						DefaultMatrixes.rightHandToLeft(m);
						
					curMat = m;
				}
				frames[f] = curMat;
				if( alpha != null ) {
					if( allTimes[f] == cat[ap] )
						ap++;
					alpha[f] = cav[ap - 1];
				}
			}
			
			anim.addCurve(c.name, frames);
			if( alpha != null )
				anim.addAlphaCurve(c.name, alpha);
		}
		return anim;
	}
	
	function sortDistinctFloats( a : Float, b : Float ) {
		return if( a > b ) 1 else -1;
	}

	public function makeScene( ?textureLoader : String -> h3d.mat.MeshMaterial, ?bonesPerVertex = 3 ) : h3d.scene.Scene {
		var scene = new h3d.scene.Scene();
		var hobjects = new Map();
		var hgeom = new Map();
		var objects = new Array();
		var hjoints = new Map();
		var joints = new Array();
		var hskins = new Map();
		
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
				return new h3d.mat.MeshMaterial(tmpTex);
			}
		}
		// create all models
		for( model in root.getAll("Objects.Model") ) {
			var o : h3d.scene.Object;
			switch( model.getType() ) {
			case "Null", "Root", "Camera":
				var hasJoint = false;
				for( c in getChilds(model, "Model") )
					if( c.getType() == "LimbNode" ) {
						hasJoint = true;
						break;
					}
				if( hasJoint )
					o = new h3d.scene.Skin(null, null, scene);
				else
					o = new h3d.scene.Object(scene);
			case "LimbNode":
				var j = new h3d.prim.Skin.Joint();
				getDefaultMatrixes(model); // store for later usage in animation
				j.index = model.getId();
				j.name = model.getName();
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
				var mat = textureLoader(tex.get("FileName").props[0].toString());
				o = new h3d.scene.Mesh(prim, mat, scene);
			case type:
				throw "Unknown model type " + type+" for "+model.getName();
			}
			o.name = model.getName();
			var m = getDefaultMatrixes(model);
			if( m.trans != null || m.rotate != null || m.scale != null || m.preRot != null )
				o.defaultTransform = m.toMatrix(leftHand);
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
			} else if( p.getType() != "Root" && p.getType() != "Null" )
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
				if( !Std.is(o.obj,h3d.scene.Skin) )
					throw o.obj.name + ":" + o.model.getType() + " should be a skin";
				var skin : h3d.scene.Skin = cast o.obj;
				var skinData = createSkin(hskins, hgeom, rootJoints, bonesPerVertex);
				// if we have a skinned object, remove it (only keep the skin) and set the material
				for( o in objects ) {
					if( !o.obj.isMesh() ) continue;
					var m = o.obj.toMesh();
					if( m.primitive != skinData.primitive || m == skin )
						continue;
					skin.material = m.material;
					m.remove();
				}
				// set the skin data
				skin.setSkinData(skinData);
			}
		}
		return scene;
	}
	
	function createSkin( hskins : Map<Int,h3d.prim.Skin>, hgeom : Map<Int,h3d.prim.FBXModel>, rootJoints : Array<h3d.prim.Skin.Joint>, bonesPerVertex ) {
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
			var jModel = ids.get(j.index);
			var subDef = getParent(jModel, "Deformer", true);
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
				defaultModelMatrixes.get(jModel.getName()).removedJoint = true;
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
			if( leftHand ) DefaultMatrixes.rightHandToLeft(j.transPos);
			
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
			throw "No joint is skinned";
		allJoints.reverse();
		for( i in 0...allJoints.length )
			allJoints[i].index = i;
		skin.setJoints(allJoints, rootJoints);
		skin.initWeights();
		return skin;
	}
	
	function getDefaultMatrixes( model : FbxNode ) {
		var d = new DefaultMatrixes();
		var F = Math.PI / 180;
		for( p in model.getAll("Properties70.P") )
			switch( p.props[0].toString() ) {
			case "GeometricTranslation":
				// handle in Geometry directly
			case "PreRotation":
				d.preRot = new h3d.Point(p.props[4].toFloat() * F, p.props[5].toFloat() * F, p.props[6].toFloat() * F);
			case "Lcl Rotation":
				d.rotate = new h3d.Point(p.props[4].toFloat() * F, p.props[5].toFloat() * F, p.props[6].toFloat() * F);
			case "Lcl Translation":
				d.trans = new h3d.Point(p.props[4].toFloat(), p.props[5].toFloat(), p.props[6].toFloat());
			case "Lcl Scaling":
				d.scale = new h3d.Point(p.props[4].toFloat(), p.props[5].toFloat(), p.props[6].toFloat());
			case "RotationActive", "InheritType", "ScalingMin", "MaxHandle", "DefaultAttributeIndex", "Show", "UDP3DSMAX":
			case "RotationMinX","RotationMinY","RotationMinZ","RotationMaxX","RotationMaxY","RotationMaxZ", "Freeze", "Visibility":
			default:
				#if debug
				trace(p.props[0].toString());
				#end
			}
		defaultModelMatrixes.set(model.getName(), d);
		return d;
	}
	
}