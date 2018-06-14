package h3d.mat;

class PbrMaterialSetup extends MaterialSetup {

	public function new(?name="PBR") {
		super(name);
	}

	function createEnv() {
		var envMap = new h3d.mat.Texture(4,4,[Cube]);
		var pix = hxd.Pixels.alloc(envMap.width, envMap.height, RGBA);
		var COLORS = [0xC08080,0xA08080,0x80C080,0x80A080,0x8080C0,0x808080];
		for( i in 0...6 ) {
			pix.clear(COLORS[i]);
			envMap.uploadPixels(pix,0,i);
		}
		var env = new h3d.scene.pbr.Environment(envMap);
		env.compute();
		return env;
	}

	override function createRenderer() : h3d.scene.Renderer {
		#if js
		// fallback to default renderer (prevent errors)
		if( !h3d.Engine.getCurrent().driver.hasFeature(ShaderModel3) ) {
			js.Browser.console.log("Could not initialize PBR Driver: WebGL2 required");
			return super.createRenderer();
		}
		#end
		return new h3d.scene.pbr.Renderer(createEnv());
	}

	override function createLightSystem() {
		return new h3d.scene.pbr.LightSystem();
	}

	override function createMaterial() : Material {
		return @:privateAccess new PbrMaterial();
	}

}