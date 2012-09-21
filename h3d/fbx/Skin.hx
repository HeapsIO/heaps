package h3d.fbx;
using h3d.fbx.Data;

class Joint extends h3d.prim.Skin.Joint {
	
	public var cluster : FbxNode;
	public var model : FbxNode;
	public var modelId : Int;
	
	public var linkPos : h3d.Matrix; // absolute pose matrix
	
	public function new(n, m) {
		super();
		this.cluster = n;
		this.model = m;
	}

}

class Skin extends h3d.prim.Skin {
	
	var root : FbxNode;
	var lib : Library;
	var hJoints : IntHash<Joint>;
	public var allJoints : Array<Joint>;
	public var rootJoints : Array<Joint>;
	
	public function new(lib, root, vertexCount, bonesPerVertex) {
		super(vertexCount, bonesPerVertex);
		
		this.lib = lib;
		this.root = root;
		// init joints
		allJoints = [];
		for( v in lib.getSubs(root) )
			if( v.getType() == "Cluster" ) {
				var model = null;
				for( s in lib.getSubs(v) )
					if( s.getType() == "LimbNode" ) {
						model = s;
						break;
					}
				if( model == null )
					throw "Missing LimbNode for " + v.getName();
				allJoints.push(new Joint(v,model));
			}
		// do we have a root with no skinning ?
		var root = lib.getParents(allJoints[0].model,"Model")[0];
		if( root != null )
			allJoints.unshift(new Joint(null, root));
			
		rootJoints = allJoints.copy();
		
		// init joint LimbNode
		var envelop = [];
		hJoints = new IntHash();
		for( j in allJoints ) {
			j.modelId = j.model.getId();
			hJoints.set(j.modelId, j);
			
			if( j.cluster == null ) {
				j.transPos = h3d.Matrix.I();
				j.linkPos = h3d.Matrix.I();
			} else {
				j.transPos = h3d.Matrix.L(j.cluster.get("Transform").getFloats());
				j.linkPos = h3d.Matrix.L(j.cluster.get("TransformLink").getFloats());
				var weights = j.cluster.getAll("Weights");
				if( weights.length > 0 ) {
					var weights = weights[0].getFloats();
					var vertex = j.cluster.get("Indexes").getInts();
					for( i in 0...vertex.length ) {
						var w = weights[i];
						if( w < 0.01 )
							continue;
						addInfluence(vertex[i], j, w);
					}
				}
			}
		}
		
		initWeights();
		
		// init tree
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
	}
	
	function makeMatrix( trans : h3d.Point, rot : h3d.Point, scale : h3d.Point, ?preRot : h3d.Point ) {
		var m = new h3d.Matrix();
		
		if( scale != null )
			m.initScale(scale.x, scale.y, scale.z);
		else
			m.identity();
			
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
	
	public function getAnimation( name : String ) {
		var node = null;
		for( a in lib.getRoot().getAll("Objects.AnimationStack") )
			if( a.getName() == "AnimStack::" + name ) {
				node = a;
				break;
			}
		if( node == null )
			throw "Anim " + name + " not found";
		var anim = new h3d.prim.Skin.Animation(name);
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
			if( anim.frameCount == 0 && ftrans != null )
				anim.frameCount = ftrans[0].length;
			var t = ftrans == null ? null : new h3d.Point();
			var r = frot == null ? null : new h3d.Point();
			var s = fscale == null ? null : new h3d.Point();
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