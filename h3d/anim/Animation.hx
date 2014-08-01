package h3d.anim;

class AnimatedObject {

	public var objectName : String;
	public var targetObject : h3d.scene.Object;
	public var targetSkin : h3d.scene.Skin;
	public var targetJoint : Int;

	public function new(name) {
		this.objectName = name;
	}

	public function clone() {
		return new AnimatedObject(objectName);
	}

}

private class AnimWait {
	public var frame : Float;
	public var callb : Void -> Void;
	public var next : AnimWait;
	public function new(f, c, n) {
		frame = f;
		callb = c;
		next = n;
	}
}

class Animation {

	static inline var EPSILON = 0.000001;

	public var name : String;
	public var frameCount(default, null) : Int;
	public var sampling(default,null) : Float;
	public var frame(default, null) : Float;

	public var speed : Float;
	public var onAnimEnd : Void -> Void;

	public var pause : Bool;
	public var loop : Bool;

	var waits : AnimWait;
	var isInstance : Bool;
	var objects : Array<AnimatedObject>;

	function new(name, frameCount, sampling) {
		this.name = name;
		this.frameCount = frameCount;
		this.sampling = sampling;
		objects = [];
		frame = 0.;
		speed = 1.;
		loop = true;
		pause = false;
	}

	inline function getIFrame() {
		var f = Std.int(frame);
		var max = endFrame();
		if( f == max ) f--;
		return f;
	}

	/**
		Register a callback function that will be called once when a frame is reached.
	**/
	public function waitForFrame( f : Float, callb : Void -> Void ) {
		// add sorted
		var prev = null;
		var cur = waits;
		while( cur != null ) {
			if( cur.frame > f )
				break;
			prev = cur;
			cur = cur.next;
		}
		if( prev == null )
			waits = new AnimWait(f, callb, waits);
		else
			prev.next = new AnimWait(f, callb, prev.next);
	}

	/**
		Remove all frame listeners
	**/
	public function clearWaits() {
		waits = null;
	}

	public function setFrame( f : Float ) {
		frame = f % frameCount;
		if( frame < 0 ) frame += frameCount;
	}

	function clone( ?a : Animation ) : Animation {
		if( a == null )
			a = new Animation(name, frameCount, sampling);
		a.objects = objects;
		a.speed = speed;
		a.loop = loop;
		a.pause = pause;
		return a;
	}

	function initInstance() {
		isInstance = true;
	}

	public function createInstance( base : h3d.scene.Object ) {
		var currentSkin : h3d.scene.Skin = null;
		var objects = [for( a in this.objects ) a.clone()];
		var a = clone();
		a.objects = objects;
		a.bind(base);
		a.initInstance();
		return a;
	}

	/**
		If one of the animated object has been changed, it is necessary to call bind() so the animation can keep with the change.
	**/
	@:access(h3d.scene.Skin.skinData)
	public function bind( base : h3d.scene.Object ) {
		var currentSkin : h3d.scene.Skin = null;
		for( a in objects ) {
			if( currentSkin != null ) {
				// quick lookup for joints (prevent creating a temp object)
				var j = currentSkin.skinData.namedJoints.get(a.objectName);
				if( j != null ) {
					a.targetSkin = currentSkin;
					a.targetJoint = j.index;
				}
			}
			var obj = base.getObjectByName(a.objectName);
			if( obj == null )
				throw a.objectName + " was not found";
			var joint = Std.instance(obj, h3d.scene.Skin.Joint);
			if( joint != null ) {
				currentSkin = cast joint.parent;
				a.targetSkin = currentSkin;
				a.targetJoint = joint.index;
			} else {
				a.targetObject = obj;
			}
		}
	}

	/**
		Synchronize the target object matrix.
		If decompose is true, then the rotation quaternion is stored in [m12,m13,m21,m23] instead of mixed with the scale.
	**/
	public function sync( decompose : Bool = false ) {
		// should be overridden in subclass
		throw "assert";
	}

	function isPlaying() {
		return !pause && (speed < 0 ? -speed : speed) > EPSILON;
	}

	function endFrame() {
		return frameCount;
	}

	public function update(dt:Float) : Float {
		if( !isInstance )
			throw "You must instanciate this animation first";

		if( !isPlaying() )
			return 0;

		// check waits
		var w = waits;
		var prev = null;
		while( w != null ) {
			var wt = (w.frame - frame) / (speed * sampling);
			// don't run if we're already on the frame (allow to set waitForFrame on the same frame we are)
			if( wt <= 0 ) {
				prev = w;
				w = w.next;
				continue;
			}
			if( wt > dt )
				break;
			frame = w.frame;
			dt -= wt;
			if( prev == null )
				waits = w.next;
			else
				prev.next = w.next;
			w.callb();
			return dt;
		}

		// check on anim end
		if( onAnimEnd != null ) {
			var end = endFrame();
			var et = (end - frame) / (speed * sampling);
			if( et <= dt && et > 0 ) {
				frame = end;
				dt -= et;
				onAnimEnd();
				// if we didn't change the frame or paused the animation, let's end it
				if( frame == end && isPlaying() ) {
					if( loop ) {
						frame = 0;
					} else {
						// don't loop infinitely
						dt = 0;
					}
				}
				return dt;
			}
		}

		// update frame
		frame += dt * speed * sampling;
		if( frame >= frameCount ) {
			if( loop )
				frame %= frameCount;
			else
				frame = frameCount;
		}
		return 0;
	}

}