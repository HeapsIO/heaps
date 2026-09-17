package h3d.pass;

enum RenderMode {
	None;
	Static;
	Dynamic;
	Mixed;
}

// Keep in sync with h3d.shader.ShadowSampling
enum abstract ShadowSamplingKind(Int) to Int {
	var None = 0;
	var ESM = 1;
	var PCF = 2;
}

class Shadows extends Output {

	var lightCamera : h3d.Camera;
	var format : hxd.PixelFormat;
	var staticTexture : h3d.mat.Texture;
	var light : h3d.scene.Light;
	var updateStatic : Bool = false;
	public var enabled(default,set) : Bool = true;
	public var mode(default,set) : RenderMode = None;
	public var size(default,set) : Int = 1024;
	public var shader(default,null) : hxsl.Shader;
	public var blur : Blur;

	public var samplingKind : ShadowSamplingKind = None;
	public var power = 30.0;
	public var bias = 0.01;
	public var pcfScale = 1.0;

	public function new(light) {
		if( format == null ) format = R16F;
		if( !h3d.Engine.getCurrent().driver.isSupportedFormat(format) ) format = h3d.mat.Texture.nativeFormat;
		super("shadow", getOutputs());
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

	public function getShadowView() {
		return lightCamera.mcam;
	}

	public function getShadowProj() {
		return lightCamera.mproj;
	}

	public function getShadowViewProj() {
		return lightCamera.m;
	}

	public function getShadowTex() : h3d.mat.Texture {
		return null;
	}

	function isUsingWorldDist(){
		return false;
	}

	function getOutputs() : Array<hxsl.Output> {
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

	public function hasStaticShadow() {
		switch ( mode ) {
		case Mixed, Static:
			return true;
		case None, Dynamic:
			return false;
		}
	}

	/**
	 * Triggers update of static part of shadows (if any).
	**/
	public function needStaticUpdate() {
		updateStatic = hasStaticShadow();
	}

	function createDefaultShadowMap() {
		var tex = h3d.mat.Texture.fromColor(0xFFFFFF);
		tex.name = "defaultShadowMap";
		return tex;
	}

	var g : h3d.scene.Graphics;
	public var debug : Bool;

	function drawBounds(invViewModel : h3d.Matrix, color : Int) {

		inline function unproject(screenX, screenY, camZ) {
			var p = new h3d.Vector(screenX, screenY, camZ);
			p.project(invViewModel);
			return p;
		}

		var nearPlaneCorner = [unproject(-1, 1, 0), unproject(1, 1, 0), unproject(1, -1, 0), unproject(-1, -1, 0)];
		var farPlaneCorner = [unproject(-1, 1, 1), unproject(1, 1, 1), unproject(1, -1, 1), unproject(-1, -1, 1)];

		g.lineStyle(1, color);

		// Near Plane
		var last = nearPlaneCorner[nearPlaneCorner.length - 1];
		inline function moveTo(x : Float, y : Float, z : Float) {
			g.moveTo(x - ctx.scene.x, y - ctx.scene.y, z - ctx.scene.z);
		}
		inline function lineTo(x : Float, y : Float, z : Float) {
			g.lineTo(x - ctx.scene.x, y - ctx.scene.y, z - ctx.scene.z);
		}
		moveTo(last.x,last.y,last.z);
		for( fc in nearPlaneCorner ) {
			lineTo(fc.x, fc.y, fc.z);
		}

		// Far Plane
		var last = farPlaneCorner[farPlaneCorner.length - 1];
		moveTo(last.x,last.y,last.z);
		for( fc in farPlaneCorner ) {
			lineTo(fc.x, fc.y, fc.z);
		}

		// Connections
		for( i in 0 ... 4 ) {
			var np = nearPlaneCorner[i];
			var fp = farPlaneCorner[i];
			moveTo(np.x, np.y, np.z);
			lineTo(fp.x, fp.y, fp.z);
		}
	}

	function syncEarlyExit() {
		syncShader(staticTexture == null ? createDefaultShadowMap() : staticTexture);
	}

	function syncShader( texture : h3d.mat.Texture ) {
	}

	function filterPasses( passes : h3d.pass.PassList ) {
		if ( ctx.computingStatic || updateStatic ) {
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
		} else {
			switch( mode ) {
			case None:
				return false;
			case Dynamic:
				return true;
			case Mixed:
				passes.filter(function(p) return p.pass.isStatic == false);
				return true;
			case Static:
				syncEarlyExit();
				return false;
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
