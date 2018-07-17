package h3d.scene.pbr;

@:access(h3d.scene.pbr.Light)
class LightSystem extends h3d.scene.LightSystem {

	override function computeLight( obj : h3d.scene.Object, shaders : hxsl.ShaderList ) : hxsl.ShaderList {
		var light = Std.instance(obj, h3d.scene.pbr.Light);
		if( light != null ) {
			if( light.shadows != null )
				shaders = ctx.allocShaderList(light.shadows, shaders);
			return ctx.allocShaderList(light.shader, shaders);
		}
		return shaders;
	}

	public function drawLights( r : h3d.scene.Renderer, lightPass : h3d.pass.ScreenFx<Dynamic> ) {
		var light = @:privateAccess ctx.lights;
		var currentTarget = ctx.engine.getCurrentTarget();
		var width = currentTarget == null ? ctx.engine.width : currentTarget.width;
		var height = currentTarget == null ? ctx.engine.height : currentTarget.height;
		while( light != null ) {
			if( light != shadowLight ) {
				var light = Std.instance(light, h3d.scene.pbr.Light);
				if( light != null && light.primitive == null ) {
					if( light.shadows != null ) lightPass.addShader(light.shadows);
					lightPass.addShader(light.shader);
					lightPass.render();
					lightPass.removeShader(light.shader);
					if( light.shadows != null ) lightPass.addShader(light.shadows);
				}
			}
			light = light.next;
		}
	}
}
