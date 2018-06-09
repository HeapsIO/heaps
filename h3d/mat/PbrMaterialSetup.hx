package h3d.mat;

@:enum private abstract DefaultKind(String) {
	var PBR = "PBR";
	var Albedo = "Albedo";
	var Overlay = "Overlay";
}

@:enum private abstract DefaultBlend(String) {
	var None = "None";
	var Alpha = "Alpha";
	var Add = "Add";
}

private typedef DefaultProps = {
	var kind : DefaultKind;
	var blend : DefaultBlend;
	var shadows : Bool;
	var alphaKill : Bool;
	var culled : Bool;
}

class PbrMaterialSetup extends MaterialSetup {

	public var irrad(get,set) : h3d.scene.pbr.Irradiance;

	public function new(?name="PBR") {
		super(name);
	}

	function get_irrad() : h3d.scene.pbr.Irradiance {
		return @:privateAccess h3d.Engine.getCurrent().resCache.get(h3d.scene.pbr.Irradiance);
	}

	function set_irrad( i : h3d.scene.pbr.Irradiance ) {
		var cache = @:privateAccess h3d.Engine.getCurrent().resCache;
		if( i == null )
			cache.remove(h3d.scene.pbr.Irradiance);
		else
			cache.set(h3d.scene.pbr.Irradiance, i);
		return i;
	}

	override function createRenderer() : h3d.scene.Renderer {
		var irrad = irrad;
		if( irrad == null ) {
			var envMap = new h3d.mat.Texture(4,4,[Cube]);
			var pix = hxd.Pixels.alloc(envMap.width, envMap.height, RGBA);
			var COLORS = [0xC08080,0xA08080,0x80C080,0x80A080,0x8080C0,0x808080];
			for( i in 0...6 ) {
				pix.clear(COLORS[i]);
				envMap.uploadPixels(pix,0,i);
			}
			irrad = new h3d.scene.pbr.Irradiance(envMap);
			irrad.compute();
			this.irrad = irrad;
		}
		return new h3d.scene.pbr.Renderer(irrad);
	}

	override function createLightSystem() {
		return new h3d.scene.pbr.LightSystem();
	}

	override function initModelMaterial( material : Material ) {
		var props = database.loadProps(material, this);
		if( props == null ) {
			props = getDefaults();
			// use hmd material
			var props : DefaultProps = props;
			// TODO : handle HMD alpha correctly
		}
		material.props = props;
	}

	override function getDefaults( ?type : String ) : Any {
		var props : DefaultProps;
		switch( type ) {
		case "ui":
			props = {
				kind : Overlay,
				blend : Alpha,
				shadows : false,
				culled : false,
				alphaKill : true,
			};
		default:
			props = {
				kind : PBR,
				blend : None,
				shadows : true,
				culled : true,
				alphaKill : false,
			};
		}
		return props;
	}

	override function applyProps( m : Material ) {
		var props : DefaultProps = m.props;
		var mainPass = m.mainPass;
		switch( props.kind ) {
		case PBR:
			mainPass.setPassName("default");
		case Albedo:
			mainPass.setPassName("albedo");
		case Overlay:
			mainPass.setPassName("overlay");
		}
		switch( props.blend ) {
		case None:
			mainPass.setBlendMode(None);
			mainPass.depthWrite = true;
		case Alpha:
			mainPass.setBlendMode(Alpha);
			mainPass.depthWrite = false;
		case Add:
			mainPass.setBlendMode(Add);
			mainPass.depthWrite = false;
		}
		var tshader = m.textureShader;
		if( tshader != null ) {
			tshader.killAlpha = props.alphaKill;
			tshader.killAlphaThreshold = 0.5;
		}
		mainPass.culling = props.culled ? Back : None;
		m.shadows = false;
		if( m.shadows ) m.getPass("shadow").culling = mainPass.culling;
		m.castShadows = props.shadows;

		// get values from specular texture
		var spec = m.mainPass.getShader(h3d.shader.pbr.PropsTexture);
		var def = m.mainPass.getShader(h3d.shader.pbr.PropsValues);
		if( m.specularTexture != null ) {
			if( spec == null ) {
				spec = new h3d.shader.pbr.PropsTexture();
				m.mainPass.addShader(spec);
			}
			spec.texture = m.specularTexture;
			if( def != null )
				m.mainPass.removeShader(def);
		} else {
			m.mainPass.removeShader(spec);
			// default values (if no texture)
			if( def == null ) {
				def = new h3d.shader.pbr.PropsValues();
				m.mainPass.addShader(def);
			}
		}

	}

	#if js
	override function editMaterial( props : Any ) {
		var props : DefaultProps = props;
		return new js.jquery.JQuery('
			<dl>
				<dt>Kind</dt>
				<dd>
					<select field="kind">
						<option value="PBR">PBR</option>
						<option value="Albedo">Albedo</option>
						<option value="Overlay">Overlay</option>
					</select>
				</dd>
				<dt>Blend</dt>
				<dd>
					<select field="blend">
						<option value="None">None</option>
						<option value="Alpha">Alpha</option>
						<option value="Add">Add</option>
					</select>
				</dd>
				<dt>Shadows</dt><dd><input type="checkbox" field="shadows"/></dd>
				<dt>Culled</dt><dd><input type="checkbox" field="culled"/></dd>
				<dt>AlphaKill</dt><dd><input type="checkbox" field="alphaKill"/></dd>
			</dl>
		');
	}
	#end

}