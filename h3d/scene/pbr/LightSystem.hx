package h3d.scene.pbr;

@:access(h3d.scene.pbr.Light)
class LightSystem extends h3d.scene.LightSystem {

	var lightPass : h3d.pass.ScreenFx<h3d.shader.pbr.PropsImport>;
	var initDone = false;

	override function computeLight( obj : h3d.scene.Object, shaders : hxsl.ShaderList ) : hxsl.ShaderList {
		var light = Std.instance(obj, h3d.scene.pbr.Light);
		if( light != null )
			return ctx.allocShaderList(light.shader, shaders);
		return shaders;
	}

	public function drawLights( r : Renderer ) {

		if( lightPass == null ) {
			initDone = true;
			lightPass = new h3d.pass.ScreenFx(r.pbrProps);
			lightPass.addShader(r.pbrDirect);
			@:privateAccess lightPass.pass.setBlendMode(Add);
		}

		var light = @:privateAccess ctx.lights;
		var currentTarget = ctx.engine.getCurrentTarget();
		var width = currentTarget == null ? ctx.engine.width : currentTarget.width;
		var height = currentTarget == null ? ctx.engine.height : currentTarget.height;
		while( light != null ) {
			if( light != shadowLight ) {
				var light = Std.instance(light, h3d.scene.pbr.Light);
				if( light != null /*&& light.primitive == null*/ ) {
					lightPass.addShader(light.shader);
					lightPass.render();
					lightPass.removeShader(light.shader);
				}
			}
			light = light.next;
		}
	}
}
