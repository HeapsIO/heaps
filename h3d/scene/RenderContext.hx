package h3d.scene;

private class SharedGlobal {
	public var gid : Int;
	public var value : Dynamic;
	public function new(gid, value) {
		this.gid = gid;
		this.value = value;
	}
}

@:build(hxsl.Macros.buildGlobals())
class RenderContext extends h3d.impl.RenderContext {

	public var camera(default,null) : h3d.Camera;
	public var scene(default,null) : Scene;
	public var drawPass : h3d.pass.PassObject;
	public var pbrLightPass : h3d.mat.Pass;
	public var computingStatic : Bool;
	public var computeVelocity : Bool;

	public var lightSystem : h3d.scene.LightSystem;
	public var extraShaders : hxsl.ShaderList;
	public var visibleFlag : Bool;
	public var debugCulling : Bool;
	public var wasContextLost : Bool;
	public var cullingCollider : h3d.col.Collider;
	public var forcedScreenRatio : Float = -1;

	@global("camera.view") var cameraView : h3d.Matrix;
	@global("camera.zNear") var cameraNear : Float;
	@global("camera.zFar") var cameraFar : Float;
	@global("camera.proj") var cameraProj : h3d.Matrix;
	@global("camera.position") var cameraPos : h3d.Vector;
	@global("camera.projDiag") var cameraProjDiag : h3d.Vector4;
	@global("camera.projFlip") var cameraProjFlip : Float;
	@global("camera.viewProj") var cameraViewProj : h3d.Matrix;
	@global("camera.inverseViewProj") var cameraInverseViewProj : h3d.Matrix;
	@global("camera.previousViewProj") var cameraPreviousViewProj : h3d.Matrix;
	@global("camera.jitterOffsets") var cameraJitterOffsets : h3d.Vector4;
	@global("global.time") var globalTime : Float;
	@global("global.pixelSize") var pixelSize : h3d.Vector;
	@global("global.modelView") var globalModelView : h3d.Matrix;
	@global("global.modelViewInverse") var globalModelViewInverse : h3d.Matrix;
	@global("global.previousModelView") var globalPreviousModelView : h3d.Matrix;

	var allocPool : h3d.pass.PassObject;
	var allocFirst : h3d.pass.PassObject;
	var tmpComputeLink = new hxsl.ShaderList(null,null);
	var computeLink : hxsl.ShaderList;
	var cachedShaderList : Array<hxsl.ShaderList>;
	var cachedPassObjects : Array<Renderer.PassObjects>;
	var cachedPos : Int;
	var passes : Array<h3d.pass.PassObject>;
	var lights : Light;

	var cameraFrustumBuffer : h3d.Buffer = null;
	var cameraFrustumUploaded : Bool = false;

	public function new(scene) {
		super();
		this.scene = scene;
		cachedShaderList = [];
		cachedPassObjects = [];
		initGlobals();
	}

	public function setCamera( cam : h3d.Camera ) {
		camera = cam;
		cameraView = cam.mcam;
		cameraNear = cam.zNear;
		cameraFar = cam.zFar;
		cameraProj = cam.mproj;
		cameraPos = cam.pos;
		cameraProjDiag = new h3d.Vector4(cam.mproj._11,cam.mproj._22,cam.mproj._33,cam.mproj._44);
		if ( cameraPreviousViewProj == null )
			cameraPreviousViewProj = cam.m.clone();
		if (cameraJitterOffsets == null)
			cameraJitterOffsets = new h3d.Vector4( 0.0, 0.0, 0.0, 0.0 );
		cameraViewProj = cam.m;
		cameraInverseViewProj = camera.getInverseViewProj();
	}

	public function setupTarget() {
		cameraProjFlip = engine.driver.hasFeature(BottomLeftCoords) && engine.getCurrentTarget() != null ? -1 : 1;
	}

	function getCurrentPixelSize() {
		var t = engine.getCurrentTarget();
		return new h3d.Vector(2 / (t == null ? engine.width : t.width), 2 / (t == null ? engine.height : t.height));
	}

	@:access(h3d.mat.Pass)
	public inline function emit( mat : h3d.mat.Material, obj, index = 0 ) {
		var p = mat.mainPass;
		while( p != null ) {
			if ( !p.culled )
				emitPass(p, obj).index = index;
			p = p.nextPass;
		}
	}

	public function start() {
		lights = null;
		drawPass = null;
		passes = [];
		lights = null;
		cachedPos = 0;
		visibleFlag = true;
		forcedScreenRatio = -1;
		time += elapsedTime;
		frame++;
		setCurrent();
		engine = h3d.Engine.getCurrent();
		globalTime = time;
		pixelSize = getCurrentPixelSize();
		setCamera(scene.camera);
	}

	public inline function nextPass() {
		cachedPos = 0;
		drawPass = null;
	}

	public inline function getGlobal(name) : Dynamic {
		return globals.get(name);
	}

	public inline function setGlobal(name,v:Dynamic) {
		globals.set(name, v);
	}

	public function emitPass( pass : h3d.mat.Pass, obj : h3d.scene.Object ) @:privateAccess {
		if ( pass.rendererFlags & 1 == 0 )
			@:privateAccess scene.renderer.setPassFlags(pass);
		var o = allocPool;
		if( o == null ) {
			o = new h3d.pass.PassObject();
			o.nextAlloc = allocFirst;
			allocFirst = o;
		} else
			allocPool = o.nextAlloc;
		o.pass = pass;
		o.obj = obj;
		if ( passes.length <= pass.passId )
			passes.resize(pass.passId);
		o.next = passes[pass.passId];
		passes[pass.passId] = o;
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

	public function computeList(list : hxsl.ShaderList) {
		if ( computeLink != null )
			throw "Use computeDispatch to dispatch computeList";
		computeLink = list;
	}

	public function computeDispatch( ?shader : hxsl.Shader, x = 1, y = 1, z = 1 ) {
		if ( x <= 0 || y <= 0 || z <= 0 )
			throw "Can't use zero or negative work groups count";

		var prev = h3d.impl.RenderContext.get();
		if( prev != this )
			start();

		// compile shader
		globals.resetChannels();
		if ( shader != null ) {
			tmpComputeLink.s = shader;
			computeLink = tmpComputeLink;
		}
		for ( s in computeLink )
			s.updateConstants(globals);
		var rt = hxsl.Cache.get().link(computeLink, Compute);
		// upload buffers
		engine.driver.selectShader(rt);
		var buf = shaderBuffers;
		buf.grow(rt);
		fillGlobals(buf, rt);
		engine.uploadShaderBuffers(buf, Globals);
		fillParams(buf, rt, computeLink, true);
		engine.uploadShaderBuffers(buf, Params);
		engine.uploadShaderBuffers(buf, Textures);
		engine.uploadShaderBuffers(buf, Buffers);
		engine.driver.computeDispatch(x,y,z);
		@:privateAccess engine.dispatches++;
		if ( computeLink == tmpComputeLink )
			tmpComputeLink.s = null;
		computeLink = null;

		if( prev != this ) {
			done();
			if( prev != null ) prev.setCurrent();
		}
	}

	public function emitLight( l : Light ) {
		l.next = lights;
		lights = l;
	}

	public function getCameraFrustumBuffer() {
		if ( cameraFrustumBuffer == null )
			cameraFrustumBuffer = hxd.impl.Allocator.get().allocBuffer( 6, hxd.BufferFormat.VEC4_DATA, UniformDynamic );

		if ( !cameraFrustumUploaded ) {
			inline function fillBytesWithPlane( buffer : haxe.io.Bytes, startPos : Int, plane : h3d.col.Plane ) {
				buffer.setFloat( startPos, 			@:privateAccess plane.nx );
				buffer.setFloat( startPos + 4, 		@:privateAccess plane.ny );
				buffer.setFloat( startPos + 8, 		@:privateAccess plane.nz );
				buffer.setFloat( startPos + 12, 	@:privateAccess plane.d	);
			}

			var tmp = haxe.io.Bytes.alloc( 16 * 6 );
			var frustum = camera.frustum;
			fillBytesWithPlane( tmp, 0, 	frustum.pleft 	);
			fillBytesWithPlane( tmp, 16, 	frustum.pright 	);
			fillBytesWithPlane( tmp, 32, 	frustum.ptop 	);
			fillBytesWithPlane( tmp, 48, 	frustum.pbottom );
			fillBytesWithPlane( tmp, 64, 	frustum.pfar 	);
			fillBytesWithPlane( tmp, 80, 	frustum.pnear 	);

			cameraFrustumBuffer.uploadBytes(tmp, 0, 6);
			cameraFrustumUploaded = true;
		}

		return cameraFrustumBuffer;
	}

	public function uploadParams() {
		fillParams(shaderBuffers, drawPass.shader, drawPass.shaders);
		engine.uploadShaderBuffers(shaderBuffers, Params);
		engine.uploadShaderBuffers(shaderBuffers, Textures);
		engine.uploadShaderBuffers(shaderBuffers, Buffers);
	}

	public function done() {
		drawPass = null;
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
		passes = [];
		lights = null;

		cameraFrustumUploaded = false;

		cameraPreviousViewProj.load(cameraViewProj);
		computeVelocity = false;

		clearCurrent();
	}

	override public function dispose() {
		super.dispose();
		if ( cameraFrustumBuffer != null )
			hxd.impl.Allocator.get().disposeBuffer( cameraFrustumBuffer );
	}

}