package h3d.pass;

class Blur extends ScreenFx<h3d.shader.Blur> {

	/**
		Gives the blur quality : 0 for disable, 1 for 3x3, 2 for 5x5, etc.
	**/
	public var quality(default, set) : Int;

	/**
		The amount of blur (gaussian blur value).
	**/
	public var sigma(default, set) : Float;

	/**
		The number of blur passes we perform (default = 1)
	**/
	public var passes : Int;


	public var depthBlur(default,set) : {
		depths : h3d.mat.Texture,
		normals : h3d.mat.Texture,
		camera : h3d.Camera,
	};

	var values : Array<Float>;

	public function new(quality = 1, passes = 1, sigma = 1.) {
		super(new h3d.shader.Blur());
		this.quality = quality;
		this.passes = passes;
		this.sigma = sigma;
	}

	function set_quality(q) {
		values = null;
		return quality = q;
	}

	function set_sigma(s) {
		values = null;
		return sigma = s;
	}


	function set_depthBlur(d) {
		depthBlur = d;
		if( d == null ) {
			shader.isDepthDependant = false;
			shader.depthTexture = null;
			shader.normalTexture = null;
		} else {
			shader.isDepthDependant = true;
			shader.depthTexture = d.depths;
			shader.normalTexture = d.normals;
		}
		return d;
	}

	function gauss( x:Int, s:Float ) : Float {
		if( s <= 0 ) return x == 0 ? 1 : 0;
		var sq = s * s;
		var p = Math.pow(2.718281828459, -(x * x) / (2 * sq));
		return p / Math.sqrt(2 * Math.PI * sq);
	}

	function calcValues() {
		values = [];
		var tot = 0.;
		for( i in 0...quality + 1 ) {
			var g = gauss(i, sigma);
			values[i] = g;
			tot += g;
			if( i > 0 ) tot += g;
		}
		for( i in 0...quality + 1 )
			values[i] /= tot;
	}

	public function apply( src : h3d.mat.Texture, ?tmp : h3d.mat.Texture, ?output : h3d.mat.Texture, ?isDepth = false ) {

		if( quality <= 0 || passes <= 0 || sigma <= 0 ) return;

		if( output == null ) output = src;

		var alloc = tmp == null;
		if( alloc )
			tmp = new h3d.mat.Texture(src.width, src.height, [Target]);

		if( values == null ) calcValues();

		shader.Quality = quality + 1;
		shader.values = values;
		shader.isDepth = isDepth;

		if( depthBlur != null )
			shader.cameraInverseViewProj = depthBlur.camera.getInverseViewProj();

		for( i in 0...passes ) {
			shader.texture = src;
			shader.pixel.set(1 / src.width, 0);
			engine.pushTarget(tmp);
			if( fullClearRequired ) engine.clear(0, 1, 0);
			render();
			engine.popTarget();

			shader.texture = tmp;
			shader.pixel.set(0, 1 / tmp.height);
			engine.pushTarget(output);
			if( fullClearRequired ) engine.clear(0, 1, 0);
			render();
			engine.popTarget();
		}

		if( alloc )
			tmp.dispose();
	}

}