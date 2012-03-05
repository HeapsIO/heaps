package h3d.fx;
import h3d.mat.Data;

private class BitmapShader extends h3d.Shader {
	
	static var SRC = {
		var input : {
			pos : Float2,
			uv : Float2,
		};
		var tuv : Float2;
		function vertex( viewSize : Float4, viewPos : Float4 ) {
			out = pos.xyzw * viewSize + viewPos;
			tuv = uv;
		}
		function fragment( texture : Texture, color : Float4 ) {
			out = texture.get(tuv) * color;
		}
	};

}

class Bitmap extends h3d.CustomObject<BitmapShader> {

	public var bmp(default,null) : flash.display.BitmapData;
	
	public var x : Float;
	public var y : Float;
	public var visible : Bool;
	public var alpha : Float;
	public var scaleX : Float;
	public var scaleY : Float;
	
	static var shader = null;
	static var prim = null;
	
	public function new( bmp : flash.display.BitmapData ) {
		if( shader == null ) {
			shader = new BitmapShader();
			prim = new h3d.prim.Plan2D();
		}
		super(prim,shader);
		material.depth(false, Compare.Always);
		material.blend(Blend.SrcAlpha, Blend.OneMinusSrcAlpha);
		material.culling = Face.None;
		this.bmp = bmp;
		visible = true;
		alpha = 1;
		scaleX = scaleY = 1;
		x = y = 0;
	}

	public function alloc( engine : h3d.Engine ) {
		var w = 1, h = 1;
		while( w < bmp.width ) w <<= 1;
		while( h < bmp.height ) h <<= 1;
		shader.texture = engine.mem.allocTexture(w, h);
		if( w != bmp.width || h != bmp.height ) {
			var tmp = new flash.display.BitmapData(w, h, true, 0);
			tmp.draw(new flash.display.Bitmap(bmp, flash.display.PixelSnapping.ALWAYS, true), new flash.geom.Matrix(w / bmp.width, 0, 0, h / bmp.height));
			shader.texture.upload(tmp);
			tmp.dispose();
		} else
			shader.texture.upload(bmp);
	}
	
	override function render( engine : h3d.Engine ) {
		if( !visible ) return;
		if( shader.texture == null ) alloc(engine);
		shader.viewPos = new h3d.Vector(x * 2 / engine.width, -y * 2 / engine.height);
		shader.viewSize = new h3d.Vector(bmp.width * 2 * scaleX / engine.width, bmp.height * 2 * scaleY / engine.height);
		shader.color = new h3d.Vector(1, 1, 1, alpha);
		super.render(engine);
	}
	
}