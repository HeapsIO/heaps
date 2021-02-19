package h3d.pass;

#if macro

class Copy {

	public static function run( from : h3d.mat.Texture, to : h3d.mat.Texture, ?blend : h3d.mat.BlendMode, ?pass : h3d.mat.Pass ) {
		throw "assert";
	}

}

#else

private class ArrayCopyShader extends h3d.shader.ScreenShader {

	static var SRC = {
		@param var texture : Sampler2DArray;
		@param var layer : Int;
		function fragment() {
			pixelColor = texture.get(vec3(calculatedUV, layer));
		}
	}
}

class ArrayCopy extends ScreenFx<ArrayCopyShader> {

	public function new() {
		super(new ArrayCopyShader());
	}

	public function apply( from : h3d.mat.TextureArray, fromLayer : Int, to, ?blend : h3d.mat.BlendMode, ?customPass : h3d.mat.Pass, ?layer : Int) {
		if( to != null )
			engine.pushTarget(to, layer != null ? layer : 0);
		shader.texture = from;
		shader.layer = fromLayer;
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
		shader.layer = 0;
		if( to != null )
			engine.popTarget();
	}

	public static function run( from : h3d.mat.TextureArray, fromLayer : Int, to : h3d.mat.Texture, ?blend : h3d.mat.BlendMode, ?pass : h3d.mat.Pass, ?layer : Int ) {
		var engine = h3d.Engine.getCurrent();
		if( to != null && from != null && (blend == null || blend == None) && pass == null && engine.driver.copyTexture(from, to) )
			return;
		var inst : ArrayCopy = @:privateAccess engine.resCache.get(ArrayCopy);
		if( inst == null ) {
			inst = new ArrayCopy();
			@:privateAccess engine.resCache.set(ArrayCopy, inst);
		}
		return inst.apply(from, fromLayer, to, blend, pass, layer);
	}
}

private class CopyShader extends h3d.shader.ScreenShader {

	static var SRC = {
		@param var texture : Sampler2D;
		function fragment() {
			pixelColor = texture.get(calculatedUV);
		}
	}
}

class Copy extends ScreenFx<CopyShader> {

	public function new() {
		super(new CopyShader());
	}

	public function apply( from, to, ?blend : h3d.mat.BlendMode, ?customPass : h3d.mat.Pass, ?layer :Int) {
		if( to != null )
			engine.pushTarget(to, layer != null ? layer : 0);
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
		if( to != null )
			engine.popTarget();
	}

	public static function run( from : h3d.mat.Texture, to : h3d.mat.Texture, ?blend : h3d.mat.BlendMode, ?pass : h3d.mat.Pass, ?layer : Int ) {
		var engine = h3d.Engine.getCurrent();
		if( to != null && from != null && (blend == null || blend == None) && pass == null && layer == null && engine.driver.copyTexture(from, to) )
			return;
		var inst : Copy = @:privateAccess engine.resCache.get(Copy);
		if( inst == null ) {
			inst = new Copy();
			@:privateAccess engine.resCache.set(Copy, inst);
		}
		return inst.apply(from, to, blend, pass, layer);
	}

}

#end