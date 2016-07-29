package h3d.mat;

enum MaterialKind {
	Opaque;
	Alpha;
	AlphaKill;
	Add;
	SoftAdd;
}

enum ShadowsMode {
	None;
	Active;
	CastOnly;
	ReceiveOnly;
}

@:structInit
class DefaultMaterialProps {

	public var kind(default,null) : MaterialKind;
	public var shadows(default, null) : ShadowsMode;
	public var cull(default, null) : Bool;

	public function new( ?kind : MaterialKind, ?shadows : ShadowsMode, ?cull : Bool ) {
		this.kind = kind == null ? Opaque : kind;
		this.shadows = shadows == null ? Active : shadows;
		this.cull = cull == null ? true : cull;
	}

	public function apply( m : Material ) {
		var mainPass = m.mainPass;
		switch( kind ) {
		case Opaque, AlphaKill:
			mainPass.setBlendMode(None);
			mainPass.depthWrite = true;
			mainPass.setPassName("default");
		case Alpha:
			mainPass.setBlendMode(Alpha);
			mainPass.depthWrite = true;
			mainPass.setPassName("alpha");
		case Add:
			mainPass.setBlendMode(Add);
			mainPass.depthWrite = false;
			mainPass.setPassName("additive");
		case SoftAdd:
			mainPass.setBlendMode(SoftAdd);
			mainPass.depthWrite = false;
			mainPass.setPassName("additive");
		}
		var tshader = mainPass.getShader(h3d.shader.Texture);
		if( tshader != null ) {
			tshader.killAlpha = kind == AlphaKill;
			tshader.killAlphaThreshold = 0.5;
		}
		switch( shadows ) {
		case None:
			m.shadows = false;
		case Active:
			m.shadows = true;
		case CastOnly:
			m.castShadows = true;
			m.receiveShadows = false;
		case ReceiveOnly:
			m.castShadows = false;
			m.receiveShadows = true;
		}
		mainPass.culling = cull ? Back : None;
	}

	public function inspect( onChange : Void -> Void ) : Array<hxd.inspect.Property> {
		return [
			PEnum("kind", MaterialKind, function() return kind, function(v) { kind = v; onChange(); }),
			PEnum("shadows", ShadowsMode, function() return shadows, function(v) { shadows = v; onChange(); }),
			PBool("cull", function() return cull, function(v) { cull = v; onChange(); }),
		];
	}

	public function getData() : Dynamic {
		return { kind : kind.getName(), shadows : shadows.getName(), cull : cull };
	}

	public function loadData( o : Dynamic ) {
		kind = MaterialKind.createByName(o.kind);
		shadows = ShadowsMode.createByName(o.shadows);
		cull = o.cull;
	}

	public static function particlesDefault() : MaterialProps {
		return { kind : Alpha, shadows : None, cull : false }
	}

}
