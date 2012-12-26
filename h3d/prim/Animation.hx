package h3d.prim;

class AnimatedObject {
	
	public var objectName : String;
	public var frames : flash.Vector<h3d.Matrix>;
	public var alphas : flash.Vector<Float>;
	public var targetObject : h3d.scene.Object;
	public var targetSkin : h3d.scene.Skin;
	public var targetJoint : Int;
	
	public function new(name, frames) {
		this.objectName = name;
		this.frames = frames;
	}
	
}

class Animation {
	
	public var name : String;
	public var numFrames : Int;
	
	public var time : Float;
	public var speed : Float;
	public var sampling : Float;
	
	var isInstance : Bool;
	var objects : Array<AnimatedObject>;
	var curFrame : Int;
	
	public function new(name) {
		this.name = name;
		this.objects = [];
		curFrame = -1;
		time = 0.;
		speed = 1.;
		sampling = 30;
	}
	
	public function addCurve( objName, frames ) {
		objects.push(new AnimatedObject(objName, frames));
	}
	
	public function addAlphaCurve( objName, alphas ) {
		var o = new AnimatedObject(objName, null);
		o.alphas = alphas;
		objects.push(o);
	}
	
	@:access(h3d.scene.Skin.skinData)
	public function createInstance( base : h3d.scene.Object ) {
		var anim = new Animation(name);
		anim.isInstance = true;
		anim.numFrames = numFrames;
		anim.speed = speed;
		anim.sampling = sampling;
		var currentSkin : h3d.scene.Skin = null;
		for( a in objects ) {
			var a2 = new AnimatedObject(a.objectName, a.frames);
			a2.alphas = a.alphas;
			if( currentSkin != null ) {
				// quick lookup for joints (prevent creating a temp object)
				var j = currentSkin.skinData.namedJoints.get(a.objectName);
				if( j != null ) {
					a2.targetSkin = currentSkin;
					a2.targetJoint = j.index;
					anim.objects.push(a2);
					continue;
				}
			}
			var obj = base.getObjectByName(a.objectName);
			if( obj == null )
				throw a.objectName + " was not found";
			var joint = flash.Lib.as(obj, h3d.scene.Skin.Joint);
			if( joint != null ) {
				currentSkin = cast joint.parent;
				a2.targetSkin = currentSkin;
				a2.targetJoint = joint.index;
			} else {
				a2.targetObject = obj;
				if( a.alphas != null ) {
					if( !a2.targetObject.isMesh() )
						throw a.objectName + " should be a mesh";
				}
			}
			anim.objects.push(a2);
		}
		return anim;
	}
	
	@:access(h3d.scene.Skin)
	public function update() {
		if( !isInstance )
			throw "You must instanciate this animation first";
		var iframe = Std.int(time * sampling) % numFrames;
		if( iframe < 0 ) iframe += numFrames;
		if( iframe == curFrame )
			return;
		curFrame = iframe;
		for( o in objects ) {
			if( o.alphas != null ) {
				var mat = o.targetObject.toMesh().material;
				if( mat.colorMul == null ) {
					mat.colorMul = new Vector(1, 1, 1, 1);
					mat.blend(SrcAlpha, OneMinusSrcAlpha);
				}
				mat.colorMul.w = o.alphas[iframe];
			} else if( o.targetSkin != null ) {
				o.targetSkin.currentRelPose[o.targetJoint] = o.frames[iframe];
				o.targetSkin.jointsUpdated = true;
			} else
				o.targetObject.defaultTransform = o.frames[iframe];
		}
	}
	
}