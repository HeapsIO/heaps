package h3d.fbx;
using h3d.fbx.Data;

class Joint {
	
	public var parent : Joint;
	public var modelId : Int;
	public var bindId : Int;

	public var subs : Array<Joint>;

	public var cluster : FbxNode;
	public var model : FbxNode;
	
	public var transPos : h3d.Matrix; // inverse pose matrix
	public var linkPos : h3d.Matrix; // absolute pose matrix
	public var relLinkPos : h3d.Matrix; // parent-relative pose matrix
	
	public var curPos : h3d.Matrix;

	public function new(n, m) {
		bindId = -1;
		this.cluster = n;
		this.model = m;
		subs = [];
	}

}

class AnimCurve {
	public var joint : Joint;
	public var parent : AnimCurve;
	public var def : h3d.Matrix;
	public var frames : Array<h3d.Matrix>;
	public var absolute : Bool;
	public function new(j) {
		this.joint = j;
	}
}

class Animation {
	
	public var name : String;
	public var curves : Array<AnimCurve>;
	public var hcurves : IntHash<AnimCurve>;
	public var frameCount : Int;
	
	public function new(n) {
		this.name = n;
		curves = [];
		hcurves = new IntHash();
	}
	
	public function computeAbsoluteFrames() {
		for( c in curves )
			if( !c.absolute )
				computeAnimFrames(c);
	}
	
	function computeAnimFrames( c : AnimCurve ) {
		if( c.absolute )
			return;
		c.absolute = true;
		if( c.parent == null )
			return;
		computeAnimFrames(c.parent);
		for( i in 0...frameCount ) {
			var m = c.frames[i];
			m.multiply3x4(m, c.parent.frames[i]);
		}
	}
	
	public function updateJoints( frame : Int, palette : Array<h3d.Matrix> ) {
		frame %= frameCount;
		for( c in curves ) {
			var m = palette[c.joint.bindId];
			if( m == null ) continue;
			m.loadFrom(c.joint.transPos);
			var mf = c.frames[frame];
			if( mf != null ) m.multiply3x4(m, mf);
		}
	}
	
	public function allocPalette() {
		var max = -1;
		for( c in curves )
			if( c.joint.bindId >= max )
				max = c.joint.bindId;
		var a = [];
		for( i in 0...max + 1 )
			a.push(new h3d.Matrix());
		return a;
	}
	
}

private class Influence {
	public var j : Joint;
	public var w : Float;
	public function new(j, w) {
		this.j = j;
		this.w = w;
	}
}

class Skin {
	
	var root : FbxNode;
	var lib : Library;
	var hJoints : IntHash<Joint>;
	public var boundJoints : Array<Joint>;
	public var allJoints : Array<Joint>;
	public var rootJoints : Array<Joint>;
	
	public var bonesPerVertex(default,null) : Int;
	public var vertexJoints : flash.Vector<Int>;
	public var vertexWeights : flash.Vector<Float>;
	
	public function new(lib, root, vertexCount, bonesPerVertex) {
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
						var vidx = vertex[i];
						var il = envelop[vidx];
						if( il == null )
							il = envelop[vidx] = [];
						il.push(new Influence(j,w));
					}
				}
			}
		}
		
		// init weights
		boundJoints = [];
		this.bonesPerVertex = bonesPerVertex;
		vertexJoints = new flash.Vector(vertexCount * bonesPerVertex);
		vertexWeights = new flash.Vector(vertexCount * bonesPerVertex);
		var pos = 0;
		for( i in 0...vertexCount ) {
			var il = envelop[i];
			if( il == null ) il = [];
			il.sort(sortInfluences);
			if( il.length > 4 )
				il = il.slice(0, 4);
			var tw = 0.;
			for( i in il )
				tw += i.w;
			tw = 1 / tw;
			for( i in 0...bonesPerVertex ) {
				var i = il[i];
				if( i == null ) {
					vertexJoints[pos] = 0;
					vertexWeights[pos] = 0;
				} else {
					if( i.j.bindId == -1 ) {
						i.j.bindId = boundJoints.length;
						boundJoints.push(i.j);
					}
					vertexJoints[pos] = i.j.bindId;
					vertexWeights[pos] = i.w;
				}
				pos++;
			}
		}
		
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
		for( r in rootJoints )
			initRec(r);
	}
	
	function sortInfluences( i1 : Influence, i2 : Influence ) {
		return i2.w > i1.w ? 1 : -1;
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
			tmp.transpose();
			m.multiply(m, tmp);
		}
			
		if( preRot != null ) {
			var q = new h3d.Quat();
			q.initRotation(preRot.y, preRot.z, preRot.x);
			var tmp = q.toMatrix();
			tmp.transpose();
			m.multiply(m, tmp);
		}
			
		if( trans != null )
			m.translate(trans.x,trans.y,trans.z);
		
		return m;
	}
	
	function initRec( j : Joint ) {
		if( j.parent == null )
			j.relLinkPos = j.linkPos;
		else {
			var tmp = j.parent.linkPos.copy();
			tmp.invert();
			tmp.multiply(j.linkPos, tmp);
			j.relLinkPos = tmp;
		}
		for( s in j.subs )
			initRec(s);
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
		var anim = new Animation(name);
		var layers = lib.getSubs(node,"AnimationLayer");
		//if( layers.length != 1 )
		//	throw "Anim " + name + " has " + layers.length + " layers";
		var layer = layers[0];
		var curves = lib.getSubs(layer);
		var F = Math.PI / 180;
		for( j in allJoints ) {
			var a = new AnimCurve(j);
			anim.curves.push(a);
			anim.hcurves.set(j.modelId, a);
			var ftrans = null, frot = null, fscale = null;
			var dtrans = null, drot = null, dscale = null;
			for( c in lib.getSubs(j.model, "AnimationCurveNode") )
				if( curves.remove(c) ) {
					function getProp(n) {
						for( p in c.getAll("Properties70.P") )
							if( p.props[0].toString() == n )
								return p.props[4].toFloat();
						throw n + " not found";
					}
					function getCurves() {
						var v = [];
						for( k in lib.getSubs(c) )
							v.push(k.get("KeyValueFloat").getFloats());
						if( v.length != 3 )
							throw "Missing curve element";
						return v;
					}
					switch( c.getName() ) {
					case "AnimCurveNode::T":
						dtrans = new h3d.Point(getProp("d|X"), getProp("d|Y"), getProp("d|Z"));
						ftrans = getCurves();
					case "AnimCurveNode::R":
						drot = new h3d.Point(getProp("d|X") * F, getProp("d|Y") * F, getProp("d|Z") * F);
						frot = getCurves();
					case "AnimCurveNode::S":
						dscale = new h3d.Point(getProp("d|X"), getProp("d|Y"), getProp("d|Z"));
						fscale = getCurves();
					default:
						throw c.getName();
					}
				}
			a.def = makeMatrix(dtrans, drot, dscale);
			
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
			if( a.joint.parent != null )
				a.parent = anim.hcurves.get(a.joint.parent.modelId);
				
		anim.computeAbsoluteFrames();
		
		return anim;
	}
	
}