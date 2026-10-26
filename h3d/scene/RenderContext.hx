package h3d.scene;

import h3d.mat.Texture;
import h3d.col.Frustum;

private class SharedGlobal {
	public var gid : Int;
	public var value : Dynamic;
	public function new(gid, value) {
		this.gid = gid;
		this.value = value;
	}
}

class View {
	public var idx : Int;
	public var frustum : Frustum;
	public function new(idx) {
		this.idx = idx;
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
	public var enableTranslucency : Bool;
	public var useReverseDepth : Bool;
	public var renderResolutionWidth : Int;
	public var renderResolutionHeight : Int;

	public var lightSystem : h3d.scene.LightSystem;
	public var extraShaders : hxsl.ShaderList;
	public var visibleFlag : Bool;
	public var debugCulling : Bool;
	public var wasContextLost : Bool;
	public var cullingCollider : h3d.col.Collider;
	public var forcedScreenRatio : Float = -1;
	public var meshLodScale : Float = 1.0;

	public var hzb : h3d.mat.Texture;

	public var numViews : Int = 1;
	public var currentView : View = new h3d.scene.View(0);

	public var prevCamera : h3d.Camera;
	public var prevWorldDelta : h3d.Vector;

	@global("camera.view") var cameraView : h3d.Matrix;
	@global("camera.invView") var cameraInvView : h3d.Matrix;
	@global("camera.zNear") var cameraNear : Float;
	@global("camera.zFar") var cameraFar : Float;
	@global("camera.proj") var cameraProj : h3d.Matrix;
	@global("camera.invProj") var cameraInvProj : h3d.Matrix;
	@global("camera.prevPosition") var cameraPrevPos : h3d.Vector;
	@global("camera.position") var cameraPos : h3d.Vector;
	@global("camera.projDiag") var cameraProjDiag : h3d.Vector4;
	@global("camera.projFlip") var cameraProjFlip : Float;
	@global("camera.reverseDepth") var cameraReverseDepth : Bool;
	@global("camera.viewProj") var cameraViewProj : h3d.Matrix;
	@global("camera.inverseViewProj") var cameraInverseViewProj : h3d.Matrix;
	@global("camera.prevView") var cameraPrevView : h3d.Matrix;
	@global("camera.prevProj") var cameraPrevProj : h3d.Matrix;
	@global("camera.previousViewProj") var cameraPreviousViewProj : h3d.Matrix;
	@global("camera.jitterOffsets") var cameraJitterOffsets : h3d.Vector4;
	@global("global.prevTime") var globalPrevTime : Float;
	@global("global.time") var globalTime : Float;
	@global("global.pixelSize") var pixelSize : h3d.Vector;
	@global("global.modelView") var globalModelView : h3d.Matrix;
	@global("global.modelViewInverse") var globalModelViewInverse : h3d.Matrix;
	@global("global.previousModelView") var globalPreviousModelView : h3d.Matrix;
	@global("global.frame") var globalFrame : Int;

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

	public var streamingFeedback(default, null) : StreamingFeedback;
	/**
		The object being drawn, used to tell if the streamed textures it uses are visible.
	**/
	public var currentObject : Object;
	/**
		The frustum an object must intersect for its streamed textures to be visible : the camera frustum,
		or the light frustum while a shadow map is drawn (see h3d.pass.Shadows).
	**/
	public var visibilityFrustum : Frustum;
	var visibilityObject : Object;
	var visibilityObjectFrustum : Frustum;
	var objectVisible : Bool;
	var visibilitySphere = new h3d.col.Sphere();

	public function new(scene) {
		super();
		this.scene = scene;
		camera = new h3d.Camera();
		prevCamera = new h3d.Camera();
		renderResolutionWidth = engine.width;
		renderResolutionHeight = engine.height;
		cachedShaderList = [];
		cachedPassObjects = [];
		passes = [];
		initGlobals();
	}

	public function setCamera( cam : h3d.Camera ) {
		prevCamera.load(camera);
		camera.load(cam);
		cameraReverseDepth = camera.reverseDepth = useReverseDepth;
		camera.update();
		cameraView = camera.mcam;
		cameraInvView = camera.getInverseView();
		cameraNear = camera.zNear;
		cameraFar = camera.zFar;
		cameraProj = camera.mproj;
		cameraInvProj = camera.getInverseProj();
		cameraPos = camera.pos;
		if(cameraPrevPos == null)
			cameraPrevPos = camera.pos.clone();
		cameraProjDiag = new h3d.Vector4(camera.mproj._11,camera.mproj._22,camera.mproj._33,camera.mproj._44);
		if ( cameraPrevView == null )
			cameraPrevView = camera.mcam.clone();
		if ( cameraPrevProj == null )
			cameraPrevProj = camera.mproj.clone();
		if ( cameraPreviousViewProj == null )
			cameraPreviousViewProj = camera.m.clone();
		if (cameraJitterOffsets == null)
			cameraJitterOffsets = new h3d.Vector4( 0.0, 0.0, 0.0, 0.0 );
		cameraViewProj = camera.m;
		cameraInverseViewProj = camera.getInverseViewProj();
		currentView.frustum = camera.frustum;
		visibilityFrustum = camera.frustum;
		visibilityObject = null;
	}

	public function setRenderResolution( width : Int, height : Int ) {
		renderResolutionWidth = width;
		renderResolutionHeight = height;
		pixelSize = new h3d.Vector(2 / width, 2 / height);
	}

	public function updateNumViews( numViews : Int ) {
		this.numViews = numViews;
	}

	public function setCurrentView( viewIdx : Int, viewFrustum : Frustum ) {
		currentView.idx = viewIdx;
		currentView.frustum = viewFrustum;
	}

	public function setupTarget() {
		var v = engine.driver.hasFeature(BottomLeftCoords) && engine.getCurrentTarget() != null ? -1 : 1;
		if( cameraProjFlip != v ) cameraProjFlip = v;
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
		drawPass = null;
		passes.resize(0);
		lights = null;
		cachedPos = 0;
		visibleFlag = true;
		forcedScreenRatio = -1;
		globalPrevTime = time;
		time += elapsedTime;
		frame++;
		setCurrent();
		engine = h3d.Engine.getCurrent();
		setRenderResolution(engine.width, engine.height);
		globalTime = time;
		globalFrame = frame;
		pixelSize = getCurrentPixelSize();
		setCamera(scene.camera);
		numViews = 1;
		if( streamingFeedback != null ) streamingFeedback.begin();
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

	public function memoryBarrier(){
		engine.driver.memoryBarrier();
	}

	public function computeDispatch( ?shader : hxsl.Shader, x = 1, y = 1, z = 1, barrier : Bool = true) {
		if ( x <= 0 || y <= 0 || z <= 0 )
			throw "Can't use zero or negative work groups count";
		if ( x > 65535 || y > 65535 || z > 65535 )
			throw "Thread group size can't exceed 65535";

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
		engine.selectShader(rt);
		if( !engine.shaderFailed && h3d.impl.RenderError.guard(uploadComputeParams(rt), Params(rt)) )
			engine.computeDispatch(x, y, z, barrier);
		if ( computeLink == tmpComputeLink )
			tmpComputeLink.s = null;
		computeLink = null;

		if( prev != this ) {
			done();
			if( prev != null ) prev.setCurrent();
		}
	}

	function uploadComputeParams( rt : hxsl.RuntimeShader ) {
		var buf = shaderBuffers;
		buf.grow(rt);
		fillGlobals(buf, rt);
		engine.uploadShaderBuffers(buf, Globals);
		fillParams(buf, rt, computeLink, true);
		engine.uploadInstanceShaderBuffers(buf);
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

	public function getDepthClearValue() : Float {
		return useReverseDepth ? 0.0 : 1.0;
	}

	public function selectTextureHandles(handles : Array<h3d.mat.TextureHandle>, markVisible = true) {
		if( markVisible ) {
			for( h in handles ) {
				var t = h.texture;
				if( t != null && t.flags.has(Streamed) ) t.markVisible();
			}
		}
		engine.driver.selectTextureHandles(handles);
	}

	/**
		Returns the GPU feedback of the streamed textures visibility, or null if unsupported.
	**/
	public function getStreamingFeedback() {
		if( streamingFeedback == null && StreamingFeedback.ENABLED ) {
			if( !engine.driver.hasFeature(Bindless) )
				StreamingFeedback.ENABLED = false
			else {
				streamingFeedback = new StreamingFeedback();
				streamingFeedback.begin();
			}
		}
		return streamingFeedback;
	}

	public function selectBufferHandles(handles : Array<h3d.BufferHandle>) {
		engine.driver.selectBufferHandles(handles);
	}

	public function uploadParams() {
		currentObject = drawPass.obj;
		fillParams(shaderBuffers, drawPass.shader, drawPass.shaders);
		currentObject = null;
		engine.uploadInstanceShaderBuffers(shaderBuffers);
	}

	override function markTextureVisible( t : Texture ) {
		var obj = currentObject;
		if( obj != null && visibilityFrustum != null ) {
			if( obj != visibilityObject || visibilityFrustum != visibilityObjectFrustum ) {
				visibilityObject = obj;
				visibilityObjectFrustum = visibilityFrustum;
				objectVisible = intersectsFrustum(obj, visibilityFrustum);
			}
			if( !objectVisible )
				return;
		}
		t.markVisible();
	}

	function intersectsFrustum( obj : Object, frustum : Frustum ) {
		var mesh = Std.downcast(obj, Mesh);
		if( mesh == null || mesh.primitive == null )
			return true;
		var b = mesh.primitive.getBounds();
		if( b == null || b.isEmpty() )
			return true;
		var m = @:privateAccess obj.absPos;
		var cx = (b.xMin + b.xMax) * 0.5, cy = (b.yMin + b.yMax) * 0.5, cz = (b.zMin + b.zMax) * 0.5;
		var sx = m._11 * m._11 + m._12 * m._12 + m._13 * m._13;
		var sy = m._21 * m._21 + m._22 * m._22 + m._23 * m._23;
		var sz = m._31 * m._31 + m._32 * m._32 + m._33 * m._33;
		var scaleSq = sx > sy ? (sx > sz ? sx : sz) : (sy > sz ? sy : sz);
		var dx = b.xMax - b.xMin, dy = b.yMax - b.yMin, dz = b.zMax - b.zMin;
		var s = visibilitySphere;
		s.x = cx * m._11 + cy * m._21 + cz * m._31 + m._41;
		s.y = cx * m._12 + cy * m._22 + cz * m._32 + m._42;
		s.z = cx * m._13 + cy * m._23 + cz * m._33 + m._43;
		s.r = Math.sqrt((dx * dx + dy * dy + dz * dz) * 0.25 * scaleSq);
		return frustum.hasSphere(s);
	}

	public function done() {
		drawPass = null;
		visibilityObject = null;
		if( streamingFeedback != null ) streamingFeedback.end();
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
		passes.resize(0);
		lights = null;

		cameraFrustumUploaded = false;

		cameraPrevPos.load(cameraPos);
		cameraPrevView.load(cameraView);
		cameraPrevProj.load(cameraProj);
		cameraPreviousViewProj.load(cameraViewProj);
		computeVelocity = false;
		cameraJitterOffsets.set(0, 0, 0, 0);
		prevWorldDelta = null;

		clearCurrent();
	}

	override public function dispose() {
		super.dispose();
		if( streamingFeedback != null ) {
			streamingFeedback.dispose();
			streamingFeedback = null;
		}
		if ( cameraFrustumBuffer != null ) {
			hxd.impl.Allocator.get().disposeBuffer( cameraFrustumBuffer );
			cameraFrustumBuffer = null;
		}
	}

}
