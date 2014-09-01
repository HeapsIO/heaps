package h3d.pass;

@:build(hxsl.Macros.buildGlobals())
@:access(h3d.scene.Light)
class LightSystem {

	public var maxLightsPerObject = 6;
	var globals : hxsl.Globals;
	var lights : h3d.scene.Light;
	var ambientShader : h3d.shader.AmbientLight;
	var lightCount : Int;
	var cachedShaderList : Array<hxsl.ShaderList>;
	var cachedPos : Int;
	@global("global.ambientLight") public var ambientLight : h3d.Vector;
	@global("global.perPixelLighting") public var perPixelLighting : Bool;

	public function new(globals) {
		this.globals = globals;
		initGlobals();
		cachedShaderList = [];
		ambientLight = new h3d.Vector(0.5, 0.5, 0.5);
		ambientShader = new h3d.shader.AmbientLight();
	}

	public function initLights( lights : h3d.scene.Light ) {
		this.lights = lights;
		lightCount = 0;
		cachedPos = 0;
		var l = lights;
		while( l != null ) {
			lightCount++;
			l.objectDistance = 0.;
			l = l.next;
		}
		if( lightCount <= maxLightsPerObject )
			this.lights = haxe.ds.ListSort.sortSingleLinked(lights, sortLight);
		setGlobals();
	}

	function sortLight( l1 : h3d.scene.Light, l2 : h3d.scene.Light ) {
		var p = l1.priority - l2.priority;
		if( p != 0 ) return -p;
		return l1.objectDistance < l2.objectDistance ? -1 : 1;
	}

	@:access(h3d.scene.Object.absPos)
	public function computeLight( obj : h3d.scene.Object, shaders : hxsl.ShaderList ) : hxsl.ShaderList {
		if( lightCount > maxLightsPerObject ) {
			var l = lights;
			while( l != null ) {
				l.objectDistance = hxd.Math.distanceSq(l.absPos._41 - obj.absPos._41, l.absPos._42 - obj.absPos._42, l.absPos._43 - obj.absPos._43);
				l = l.next;
			}
			lights = haxe.ds.ListSort.sortSingleLinked(lights, sortLight);
		}
		inline function add( s : hxsl.Shader ) {
			var sl = cachedShaderList[cachedPos++];
			if( sl == null ) {
				sl = new hxsl.ShaderList(null);
				cachedShaderList[cachedPos - 1] = sl;
			}
			sl.s = s;
			sl.next = shaders;
			shaders = sl;
		}
		add(ambientShader);
		var l = lights;
		var i = 0;
		while( l != null ) {
			if( i++ == maxLightsPerObject ) break;
			add(l.shader);
			l = l.next;
		}
		return shaders;
	}

}