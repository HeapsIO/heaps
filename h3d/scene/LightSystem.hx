package h3d.scene;

class LightSystem {

	public var drawPasses : Int = 0;
	public var shadowLight : h3d.scene.Light;

	var ctx : RenderContext;

	public function new() {
	}

	public function initGlobals( globals : hxsl.Globals ) {
	}

	public function initLights( ctx : h3d.scene.RenderContext ) @:privateAccess {
		this.ctx = ctx;
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