package h3d.scene;

class LightSystem {

	public var drawPasses : Int = 0;
	public var ambientLight(default,null) : h3d.Vector;
	public var shadowLight : h3d.scene.Light;

	var lightCount : Int;
	var ctx : RenderContext;

	public function new() {
		ambientLight = new h3d.Vector(1,1,1);
	}

	public function initGlobals( globals : hxsl.Globals ) {
	}

	function cullLights() @:privateAccess  {
		// remove lights which cullingDistance is outside of frustum
		var l = ctx.lights, prev : h3d.scene.Light = null;
		var s = new h3d.col.Sphere();
		while( l != null ) {
			s.x = l.absPos._41;
			s.y = l.absPos._42;
			s.z = l.absPos._43;
			s.r = l.cullingDistance;

			if( l.cullingDistance > 0 && !ctx.computingStatic && !ctx.camera.frustum.hasSphere(s) ) {
				if( prev == null )
					ctx.lights = l.next;
				else
					prev.next = l.next;
				l = l.next;
				continue;
			}

			lightCount++;
			l.objectDistance = 0.;
			prev = l;
			l = l.next;
		}
	}

	public function initLights( ctx : h3d.scene.RenderContext ) @:privateAccess {
		lightCount = 0;
		this.ctx = ctx;
		cullLights();
		if( shadowLight == null || !shadowLight.allocated) {
			var l = ctx.lights;
			while( l != null ) {
				var dir = l.getShadowDirection();
				if( dir != null ) {
					shadowLight = l;
					break;
				}
				l = l.next;
			}
		}
	}

	public function computeLight( obj : h3d.scene.Object, shaders : hxsl.ShaderList ) : hxsl.ShaderList {
		return shaders;
	}

}