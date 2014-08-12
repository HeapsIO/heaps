package h3d.pass;

class Blur {

	/**
		Gives the blur quality : 0 for disable, 1 for 3x3, 2 for 5x5, etc.
	**/
	public var quality(default, set) : Int;

	/**
		The amount of blur (gaussian blur value).
	**/
	public var sigma(default, set) : Float;

	var values : Array<Float>;
	var shader : h3d.shader.Blur;
	var pass : h3d.mat.Pass;
	var manager : h3d.shader.Manager;
	var plan : h3d.prim.Plan2D;

	public function new(quality = 1, sigma = 1.) {
		this.quality = quality;
		this.sigma = sigma;
		manager = new h3d.shader.Manager(["output.position", "output.color"]);
		shader = new h3d.shader.Blur();
		pass = new h3d.mat.Pass("blur", new hxsl.ShaderList(shader));
		pass.culling = None;
		pass.depth(false, Always);
		plan = new h3d.prim.Plan2D();
	}

	function set_quality(q) {
		values = null;
		return quality = q;
	}

	function set_sigma(s) {
		values = null;
		return sigma = s;
	}

	function gauss( x:Int, s:Float ) : Float {
		if( s <= 0 ) return x == 0 ? 1 : 0;
		var sq = s * s;
		var p = Math.pow(2.718281828459, -(x * x) / (2 * sq));
		return p / Math.sqrt(2 * Math.PI * sq);
	}

	public function apply( src : h3d.mat.Texture, ?tmp : h3d.mat.Texture, isDepth = false ) {

		if( quality == 0 ) return;

		var alloc = tmp == null;
		if( alloc )
			tmp = new h3d.mat.Texture(src.width, src.height, [Target, TargetNoFlipY]);

		if( values == null ) {
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

		var engine = h3d.Engine.getCurrent();

		shader.Quality = quality + 1;
		shader.texture = src;
		shader.values = values;
		shader.isDepth = isDepth;
		shader.pixel.set(1 / src.width, 0);

		var shaders : Array<hxsl.Shader> = [shader];
		var rts = manager.compileShaders(shaders);


		engine.setTarget(tmp,0xFFFF0000);
		engine.selectMaterial(pass);
		engine.selectShader(rts);
		var buf = new h3d.shader.Buffers(rts);
		manager.fillGlobals(buf, rts);
		manager.fillParams(buf, rts, shaders);
		engine.uploadShaderBuffers(buf, Globals);
		engine.uploadShaderBuffers(buf, Params);
		engine.uploadShaderBuffers(buf, Textures);
		plan.render(engine);
		engine.setTarget(null);

		engine.setTarget(src);
		shader.texture = tmp;
		shader.pixel.set(0, 1 / tmp.height);
		engine.selectMaterial(pass);
		engine.selectShader(rts);
		manager.fillParams(buf, rts, shaders);
		engine.uploadShaderBuffers(buf, Params);
		engine.uploadShaderBuffers(buf, Textures);
		plan.render(engine);
		engine.setTarget(null);

		if( alloc )
			tmp.dispose();
	}

}