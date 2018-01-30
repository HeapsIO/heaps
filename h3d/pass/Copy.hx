package h3d.pass;

private class CopyShader extends h3d.shader.ScreenShader {

	static var SRC = {
		@param var texture : Sampler2D;

		var pixelColor : Vec4;

		function __init__fragment() {
			pixelColor = texture.get(calculatedUV);
		}

		function fragment() {
			output.color = pixelColor;
		}
	}
}

class Copy extends ScreenFx<CopyShader> {

	public function new() {
		super(new CopyShader());
	}

	public function apply( from, to, ?blend : h3d.mat.BlendMode, ?customPass : h3d.mat.Pass ) {
		engine.pushTarget(to);
		shader.texture = from;
		if( customPass != null ) {
			var old = pass;
			pass = customPass;
			if( blend != null ) pass.setBlendMode(blend);
			var h = shaders;
			while( h.next != null )
				h = h.next;
			h.next = @:privateAccess pass.shaders;
			render();
			pass = old;
			h.next = null;
		} else {
			pass.setBlendMode(blend == null ? None : blend);
			render();
		}
		shader.texture = null;
		engine.popTarget();
	}

	public static function run( from : h3d.mat.Texture, to : h3d.mat.Texture, ?blend : h3d.mat.BlendMode, ?pass : h3d.mat.Pass ) {
		var engine = h3d.Engine.getCurrent();
		if( to != null && from != null && (blend == null || blend == None) && pass == null && engine.driver.copyTexture(from, to) )
			return;
		var inst : Copy = @:privateAccess engine.resCache.get(Copy);
		if( inst == null ) {
			inst = new Copy();
			@:privateAccess engine.resCache.set(Copy, inst);
		}
		return inst.apply(from, to, blend, pass);
	}

}