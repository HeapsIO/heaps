package h3d.pass;

enum RenderMode {
	None;
	Static;
	Dynamic;
	Mixed;
}

enum ShadowSamplingKind {
		None;
		PCF;
		ESM;
	}

class Shadows extends Default {

	var lightCamera : h3d.Camera;
	var format : hxd.PixelFormat;
	var staticTexture : h3d.mat.Texture;
	var light : h3d.scene.Light;
	public var enabled(default,set) : Bool = true;
	public var mode(default,set) : RenderMode = None;
	public var size(default,set) : Int = 1024;
	public var shader(default,null) : hxsl.Shader;
	public var blur : Blur;

	public var samplingKind : ShadowSamplingKind = None;
	public var power = 30.0;
	public var bias = 0.01;
	public var pcfQuality = 1;
	public var pcfScale = 1.0;

	public function new(light) {
		if( format == null ) format = R16F;
		if( !h3d.Engine.getCurrent().driver.isSupportedFormat(format) ) format = h3d.mat.Texture.nativeFormat;
		super("shadow");
		this.light = light;
		blur = new Blur(5);
		blur.quality = 0.5;
		blur.shader.isDepth = format == h3d.mat.Texture.nativeFormat;
	}

	function set_mode(m:RenderMode) {
		if( m != None ) throw "Shadow mode "+m+" not supported for "+light;
		return mode = m;
	}

	function set_enabled(b:Bool) {
		return enabled = b;
	}

	function set_size(s) {
		if( s != size && staticTexture != null ) {
			staticTexture.dispose();
			staticTexture = null;
		}
		return size = s;
	}

	override function dispose() {
		super.dispose();
		blur.dispose();
		// don't set to null
		if( staticTexture != null ) staticTexture.dispose();
	}

	public function getShadowProj() {
		return lightCamera.m;
	}

	public function getShadowTex() : h3d.mat.Texture {
		return null;
	}

	function isUsingWorldDist(){
		return false;
	}

	override function getOutputs() : Array<hxsl.Output> {
		if(isUsingWorldDist())
			return [Swiz(Value("output.worldDist",1),[X,X,X,X])];

		if( format == h3d.mat.Texture.nativeFormat )
			return [PackFloat(Value("output.depth"))];
		return [Swiz(Value("output.depth",1),[X,X,X,X])];
	}

	public function loadStaticData( bytes : haxe.io.Bytes ) {
		return false;
	}

	public function saveStaticData() : haxe.io.Bytes {
		return null;
	}

	public function computeStatic( passes : h3d.pass.PassList ) {
		throw "Not implemented";
	}

	function createDefaultShadowMap() {
		var tex = h3d.mat.Texture.fromColor(0xFFFFFF);
		tex.name = "defaultShadowMap";
		return tex;
	}

	function syncShader( texture : h3d.mat.Texture ) {
	}

	function filterPasses( passes : h3d.pass.PassList ) {
		if( !ctx.computingStatic ) {
			switch( mode ) {
				case None:
					return false;
				case Dynamic:
					return true;
				case Mixed:
					if( staticTexture == null || staticTexture.isDisposed() )
						staticTexture = createDefaultShadowMap();
					return true;
				case Static:
					if( staticTexture == null || staticTexture.isDisposed() )
						staticTexture = createDefaultShadowMap();
					syncShader(staticTexture);
					return false;
			}
		}
		else {
			switch( mode ) {
				case None:
					return false;
				case Dynamic:
					return false;
				case Mixed:
					passes.filter(function(p) return p.pass.isStatic == true);
					return true;
				case Static:
					passes.filter(function(p) return p.pass.isStatic == true);
					return true;
			}
		}
	}

	inline function cullPasses( passes : h3d.pass.PassList, f : h3d.col.Collider -> Bool ) {
		var prevCollider = null;
		var prevResult = true;
		passes.filter(function(p) {
			var col = p.obj.cullingCollider;
			if( col == null )
				return true;
			if( col != prevCollider ) {
				prevCollider = col;
				prevResult = f(col);
			}
			return prevResult;
		});
	}

}