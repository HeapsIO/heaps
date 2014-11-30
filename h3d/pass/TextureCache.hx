package h3d.pass;

class TextureCache {

	var cache : Array<h3d.mat.Texture>;
	var position : Int = 0;
	var frame : Int;
	public var hasDefaultDepth(default,null) : Bool;
	public var fullClearRequired(default,null) : Bool;

	public function new() {
		cache = [];
		var engine = h3d.Engine.getCurrent();
		hasDefaultDepth = engine.driver.hasFeature(TargetUseDefaultDepthBuffer);
		fullClearRequired = engine.driver.hasFeature(FullClearRequired);
	}

	public inline function get( index = 0 ) {
		return cache[index];
	}

	public function allocTarget( name : String, ctx : h3d.impl.RenderContext, width : Int, height : Int, hasDepth=true ) {
		if( frame != ctx.frame ) {
			// dispose extra textures we didn't use
			while( cache.length > position ) {
				var t = cache.pop();
				if( t != null ) t.dispose();
			}
			frame = ctx.frame;
			position = 0;
		}
		var t = cache[position];
		if( t == null || t.isDisposed() || t.width != width || t.height != height || t.flags.has(hasDefaultDepth ? TargetUseDefaultDepth : TargetDepth) != hasDepth ) {
			if( t != null ) t.dispose();
			var flags : Array<h3d.mat.Data.TextureFlags> = [Target, TargetNoFlipY];
			if( hasDepth ) flags.push(hasDefaultDepth ? TargetUseDefaultDepth : TargetDepth);
			t = new h3d.mat.Texture(width, height, flags);
			cache[position] = t;
		}
		t.setName(name);
		position++;
		return t;
	}

	public function dispose() {
		for( t in cache )
			t.dispose();
		cache = [];
		frame = -1;
	}

}