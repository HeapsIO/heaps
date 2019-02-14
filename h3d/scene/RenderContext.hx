package h3d.scene;

private class SharedGlobal {
	public var gid : Int;
	public var value : Dynamic;
	public function new(gid, value) {
		this.gid = gid;
		this.value = value;
	}
}

class RenderContext extends h3d.impl.RenderContext {

	public var camera : h3d.Camera;
	public var scene : Scene;
	public var drawPass : h3d.pass.PassObject;
	public var pbrLightPass : h3d.mat.Pass;
	public var computingStatic : Bool;

	var sharedGlobals : Array<SharedGlobal>;
	public var lightSystem : h3d.scene.LightSystem;
	public var uploadParams : Void -> Void;
	public var extraShaders : hxsl.ShaderList;
	public var visibleFlag : Bool;

	var allocPool : h3d.pass.PassObject;
	var allocFirst : h3d.pass.PassObject;
	var cachedShaderList : Array<hxsl.ShaderList>;
	var cachedPassObjects : Array<Renderer.PassObjects>;
	var cachedPos : Int;
	var passes : h3d.pass.PassObject;
	var lights : Light;

	public function new() {
		super();
		cachedShaderList = [];
		cachedPassObjects = [];
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
		sharedGlobals = [];
		lights = null;
		drawPass = null;
		passes = null;
		lights = null;
		uploadParams = null;
		cachedPos = 0;
		visibleFlag = true;
		time += elapsedTime;
		frame++;
	}

	public inline function nextPass() {
		cachedPos = 0;
		drawPass = null;
	}

	public function getGlobal( name : String ) : Dynamic {
		var id = hxsl.Globals.allocID(name);
		for( g in sharedGlobals )
			if( g.gid == id )
				return g.value;
		return null;
	}

	public inline function setGlobal( name : String, value : Dynamic ) {
		setGlobalID(hxsl.Globals.allocID(name), value);
	}

	public function setGlobalID( gid : Int, value : Dynamic ) {
		for( g in sharedGlobals )
			if( g.gid == gid ) {
				g.value = value;
				return;
			}
		sharedGlobals.push(new SharedGlobal(gid, value));
	}

	public function emitPass( pass : h3d.mat.Pass, obj : h3d.scene.Object ) @:privateAccess {
		var o = allocPool;
		if( o == null ) {
			o = new h3d.pass.PassObject();
			o.nextAlloc = allocFirst;
			allocFirst = o;
		} else
			allocPool = o.nextAlloc;
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
		var p = allocFirst;
		while( p != null && p != allocPool ) {
			p.obj = null;
			p.pass = null;
			p.shader = null;
			p.shaders = null;
			p.next = null;
			p.index = 0;
			p.texture = 0;
			p = @:privateAccess p.nextAlloc;
		}
		// one pooled object was not used this frame, let's gc unused one by one
		if( allocPool != null )
			allocFirst = @:privateAccess allocFirst.nextAlloc;
		allocPool = allocFirst;
		for( c in cachedShaderList ) {
			c.s = null;
			c.next = null;
		}
		passes = null;
		lights = null;
	}

}