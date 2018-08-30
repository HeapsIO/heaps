package h3d.pass;

@ignore("shader")
class Outline extends ScreenFx<h3d.shader.Outline2D> {

	public var size(default, set) : Int;
	public var color(default, set) : Int;
	public var quality(default, set) : Float;

	public function new( size = 4, color = 0xFF000000, quality = 0.3 ) {
		super(new h3d.shader.Outline2D());
		this.size = size;
		this.color = color;
		this.quality = quality;
	}

	public function apply( ctx : h3d.impl.RenderContext, src : h3d.mat.Texture, ?output : h3d.mat.Texture ) {
		if( output == null ) output = src;
		var tmp = ctx.textures.allocTarget(src.name+"OutlineTmp", src.width, src.height, false, src.format, [Target]);
		shader.color.setColor(color);
		shader.size.set(size / src.width, size / src.height);
		shader.samples = Std.int(Math.max(quality * 100, 1));
		
		shader.texture = src;
		engine.pushTarget(tmp);
		render();
		engine.popTarget();

		shader.texture = tmp;
		var outDepth = output.depthBuffer;
		output.depthBuffer = null;
		engine.pushTarget(output);
		render();
		engine.popTarget();
		output.depthBuffer = outDepth;
	}

	function set_size(s) {
		if( size == s )
			return s;
		return size = s;
	}

	function set_color(c) {
		if( color == c )
			return c;
		return color = c;
	}

	function set_quality(q) {
		if( quality == q )
			return q;
		return quality = q;
	}
}