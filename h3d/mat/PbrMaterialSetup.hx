package h3d.mat;

class PbrMaterialSetup extends MaterialSetup {

	public function new(?name="PBR") {
		super(name);
	}

	override function createRenderer() : h3d.scene.Renderer {
		#if js
		// fallback to default renderer (prevent errors)
		if( !h3d.Engine.getCurrent().driver.hasFeature(ShaderModel3) ) {
			js.Browser.console.log("Could not initialize PBR Driver: WebGL2 required");
			return super.createRenderer();
		}
		#end
		return new h3d.scene.pbr.Renderer(h3d.scene.pbr.Environment.getDefault());
	}

	override function createLightSystem() {
		return new h3d.scene.pbr.LightSystem();
	}

	override function createMaterial() : Material {
		return @:privateAccess new PbrMaterial();
	}

	public static function set() {
		MaterialSetup.current = new PbrMaterialSetup();
	}

}