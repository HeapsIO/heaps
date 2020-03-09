package h3d.pass;

@ignore("shader")
class Blur extends ScreenFx<h3d.shader.Blur> {

	var cubeDir = [ h3d.Matrix.L([0,0,-1,0, 0,-1,0,0, 1,0,0,0]),
					h3d.Matrix.L([0,0,1,0, 0,-1,0,0, -1,0,0,0]),
	 				h3d.Matrix.L([1,0,0,0, 0,0,1,0, 0,1,0,0]),
	 				h3d.Matrix.L([1,0,0,0, 0,0,-1,0, 0,-1,0,0]),
				 	h3d.Matrix.L([1,0,0,0, 0,-1,0,0, 0,1,0,0]),
				 	h3d.Matrix.L([-1,0,0,0, 0,-1,0,0, 0,0,-1,0]) ];

	/**
		How far in pixels the blur will go.
	**/
	public var radius(default,set) : Float;

	/**
		How much the blur increases or decreases the color amount (default = 1)
	**/
	public var gain(default,set) : Float;

	/**
		Set linear blur instead of gaussian (default = 0).
	**/
	public var linear(default, set) : Float;

	/**
		Adjust how much quality/speed tradeoff we want (default = 1)
	**/
	public var quality(default,set) : Float;

	var values : Array<Float>;
	var offsets : Array<Float>;

	public function new( radius = 1., gain = 1., linear = 0., quality = 1. ) {
		super(new h3d.shader.Blur());
		this.radius = radius;
		this.quality = quality;
		this.gain = gain;
		this.linear = linear;
	}

	function set_radius(r) {
		if( radius == r )
			return r;
		values = null;
		return radius = r;
	}

	function set_quality(q) {
		if( quality == q )
			return q;
		values = null;
		return quality = q;
	}

	function set_gain(s) {
		if( gain == s )
			return s;
		values = null;
		return gain = s;
	}

	function set_linear(b) {
		if( linear == b )
			return b;
		values = null;
		return linear = b;
	}

	function gauss( x:Float, s:Float ) : Float {
		if( s <= 0 ) return x == 0 ? 1 : 0;
		var sq = s * s;
		var p = Math.pow(2.718281828459, -(x * x) / (2 * sq));
		return p / Math.sqrt(2 * Math.PI * sq);
	}

	function calcValues() {
		values = [];
		offsets = [];

		var tot = 0.;
		var qadj = hxd.Math.clamp(quality) * 0.7 + 0.3;
		var width = radius > 0 ? Math.ceil(hxd.Math.max(radius - 1, 1) * qadj / 2) : 0;
		var sigma = Math.sqrt(radius);
		for( i in 0...width + 1 ) {
			var i1 = i * 2;
			var i2 = i == 0 ? 0 : i * 2 - 1;
			var g1 = gauss(i1, sigma);
			var g2 = gauss(i2, sigma);
			var g = g1 + g2;
			values[i] = g;
			offsets[i] = i == 0 ? 0 : (g1 * i1  + g2 * i2) / (g * i * Math.sqrt(qadj));
			tot += g;
			if( i > 0 ) tot += g;
		}

		// eliminate too low contributing values
		var minVal = values[0] * (0.01 / qadj);
		while( values.length > 2 ) {
			var last = values[values.length-1];
			if( last > minVal ) break;
			tot -= last * 2;
			values.pop();
		}

		tot /= gain;
		for( i in 0...values.length )
			values[i] /= tot;

		if( linear > 0 ) {
			var m = gain / (values.length * 2 - 1);
			for( i in 0...values.length ) {
				values[i] = hxd.Math.lerp(values[i], m, linear);
				offsets[i] = hxd.Math.lerp(offsets[i], i == 0 ? 0 : (i * 2 - 0.5) / (i * qadj), linear);
			}
		}
	}

	public function getKernelSize() {
		if( values == null ) calcValues();
		return radius <= 0 ? 0 : values.length * 2 - 1;
	}

	public function apply( ctx : h3d.impl.RenderContext, src : h3d.mat.Texture, ?output : h3d.mat.Texture ) {

		if( radius <= 0 && shader.fixedColor == null ) {
			if( output != null ) Copy.run(src, output);
			return;
		}

		if( output == null ) output = src;
		if( values == null ) calcValues();

		var isCube = src.flags.has(Cube);
		var faceCount = isCube ? 6 : 1;
		var tmp = ctx.textures.allocTarget(src.name+"BlurTmp", src.width, src.height, false, src.format, isCube);

		shader.Quality = values.length;
		shader.values = values;
		shader.offsets = offsets;

		if( isCube ) {
			shader.cubeTexture = src;
			shader.isCube = true;
		}
		else{
			shader.texture = src;
			shader.isCube = false;
		}

		shader.pixel.set(1 / src.width, 0);
		for(i in 0 ... faceCount){
			engine.pushTarget(tmp, i);
			if( isCube ) shader.cubeDir = cubeDir[i];
			render();
			engine.popTarget();
		}

		if( isCube )
			shader.cubeTexture = tmp;
		else
			shader.texture = tmp;

		shader.pixel.set(0, 1 / src.height);
		var outDepth = output.depthBuffer;
		output.depthBuffer = null;
		for( i in 0 ... faceCount ){
			engine.pushTarget(output, i);
			if( isCube ) shader.cubeDir = cubeDir[i];
			render();
			engine.popTarget();
		}
		output.depthBuffer = outDepth;
	}

}