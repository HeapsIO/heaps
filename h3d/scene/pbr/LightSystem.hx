package h3d.scene.pbr;

@:access(h3d.scene.pbr.Light)
class LightSystem extends h3d.scene.LightSystem {

	public function init( r : h3d.scene.Renderer ) {
		this.ctx = @:privateAccess r.ctx;
	}

	override function computeLight( obj : h3d.scene.Object, shaders : hxsl.ShaderList ) : hxsl.ShaderList {
		var light = Std.instance(obj, h3d.scene.pbr.Light);
		if( light != null ) {
			shaders = ctx.allocShaderList(light.shader, shaders);
			if( light.shadows.shader != null && light.shadows.mode != None ){

				var pointShadow = Std.instance(light.shadows.shader, h3d.shader.PointShadow );
				if(pointShadow != null && pointShadow.shadowMap == null){
					throw "Rendering a pbr pointlight with shadows, without the shadowMap";
					return shaders;
				}

				var dirShadow = Std.instance(light.shadows.shader, h3d.shader.DirShadow );
				if(dirShadow != null && dirShadow.shadowMap == null){
					throw "Rendering a pbr dirLight with shadows, without the shadowMap";
					return shaders;
				}

				var spotShadow = Std.instance(light.shadows.shader, h3d.shader.SpotShadow );
				if(spotShadow != null && spotShadow.shadowMap == null){
					throw "Rendering a pbr spotLight with shadows, without the shadowMap";
					return shaders;
				}

				shaders = ctx.allocShaderList(light.shadows.shader, shaders);
			}
		}
		return shaders;
	}

	public function drawScreenLights( r : h3d.scene.Renderer, lightPass : h3d.pass.ScreenFx<Dynamic> ) {
		var plight = @:privateAccess ctx.lights;
		var currentTarget = ctx.engine.getCurrentTarget();
		var width = currentTarget == null ? ctx.engine.width : currentTarget.width;
		var height = currentTarget == null ? ctx.engine.height : currentTarget.height;
		while( plight != null ) {
			var light = Std.instance(plight, h3d.scene.pbr.Light);
			if( light != null && light.primitive == null ) {
				if( light.shadows.shader != null ) lightPass.addShader(light.shadows.shader);
				lightPass.addShader(light.shader);
				lightPass.render();
				lightPass.removeShader(light.shader);
				if( light.shadows.shader != null ) lightPass.removeShader(light.shadows.shader);
			}
			plight = plight.next;
		}
	}
}
