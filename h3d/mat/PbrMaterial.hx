package h3d.mat;

@:enum abstract PbrMode(String) {
	var PBR = "PBR";
	var Albedo = "Albedo";
	var Overlay = "Overlay";
}

@:enum abstract PbrBlend(String) {
	var None = "None";
	var Alpha = "Alpha";
	var Add = "Add";
	var AlphaAdd = "AlphaAdd";
}

typedef PbrProps = {
	var mode : PbrMode;
	var blend : PbrBlend;
	var shadows : Bool;
	var culling : Bool;
	var alphaKill : Bool;
}

class PbrMaterial extends Material {

	override function set_blendMode(b:BlendMode) {
		if( mainPass != null ) {
			mainPass.setBlendMode(b);
			mainPass.depthWrite = b == None;
		}
		return this.blendMode = b;
	}

	override function getDefaultProps( ?type : String ) : Any {
		var props : PbrProps;
		switch( type ) {
		case "particles3D", "trail3D":
			props = {
				mode : PBR,
				blend : Alpha,
				shadows : false,
				culling : false,
				alphaKill : false,
			};
		case "ui":
			props = {
				mode : Overlay,
				blend : Alpha,
				shadows : false,
				culling : false,
				alphaKill : true,
			};
		default:
			props = {
				mode : PBR,
				blend : None,
				shadows : true,
				culling : true,
				alphaKill : false,
			};
		}
		return props;
	}

	override function getDefaultModelProps() : Any {
		var props : PbrProps = getDefaultProps();
		props.blend = switch( blendMode ) {
		case None: None;
		case Alpha: Alpha;
		case Add: Add;
		default: throw "Unsupported Model blendMode "+blendMode;
		}
		return props;
	}

	override function refreshProps() {
		var props : PbrProps = props;
		switch( props.mode ) {
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
		case AlphaAdd:
			mainPass.setBlendMode(AlphaAdd);
			mainPass.depthWrite = false;
		}
		var tshader = textureShader;
		if( tshader != null ) {
			tshader.killAlpha = props.alphaKill;
			tshader.killAlphaThreshold = 0.5;
		}
		mainPass.culling = props.culling ? Back : None;
		shadows = false;
		castShadows = props.shadows;
		if( castShadows ) getPass("shadow").culling = mainPass.culling;

		// get values from specular texture
		var spec = mainPass.getShader(h3d.shader.pbr.PropsTexture);
		var def = mainPass.getShader(h3d.shader.pbr.PropsValues);
		if( specularTexture != null ) {
			if( spec == null ) {
				spec = new h3d.shader.pbr.PropsTexture();
				mainPass.addShader(spec);
			}
			spec.texture = specularTexture;
			if( def != null )
				mainPass.removeShader(def);
		} else {
			mainPass.removeShader(spec);
			// default values (if no texture)
			if( def == null ) {
				def = new h3d.shader.pbr.PropsValues();
				mainPass.addShader(def);
			}
		}

	}

	override function clone( ?m : BaseMaterial ) : BaseMaterial {
		var m = m == null ? new PbrMaterial() : cast m;
		super.clone(m);
			return m;
	}

	#if js
	override function editProps() {
		var props : PbrProps = props;
		return new js.jquery.JQuery('
			<dl>
				<dt>Mode</dt>
				<dd>
					<select field="mode">
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
						<option value="AlphaAdd">AlphaAdd</option>
					</select>
				</dd>
				<dt>Shadows</dt><dd><input type="checkbox" field="shadows"/></dd>
				<dt>Culled</dt><dd><input type="checkbox" field="culling"/></dd>
				<dt>AlphaKill</dt><dd><input type="checkbox" field="alphaKill"/></dd>
			</dl>
		');
	}
	#end

}