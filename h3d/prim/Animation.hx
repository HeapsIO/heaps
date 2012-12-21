package h3d.prim;

class AnimatedObject {
	
	public var objectName : String;
	public var frames : flash.Vector<h3d.Matrix>;
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
	
	public function createInstance( base : h3d.scene.Object ) {
		var anim = new Animation(name);
		anim.isInstance = true;
		anim.numFrames = numFrames;
		anim.speed = speed;
		anim.sampling = sampling;
		for( a in objects ) {
			var obj = base.getObjectByName(a.objectName);
			if( obj == null )
				throw a.objectName + " was not found";
			var a2 = new AnimatedObject(a.objectName, a.frames);
			if( Std.is(obj, h3d.scene.Skin.Joint) ) {
				a2.targetSkin = cast obj.parent;
				a2.targetJoint = cast(obj, h3d.scene.Skin.Joint).index;
			} else
				a2.targetObject = obj;
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
		for( o in objects )
			if( o.targetSkin != null ) {
				o.targetSkin.currentRelPose[o.targetJoint] = o.frames[iframe];
				o.targetSkin.jointsUpdated = true;
			} else
				o.targetObject.defaultTransform = o.frames[iframe];
	}
	
}