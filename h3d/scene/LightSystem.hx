package h3d.scene;

class LightSystem {

	public var drawPasses : Int = 0;
	public var shadowLight : h3d.scene.Light;

	var ctx : RenderContext;

	public function new() {
	}

	public function initGlobals( globals : hxsl.Globals ) {
	}

	function sortingCriteria ( l1 : Light, l2 : Light ) {
		var d1 = l1.getAbsPos().getPosition().sub(ctx.camera.target).length();
		var d2 = l2.getAbsPos().getPosition().sub(ctx.camera.target).length();
		return d1 > d2 ? 1 : -1;
	}

	public function sortLights ( ctx : h3d.scene.RenderContext ) @:privateAccess {
		var lights = [];
		var l = ctx.lights;
		if ( l == null )
			return;
		while ( l != null ) {
			lights.push(l);
			l = l.next;
		}
		lights.sort(function(l1,l2) { return sortingCriteria(l1, l2); });
		ctx.lights = lights[0];
		for (i in 0...lights.length - 1) {
			lights[i].next = lights[i + 1];
		}
		lights[lights.length-1].next = null;
	}

	public function initLights( ctx : h3d.scene.RenderContext ) @:privateAccess {
		this.ctx = ctx;
		sortLights(ctx);
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

	public function dispose(){
	}

}