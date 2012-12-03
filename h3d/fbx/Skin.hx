package h3d.fbx;
using h3d.fbx.Data;

class Joint extends h3d.prim.Skin.Joint {
	
	public var model : FbxNode;
	public var modelId : Int;
	
	public var defTrans : h3d.Point;
	public var defScale : h3d.Point;
	public var defRot : h3d.Point;
	
	public function new(m) {
		super();
		this.model = m;
	}

}

class Skin extends h3d.prim.Skin {
	
	var root : FbxNode;
	var lib : Library;
	var allJoints : Array<Joint>;
	var rootJoints : Array<Joint>;
	
	public function new(lib, root, meshGeom : FbxNode, vertexCount, bonesPerVertex) {
		super(vertexCount, bonesPerVertex);
		
		this.lib = lib;
		this.root = root;
		
		// list joints from clusters (bones with envelop)
		var envelop = [];
		var hJoints = new IntHash();
		allJoints = [];
		for( v in lib.getSubs(root) ) {
			if( v.getType() != "Cluster" )
				continue;
			var model = null;
			for( s in lib.getSubs(v) )
				if( s.getType() == "LimbNode" ) {
					model = s;
					break;
				}
			if( model == null )
				throw "Missing LimbNode for " + v.getName();
			
			var j = new Joint(model);
			j.modelId = model.getId();
			j.transPos = h3d.Matrix.L(v.get("Transform").getFloats());
			var m = getMatrixes(model);
			if( m.t != null )
				j.defTrans = m.t;
			if( m.r != null )
				j.defRot = m.r;
			if( m.s != null )
				j.defScale = m.s;
			allJoints.push(j);
			hJoints.set(j.modelId, j);
			
			// init envelop
			var weights = v.getAll("Weights");
			if( weights.length > 0 ) {
				var weights = weights[0].getFloats();
				var vertex = v.get("Indexes").getInts();
				for( i in 0...vertex.length ) {
					var w = weights[i];
					if( w < 0.01 )
						continue;
					addInfluence(vertex[i], j, w);
				}
			}
		}
	
		// finalize envelop
		initWeights();
		
		// init tree
		rootJoints = allJoints.copy();
		for( j in hJoints )
			for( s in lib.getSubs(j.model,"Model") )
				if( s.getType() == "LimbNode" ) {
					var sub = hJoints.get(s.getId());
					if( sub == null ) {
						// ending joints are not skinned, since they have no animation
						continue;
					}
					sub.parent = j;
					j.subs.push(sub);
					rootJoints.remove(sub);
				}
				
		// if we have skinned bones having parents which are not skinned, add them to the list (recursively)
		var found = true;
		while( found ) {
			found = false;
			for( jsub in rootJoints )
				for( p in lib.getParents(jsub.model, "Model") )
					if( p.getType() == "LimbNode" ) {
						var pid = p.getId();
						var j = hJoints.get(pid);
						if( j == null ) {
							j = new Joint(p);
							j.modelId = pid;
							hJoints.set(pid, j);
							allJoints.push(j);
							rootJoints.push(j);
						}
						jsub.parent = j;
						j.subs.push(jsub);
						rootJoints.remove(jsub);
						found = true;
						break;
					}
		}
		
		// init transforms
		
		/*
			From the FBX SDK, we have :
				
				VTM = (RGCP'-1 . CGCP) . (CGIP'-1 . RGIP)
				
				We have calculated that :
				- RGCP = MeshPosition
				- CGCP = (RootMeshPosition ... BipPosition) . (ParentFrame .... CurrentFrame)
					We concat all position (either the Lcl one or the KeyFrame one if there is an AnimCurve)
				- CGIP = TransformLink
				- RGIP = TransformLink . Transform . MeshGeometryTransform
				
				As a result, we have :
					
				VTM = (MeshPosition.-1 . RootMeshPosition....BipPosition) . (ParentFrame .... CurrentFrame) . Transform . MeshGeometryTransform
				
				   Mesh : the geometry mesh
				   Root : the mesh and skin/bip common ancestor ?
				
				/!\ FDK SDK and our implementation perform matrix multiplication is reverse order.
				The order of this documentation matches the SDK one.
				
		*/
		
		var meshObj = lib.getParents(meshGeom,"Model")[0];

		// assume that the mesh in on the stage (common ancestor = stage)
		var parents = lib.getParents(meshObj);
		if( parents.length > 0 )
			throw "Mesh has parent [" + Lambda.map(parents, function(p) return try p.getName() catch( e : Dynamic ) p.name)+"]";
		
		// get the skin root
		var skinRoot = lib.getParents(this.rootJoints[0].model, "Model")[0];

		preTransform.identity();
		while( skinRoot != null ) {
			preTransform.multiply(preTransform, getMatrix(skinRoot));
			skinRoot = lib.getParents(skinRoot)[0];
		}
			
		var meshPos = getMatrix(meshObj);
		meshPos.invert();
		preTransform.multiply(preTransform, meshPos);
			
		// apply geometric translation as a pre AND post transform matrix
		var geomTrans = null;
		for( p in meshObj.getAll("Properties70.P") )
			switch( p.props[0].toString() ) {
			case "GeometricTranslation":
				geomTrans = new h3d.Point(p.props[4].toFloat(), p.props[5].toFloat(), p.props[6].toFloat());
				preTransform.translate(geomTrans.x, geomTrans.y, geomTrans.z);
			default:
			}
		if( geomTrans != null ) {
			var geomTransform = makeMatrix(null, null, null, null, geomTrans);
			for( j in allJoints )
				if( j.transPos != null )
					j.transPos.multiply(geomTransform, j.transPos);
		}
	}
	
	function getMatrixes( model : FbxNode ) {
		var preRot = null, trans = null, rot = null, scale = null, geomTrans = null;
		var F = Math.PI / 180;
		for( p in model.getAll("Properties70.P") )
			switch( p.props[0].toString() ) {
			case "GeometricTranslation":
				geomTrans = new h3d.Point(p.props[4].toFloat(), p.props[5].toFloat(), p.props[6].toFloat());
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
		return { t : trans, r : rot, s : scale, preRot : preRot, geomTrans : geomTrans };
	}
	
	function getMatrix(model) {
		var m = getMatrixes(model);
		return makeMatrix(m.t, m.r, m.s, m.preRot, m.geomTrans);
	}

	function makeMatrix( trans : h3d.Point, rot : h3d.Point, scale : h3d.Point, ?preRot : h3d.Point, ?geoTrans : h3d.Point ) {
		var m = new h3d.Matrix();
		
		if( geoTrans != null )
			m.initTranslate(geoTrans.x, geoTrans.y, geoTrans.z);
		else
			m.identity();
		
		if( scale != null )
			m.scale(scale.x, scale.y, scale.z);
			
		if( rot != null ) {
			var q = new h3d.Quat();
			q.initRotation(rot.y, rot.z, rot.x);
			var tmp = q.toMatrix();
			tmp.transpose(); // FIXME
			m.multiply(m, tmp);
		}
			
		if( preRot != null ) {
			var q = new h3d.Quat();
			q.initRotation(preRot.y, preRot.z, preRot.x);
			var tmp = q.toMatrix();
			tmp.transpose(); // FIXME
			m.multiply(m, tmp);
		}
			
		if( trans != null )
			m.translate(trans.x,trans.y,trans.z);
		
		return m;
	}
	
	public function listAnimation()
		return Lambda.map( lib.getRoot().getAll("Objects.AnimationStack"),function(a) return a.getName() )
	
	public function getAnimation( name : String ) {
		var node = null;
		for( a in lib.getRoot().getAll("Objects.AnimationStack") )
			if( a.getName() == "AnimStack::" + name ) {
				node = a;
				break;
			}
		if( node == null )
			throw "Anim " + name + " not found";
		var anim = new h3d.prim.Skin.Animation(this, name);
		var layers = lib.getSubs(node,"AnimationLayer");
		//if( layers.length != 1 )
		//	throw "Anim " + name + " has " + layers.length + " layers";
		var layer = layers[0];
		var curves = lib.getSubs(layer);
		var F = Math.PI / 180;
		for( j in allJoints ) {
			var a = new h3d.prim.Skin.AnimCurve(j);
			anim.curves.push(a);
			anim.hcurves.set(j.modelId, a);
			var ftrans = null, frot = null, fscale = null;
			for( c in lib.getSubs(j.model, "AnimationCurveNode") )
				if( curves.remove(c) ) {
					function getCurves() {
						var v = [];
						// don't take KeyTime into account : assume constant sampling rate for all curves/anims
						for( k in lib.getSubs(c) )
							v.push(k.get("KeyValueFloat").getFloats());
						if( v.length != 3 )
							throw "Missing curve element";
						return v;
					}
					switch( c.getName() ) {
					case "AnimCurveNode::T":
						ftrans = getCurves();
					case "AnimCurveNode::R":
						frot = getCurves();
					case "AnimCurveNode::S":
						fscale = getCurves();
					default:
						throw c.getName();
					}
				}
			
			var frames = new Array();
			if( anim.frameCount == 0 ) {
				if( ftrans != null )
					anim.frameCount = ftrans[0].length;
				else if( frot != null )
					anim.frameCount = frot[0].length;
				else if( fscale != null )
					anim.frameCount = fscale[0].length;
			}
			
			// for defaults, use the bone Lcl infos, if any
			var t = ftrans == null ? j.defTrans : new h3d.Point();
			var r = frot == null ? j.defRot : new h3d.Point();
			var s = fscale == null ? j.defScale : new h3d.Point();
			
			for( i in 0...anim.frameCount ) {
				if( ftrans != null ) {
					t.x = ftrans[0][i];
					t.y = ftrans[1][i];
					t.z = ftrans[2][i];
				}
				if( frot != null ) {
					r.x = frot[0][i] * F;
					r.y = frot[1][i] * F;
					r.z = frot[2][i] * F;
				}
				if( fscale != null ) {
					s.x = fscale[0][i];
					s.y = fscale[1][i];
					s.z = fscale[2][i];
				}
				frames.push(makeMatrix(t,r,s));
			}
			a.frames = frames;
		}
		for( a in anim.curves )
			if( a.joint.parent != null ) {
				var aparent : Joint = cast a.joint.parent;
				a.parent = anim.hcurves.get(aparent.modelId);
			}
		return anim;
	}
	
}