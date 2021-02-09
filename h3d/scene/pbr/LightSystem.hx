package h3d.scene.pbr;

@:access(h3d.scene.pbr.Light)
class LightSystem extends h3d.scene.LightSystem {

	public var lightBuffer : h3d.scene.pbr.LightBuffer;
	public var forwardMode = false;

	public function new() {
		super();
		lightBuffer = new h3d.scene.pbr.LightBuffer();
	}

	override function computeLight( obj : h3d.scene.Object, shaders : hxsl.ShaderList ) : hxsl.ShaderList {
		var light = hxd.impl.Api.downcast(obj, h3d.scene.pbr.Light);
		if( light != null ) {
			shaders = ctx.allocShaderList(light.shader, shaders);
			if( light.shadows.shader != null && light.shadows.mode != None )
				shaders = ctx.allocShaderList(light.shadows.shader, shaders);
		}
		else if( forwardMode ) {
			var found = false;
            for( s in shaders ) {
                var forward = Std.downcast(s, h3d.shader.pbr.DefaultForward);
                if( forward != null ) {
                    lightBuffer.setBuffers(forward);
                    found = true;
                    break;
                }
            }
            if( !found )
                shaders = ctx.allocShaderList(lightBuffer.defaultForwardShader, shaders);
		}
		return shaders;
	}

	override function initLights( ctx : h3d.scene.RenderContext ) @:privateAccess {
		super.initLights(ctx);
		lightBuffer.sync(ctx);
	}

	public function drawShadows( light : Light, passes : h3d.pass.PassList ) {
		light.shadows.setContext(ctx);
		light.shadows.draw(passes);
		passes.reset();
	}

	public function drawScreenLights( r : h3d.scene.Renderer, lightPass : h3d.pass.ScreenFx<Dynamic> ) {
		var plight = @:privateAccess ctx.lights;
		var currentTarget = ctx.engine.getCurrentTarget();
		var width = currentTarget == null ? ctx.engine.width : currentTarget.width;
		var height = currentTarget == null ? ctx.engine.height : currentTarget.height;
		while( plight != null ) {
			var light = hxd.impl.Api.downcast(plight, h3d.scene.pbr.Light);
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
