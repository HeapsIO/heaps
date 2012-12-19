package h3d.prim;

class AnimatedObject {
	
	public var objectName : String;
	public var targetMatrix : h3d.Matrix;
	public var frames : flash.Vector<h3d.Matrix>;
	
	public function new() {
	}
	
}

class Animation {
	
	public var name : String;
	public var numFrames : Int;
	public var objects : Array<AnimatedObject>;
	
	public function new(name) {
		this.name = name;
		this.objects = [];
	}
	
	public function createInstance( base : h3d.scene.Object ) {
		var anim = new Animation(name);
		anim.numFrames = numFrames;
		for( a in objects ) {
			var obj = base.getObjectByName(a.objectName);
			if( obj == null )
				throw a.objectName + " was not found";
			var a2 = new AnimatedObject();
			a2.frames = a.frames;
			a2.targetMatrix = obj.defaultTransform;
			anim.objects.push(a2);
		}
		return anim;
	}
	
}