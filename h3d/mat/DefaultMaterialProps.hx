package h3d.mat;

enum MaterialKind {
	Opaque;
	Alpha;
	AlphaKill;
	Add;
	SoftAdd;
}

@:structInit
class DefaultMaterialProps {

	public var kind(default,null) : MaterialKind;
	public var cull(default, null) : Bool;

	public function new( ?kind : MaterialKind, ?cull : Bool ) {
		this.kind = kind == null ? Opaque : kind;
		this.cull = cull == null ? true : cull;
	}

	public function apply( m : BaseMaterial ) {
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
		mainPass.culling = cull ? Back : None;
	}

	public function inspect( onChange : Void -> Void ) : Array<hxd.inspect.Property> {
		return [
			PEnum("kind", MaterialKind, function() return kind, function(v) { kind = v; onChange(); }),
			PBool("cull", function() return cull, function(v) { cull = v; onChange(); }),
		];
	}

	public function getData() : Dynamic {
		return { kind : kind.getName(), cull : cull };
	}

	public function loadData( o : Dynamic ) {
		kind = MaterialKind.createByName(o.kind);
		cull = o.cull;
	}

	public static function particlesDefault() : MaterialProps {
	#if (haxe_ver < 3.3)
		var m = new DefaultMaterialProps();
		m.kind = Alpha;
		m.cull = false;
		return m;
	#else
		return { kind : Alpha, cull : false }
	#end
	}

}
