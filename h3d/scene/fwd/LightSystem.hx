package h3d.scene.fwd;

class LightSystem extends h3d.scene.LightSystem {

	public var maxLightsPerObject = 6;
	var globals : hxsl.Globals;
	var ambientShader : hxsl.Shader;
	var lightCount : Int;
	public var perPixelLighting : Bool = true;
	public var ambientLight(default,null) : h3d.Vector;

	/**
		In the additive lighting model (by default), the lights are added after the ambient.
		In the new non additive ligthning model, the lights will be modulated against the ambient, so an ambient of 1 will reduce lights intensities to 0.
	**/
	public var additiveLighting(get, set) : Bool;

	public function new() {
		super();
		ambientLight = new h3d.Vector(0.5, 0.5, 0.5);
		ambientShader = new h3d.shader.AmbientLight();
		additiveLighting = true;
	}

	function get_additiveLighting() {
		return hxd.impl.Api.downcast(ambientShader,h3d.shader.AmbientLight).additive;
	}

	function set_additiveLighting(b) {
		return hxd.impl.Api.downcast(ambientShader,h3d.shader.AmbientLight).additive = b;
	}

	override function initLights(ctx) {
		lightCount = 0;
		this.ctx = ctx;
		cullLights();
		super.initLights(ctx);
		if( lightCount <= maxLightsPerObject )
			@:privateAccess ctx.lights = haxe.ds.ListSort.sortSingleLinked(ctx.lights, cast sortLight);
	}

	override function initGlobals( globals : hxsl.Globals ) {
		globals.set("global.ambientLight", ambientLight);
		globals.set("global.perPixelLighting", perPixelLighting);
	}

	function cullLights() @:privateAccess  {
		// remove lights which cullingDistance is outside of frustum
		var ll = ctx.lights, prev : h3d.scene.Light = null;
		var s = new h3d.col.Sphere();
		while( ll != null ) {
			var l = Std.downcast(ll, h3d.scene.fwd.Light);
			if( l != null ) {
				s.x = l.absPos._41;
				s.y = l.absPos._42;
				s.z = l.absPos._43;
				s.r = l.cullingDistance;
			}
			if( l == null || (l.cullingDistance > 0 && !ctx.computingStatic && !ctx.camera.frustum.hasSphere(s)) ) {
				if( prev == null )
					ctx.lights = ll.next;
				else
					prev.next = ll.next;
				ll = ll.next;
				continue;
			}

			lightCount++;
			l.objectDistance = 0.;
			prev = ll;
			ll = ll.next;
		}
	}

	function sortLight( l1 : h3d.scene.fwd.Light, l2 : h3d.scene.fwd.Light ) {
		var p = l1.priority - l2.priority;
		if( p != 0 ) return -p;
		return @:privateAccess (l1.objectDistance < l2.objectDistance ? -1 : 1);
	}

	override function computeLight( obj : h3d.scene.Object, shaders : hxsl.ShaderList ) : hxsl.ShaderList @:privateAccess {
		if( lightCount > maxLightsPerObject ) {
			var ll = ctx.lights;
			while( ll != null ) {
				var l = Std.downcast(ll, h3d.scene.fwd.Light);
				if( obj.lightCameraCenter )
					l.objectDistance = hxd.Math.distanceSq(l.absPos._41 - ctx.camera.target.x, l.absPos._42 - ctx.camera.target.y, l.absPos._43 - ctx.camera.target.z);
				else
					l.objectDistance = hxd.Math.distanceSq(l.absPos._41 - obj.absPos._41, l.absPos._42 - obj.absPos._42, l.absPos._43 - obj.absPos._43);
				ll = ll.next;
			}
			ctx.lights = haxe.ds.ListSort.sortSingleLinked(ctx.lights, cast sortLight);
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