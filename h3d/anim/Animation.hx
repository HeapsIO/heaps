package h3d.anim;

class AnimatedObject {

	public var objectName : String;
	#if !(dataOnly || macro)
	public var targetObject : h3d.scene.Object;
	public var targetSkin : h3d.scene.Skin;
	public var targetJoint : Int;
	#end

	public function new(name) {
		this.objectName = name;
	}

	public function clone() {
		return new AnimatedObject(objectName);
	}

}

class Animation {

	static inline var EPSILON = 0.000001;

	public var name : String;
	public var resourcePath : String;
	public var frameCount(default, null) : Int;
	public var sampling(default,null) : Float;
	public var frame(default, null) : Float;

	public var speed : Float;
	public var onAnimEnd : Void -> Void;
	public var onEvent : String -> Void;

	public var pause : Bool;
	public var loop : Bool;

	public var events(default, null) : Array<Array<String>>;

	var isInstance : Bool;
	var objects : Array<AnimatedObject>;
	var isSync : Bool;
	var lastEvent : Int;

	function new(name, frameCount, sampling) {
		this.name = name;
		this.frameCount = frameCount;
		this.sampling = sampling;
		objects = [];
		lastEvent = -1;
		frame = 0.;
		speed = 1.;
		loop = true;
		pause = false;
	}

	public function getDuration() {
		return frameToTime(frameCount);
	}

	inline function frameToTime(f) {
		return f / (sampling * speed);
	}

	inline function getIFrame() {
		var f = Std.int(frame);
		var max = endFrame();
		if( f == max ) f--;
		return f;
	}

	public function unbind( objectName : String ) {
		for( o in objects )
			if( o.objectName == objectName ) {
				isSync = false;
				#if !(dataOnly || macro)
				o.targetObject = null;
				o.targetSkin = null;
				#end
				return;
			}
	}

	/**
		Register a callback function that will be called once when a frame is reached.
	**/
	public function setEvents( el : Iterable<{ frame : Int, data : String }> ) {
		events = [for( i in 0...frameCount ) null];
		for( e in el ) {
			if(events[e.frame] == null) events[e.frame] = [];
			events[e.frame].push(e.data);
		}
	}

	public function addEvent(frame : Int, data : String) {
		if (events == null)
			events = [];
		if (events[frame] == null)
			events[frame] = [data];
		else
			events[frame].push(data);
	}

	public function getEvents() return events;

	public function getObjects() return objects;

	public function getEventTime( id : String ) : Null<Float> {
		if( events == null )
			return null;
		for( i in 0...events.length ) {
			var ev = events[i];
			if( ev != null && ev.indexOf(id) >= 0 ) return frameToTime(i);
		}
		return null;
	}

	public function setFrame( f : Float ) {
		frame = f;
		lastEvent = -1;
		while( frame < 0 ) frame += frameCount;
		while( frame > frameCount ) frame -= frameCount;
	}

	function clone( ?a : Animation ) : Animation {
		if( a == null )
			a = new Animation(name, frameCount, sampling);
		a.objects = objects;
		a.speed = speed;
		a.loop = loop;
		a.pause = pause;
		a.events = events;
		a.resourcePath = resourcePath;
		return a;
	}

	function initInstance() {
		isInstance = true;
	}

	#if !(dataOnly || macro)
	public function createInstance( base : h3d.scene.Object ) {
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
		for( a in objects.copy() ) {
			if( currentSkin != null ) {
				// quick lookup for joints (prevent creating a temp object)
				var j = currentSkin.skinData.namedJoints.get(a.objectName);
				if( j != null ) {
					a.targetSkin = currentSkin;
					a.targetJoint = j.index;
					continue;
				}
			}
			var obj = base.getObjectByName(a.objectName);
			if( obj == null ) {
				objects.remove(a);
				continue;
			}
			var joint = hxd.impl.Api.downcast(obj, h3d.scene.Skin.Joint);
			if( joint != null ) {
				currentSkin = cast joint.parent;
				a.targetSkin = currentSkin;
				a.targetJoint = joint.index;
			} else {
				a.targetObject = obj;
			}
		}
		isSync = false;
	}
	#end

	/**
		Returns the current value of animation property for the given object, or null if not found.
	**/
	public function getPropValue( objectName : String, propName : String ) : Null<Float> {
		return null;
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

		// check events
		if( events != null && onEvent != null ) {
			var f0 = Std.int(frame);
			var f1 = Std.int(frame + dt * speed * sampling);
			if( f1 >= frameCount ) f1 = frameCount - 1;
			for( f in f0...f1 + 1 ) {
				if( f == lastEvent ) continue;
				lastEvent = f;
				if( events[f] != null ) {
					var oldF = frame, oldDT = dt;
					dt -= (f - frame) / (speed * sampling);
					frame = f;
					for(e in events[f])
						onEvent(e);
					if( frame == f && f == frameCount - 1 ) {
						frame = oldF;
						dt = oldDT;
						break;
					} else
						return dt;
				}
			}
		}

		// check on anim end
		if( onAnimEnd != null ) {
			var end = endFrame();
			var et = speed == 0 ? 0 : (end - frame) / (speed * sampling);
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

	#if !(dataOnly || macro)
	function initAndBind( obj : h3d.scene.Object ) {
		bind(obj);
		initInstance();
		pause = true;
	}
	#end

	public function toString() {
		return name;
	}

}