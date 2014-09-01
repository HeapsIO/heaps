package h3d.scene;
import h3d.pass.Object in ObjectPass;

class RenderContext {

	public var engine : h3d.Engine;
	public var camera : h3d.Camera;
	public var time : Float;
	public var elapsedTime : Float;
	public var frame : Int;

	public var drawPass : ObjectPass;

	public var sharedGlobals : Map<Int,Dynamic>;

	public var uploadParams : Void -> Void;

	var pool : ObjectPass;
	var passes : ObjectPass;
	var lights : Light;

	public function new() {
		frame = 0;
		time = 0.;
		elapsedTime = 1. / hxd.Stage.getInstance().getFrameRate();
	}

	@:access(h3d.mat.Pass)
	public inline function emit( mat : h3d.mat.Material, obj, index = 0 ) {
		var p = mat.mainPass;
		while( p != null ) {
			emitPass(p, obj).index = index;
			p = p.nextPass;
		}
	}

	public function start() {
		sharedGlobals = new Map();
		lights = null;
		drawPass = null;
		passes = null;
		lights = null;
		uploadParams = null;
		time += elapsedTime;
		frame++;
	}

	public function emitPass( pass : h3d.mat.Pass, obj : h3d.scene.Object ) {
		var o = pool;
		if( o == null )
			o = new ObjectPass();
		else
			pool = o.next;
		o.pass = pass;
		o.obj = obj;
		o.next = passes;
		passes = o;
		return o;
	}

	public function emitLight( l : Light ) {
		l.next = lights;
		lights = l;
	}

	public function done() {
		drawPass = null;
		uploadParams = null;
		// move passes to pool, and erase data
		var p = passes, prev = null;
		while( p != null ) {
			p.obj = null;
			p.pass = null;
			p.shader = null;
			p.shaders = null;
			p.index = 0;
			prev = p;
			p = p.next;
		}
		if( prev != null ) {
			prev.next = pool;
			pool = passes;
		}
		passes = null;
		lights = null;
	}

}