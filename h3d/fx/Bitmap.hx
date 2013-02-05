package h3d.fx;
import h3d.mat.Data;

private class BitmapShader extends hxsl.Shader {
	
	static var SRC = {
		var input : {
			pos : Float2,
			uv : Float2,
		};
		var tuv : Float2;
		function vertex( viewSize : Float4, viewPos : Float4 ) {
			out = input.pos.xyzw * viewSize + viewPos;
			tuv = input.uv;
		}
		function fragment( texture : Texture, color : Float4 ) {
			out = texture.get(tuv) * color;
		}
	};

}

class Bitmap extends h3d.Drawable<BitmapShader> {

	public var bmp(default,null) : h3d.mat.Bitmap;
	
	public var x : Float;
	public var y : Float;
	public var visible : Bool;
	public var alpha : Float;
	public var scaleX : Float;
	public var scaleY : Float;
	
	static var SHADER = null;
	static var PRIM = null;
	
	public function new( bmp ) {
		if( SHADER == null ) {
			SHADER = new BitmapShader();
			PRIM = new h3d.prim.Plan2D();
		}
		super(PRIM,SHADER);
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
		if( w != bmp.width || h != bmp.height ) throw bmp.width + "x" + bmp.height + " should be " + w + "x" + h;
		shader.texture.uploadBytes(bmp.bytes);
	}
	
	override function render( engine : h3d.Engine ) {
		if( !visible ) return;
		if( shader.texture == null ) alloc(engine);
		shader.viewPos = new h3d.Vector( (2*x+bmp.width*scaleX-engine.width)/engine.width, -(2*y+bmp.height*scaleY-engine.height)/engine.height ,0,0);
		shader.viewSize = new h3d.Vector(bmp.width * scaleX / engine.width,bmp.height * scaleY / engine.height);
		shader.color = new h3d.Vector(1, 1, 1, alpha);
		super.render(engine);
	}
	
}