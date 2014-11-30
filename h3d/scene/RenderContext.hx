package h3d.scene;
import h3d.pass.Object in ObjectPass;

class RenderContext extends h3d.impl.RenderContext {

	public var camera : h3d.Camera;
	public var drawPass : ObjectPass;

	public var sharedGlobals : Map<Int,Dynamic>;
	public var lightSystem : h3d.pass.LightSystem;
	public var uploadParams : Void -> Void;
	public var extraShaders : hxsl.ShaderList;

	var pool : ObjectPass;
	var cachedShaderList : Array<hxsl.ShaderList>;
	var cachedPos : Int;
	var passes : ObjectPass;
	var lights : Light;

	public function new() {
		super();
		cachedShaderList = [];
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
		cachedPos = 0;
		time += elapsedTime;
		frame++;
	}

	public inline function nextPass() {
		cachedPos = 0;
		drawPass = null;
	}

	public function getGlobal( name : String ) : Dynamic {
		return sharedGlobals.get(hxsl.Globals.allocID(name));
	}

	public function setGlobal( name : String, value : Dynamic ) {
		sharedGlobals.set(hxsl.Globals.allocID(name), value);
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

	public function allocShaderList( s : hxsl.Shader, ?next : hxsl.ShaderList ) {
		var sl = cachedShaderList[cachedPos++];
		if( sl == null ) {
			sl = new hxsl.ShaderList(null);
			cachedShaderList[cachedPos - 1] = sl;
		}
		sl.s = s;
		sl.next = next;
		return sl;
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
		for( c in cachedShaderList ) {
			c.s = null;
			c.next = null;
		}
		passes = null;
		lights = null;
	}

}