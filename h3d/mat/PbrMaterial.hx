package h3d.mat;

@:enum abstract PbrMode(String) {
	var PBR = "PBR";
	var Albedo = "Albedo";
	var Overlay = "Overlay";
	var Decal = "Decal";
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
	@:optional var alphaKill : Bool;
	@:optional var emissive : Float;
	@:optional var parallax : Float;
}

class PbrMaterial extends Material {

	override function set_blendMode(b:BlendMode) {
		if( mainPass != null ) {
			mainPass.setBlendMode(b);
			mainPass.depthWrite = b == None;
		}
		return this.blendMode = b;
	}

	override function set_receiveShadows(b) {
		// don't add shadows shader here, we are not in forward
		return receiveShadows = b;
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
			};
		case "ui":
			props = {
				mode : Overlay,
				blend : Alpha,
				shadows : false,
				culling : false,
				alphaKill : true,
			};
		case "decal":
			props = {
				mode : Decal,
				blend : Alpha,
				shadows : false,
				culling : true,
			};
		default:
			props = {
				mode : PBR,
				blend : None,
				shadows : true,
				culling : true,
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
		case Decal:
			mainPass.setPassName("decal");
			var vd = mainPass.getShader(h3d.shader.VolumeDecal);
			if( vd == null ) {
				vd = new h3d.shader.VolumeDecal(1,1);
				vd.setPriority(-1);
				mainPass.addShader(vd);
			}
			var sv = mainPass.getShader(h3d.shader.pbr.StrengthValues);
			if( sv == null ) {
				sv = new h3d.shader.pbr.StrengthValues();
				mainPass.addShader(sv);
			}
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
		shadows = props.shadows;
		if( shadows ) getPass("shadow").culling = mainPass.culling;

		// get values from specular texture
		var emit = props.emissive == null ? 0 : props.emissive;
		var tex = mainPass.getShader(h3d.shader.pbr.PropsTexture);
		var def = mainPass.getShader(h3d.shader.pbr.PropsValues);
		if( tex == null && def == null ) {
			def = new h3d.shader.pbr.PropsValues();
			mainPass.addShader(def);
		}
		if( tex != null ) tex.emissive = emit;
		if( def != null ) def.emissive = emit;

		// parallax
		var ps = mainPass.getShader(h3d.shader.Parallax);
		if( props.parallax > 0 ) {
			if( ps == null ) {
				ps = new h3d.shader.Parallax();
				mainPass.addShader(ps);
			}
			ps.amount = props.parallax;
			ps.heightMap = specularTexture;
			ps.heightMapChannel = A;
		} else if( ps != null )
			mainPass.removeShader(ps);
	}

	override function get_specularTexture() {
		var spec = mainPass.getShader(h3d.shader.pbr.PropsTexture);
		return spec == null ? null : spec.texture;
	}

	override function set_specularTexture(t) {
		if( specularTexture == t )
			return t;
		var props : PbrProps = props;
		var emit = props == null || props.emissive == null ? 0 : props.emissive;
		var spec = mainPass.getShader(h3d.shader.pbr.PropsTexture);
		var def = mainPass.getShader(h3d.shader.pbr.PropsValues);
		if( t != null ) {
			if( spec == null ) {
				spec = new h3d.shader.pbr.PropsTexture();
				spec.emissive = emit;
				mainPass.addShader(spec);
			}
			spec.texture = t;
			if( def != null )
				mainPass.removeShader(def);
		} else {
			mainPass.removeShader(spec);
			// default values (if no texture)
			if( def == null ) {
				def = new h3d.shader.pbr.PropsValues();
				def.emissive = emit;
				mainPass.addShader(def);
			}
		}


		// parallax
		var ps = mainPass.getShader(h3d.shader.Parallax);
		if( ps != null ) {
			ps.heightMap = t;
			ps.heightMapChannel = A;
			mainPass.removeShader(ps);
			mainPass.addShader(ps);
		}

		return t;
	}

	override function clone( ?m : BaseMaterial ) : BaseMaterial {
		var m = m == null ? new PbrMaterial() : cast m;
		super.clone(m);
			return m;
	}

	#if js
	override function editProps() {
		var props : PbrProps = props;
		if( props.emissive == 0 ) Reflect.deleteField(props,"emissive");
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
				<dt>Emissive</dt><dd><input type="range" min="0" max="10" field="emissive"/></dd>
				<dt>Parallax</dt><dd><input type="range" min="0" max="1" field="parallax"/></dd>
				<dt>Shadows</dt><dd><input type="checkbox" field="shadows"/></dd>
				<dt>Culled</dt><dd><input type="checkbox" field="culling"/></dd>
				<dt>AlphaKill</dt><dd><input type="checkbox" field="alphaKill"/></dd>
			</dl>
		');
	}
	#end

}