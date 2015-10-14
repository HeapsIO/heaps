package h3d.pass;

@:access(h3d.scene.Light)
@:access(h3d.scene.Object.absPos)
@:access(h3d.scene.RenderContext.lights)
class LightSystem {

	public var maxLightsPerObject = 6;
	var globals : hxsl.Globals;
	var ambientShader : hxsl.Shader;
	var lightCount : Int;
	var ctx : h3d.scene.RenderContext;
	public var shadowLight : h3d.scene.DirLight;
	public var ambientLight : h3d.Vector;
	public var perPixelLighting : Bool = true;

	/**
		In the additive lighting model (by default), the lights are added after the ambient.
		In the new non additive ligthning model, the lights will be modulated against the ambient, so an ambient of 1 will reduce lights intensities to 0.
	**/
	public var additiveLighting(get, set) : Bool;

	public function new() {
		ambientLight = new h3d.Vector(0.5, 0.5, 0.5);
		ambientShader = new h3d.shader.AmbientLight();
		additiveLighting = true;
	}

	function get_additiveLighting() {
		return Std.instance(ambientShader,h3d.shader.AmbientLight).additive;
	}

	function set_additiveLighting(b) {
		return Std.instance(ambientShader,h3d.shader.AmbientLight).additive = b;
	}

	public function initLights( ctx : h3d.scene.RenderContext ) {
		lightCount = 0;
		this.ctx = ctx;
		var l = ctx.lights, prev = null;
		var frustum = new h3d.col.Frustum(ctx.camera.m);
		var s = new h3d.col.Sphere();
		while( l != null ) {
			s.x = l.absPos._41;
			s.y = l.absPos._42;
			s.z = l.absPos._43;
			s.r = l.cullingDistance;

			if( !frustum.checkSphere(s) ) {
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
		if( lightCount <= maxLightsPerObject )
			ctx.lights = haxe.ds.ListSort.sortSingleLinked(ctx.lights, sortLight);
		if( shadowLight == null || shadowLight.parent == null ) {
			var l = ctx.lights;
			while( l != null ) {
				var dl = Std.instance(l, h3d.scene.DirLight);
				if( dl != null ) {
					shadowLight = dl;
					break;
				}
				l = l.next;
			}
		}
	}

	public function initGlobals( globals : hxsl.Globals ) {
		globals.set("global.ambientLight", ambientLight);
		globals.set("global.perPixelLighting", perPixelLighting);
	}

	function sortLight( l1 : h3d.scene.Light, l2 : h3d.scene.Light ) {
		var p = l1.priority - l2.priority;
		if( p != 0 ) return -p;
		return l1.objectDistance < l2.objectDistance ? -1 : 1;
	}

	public function computeLight( obj : h3d.scene.Object, shaders : hxsl.ShaderList ) : hxsl.ShaderList {
		if( lightCount > maxLightsPerObject ) {
			var l = ctx.lights;
			while( l != null ) {
				if( obj.lightCameraCenter )
					l.objectDistance = hxd.Math.distanceSq(l.absPos._41 - ctx.camera.target.x, l.absPos._42 - ctx.camera.target.y, l.absPos._43 - ctx.camera.target.z);
				else
					l.objectDistance = hxd.Math.distanceSq(l.absPos._41 - obj.absPos._41, l.absPos._42 - obj.absPos._42, l.absPos._43 - obj.absPos._43);
				l = l.next;
			}
			ctx.lights = haxe.ds.ListSort.sortSingleLinked(ctx.lights, sortLight);
		}
		inline function add( s : hxsl.Shader ) {
			shaders = ctx.allocShaderList(s, shaders);
		}
		add(ambientShader);
		var l = ctx.lights;
		var i = 0;
		while( l != null ) {
			if( i++ == maxLightsPerObject ) break;
			add(l.shader);
			l = l.next;
		}
		return shaders;
	}

}