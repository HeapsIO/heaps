package h3d.impl;

class TextureCache {

	var cache : Array<h3d.mat.Texture>;
	var position : Int = 0;
	var frame : Int;
	var defaultDepthBuffer : h3d.mat.DepthBuffer;
	public var defaultFormat : hxd.PixelFormat;

	public function new() {
		cache = [];
		var engine = h3d.Engine.getCurrent();
		defaultFormat = h3d.mat.Texture.nativeFormat;
		defaultDepthBuffer = h3d.mat.DepthBuffer.getDefault();
	}

	public inline function get( index = 0 ) {
		return cache[index];
	}

	public function set( t, index ) {
		cache[index] = t;
	}

	public function begin( ctx : h3d.impl.RenderContext ) {
		if( frame != ctx.frame ) {
			// dispose extra textures we didn't use
			while( cache.length > position ) {
				var t = cache.pop();
				if( t != null ) t.dispose();
			}
			frame = ctx.frame;
			position = 0;
		}
	}

	public function allocTarget( name : String, ctx : h3d.impl.RenderContext, width : Int, height : Int, defaultDepth=true, ?format:hxd.PixelFormat ) {
		begin(ctx);
		var t = cache[position];
		if( format == null ) format = defaultFormat;
		if( t == null || t.isDisposed() || t.width != width || t.height != height || t.format != format ) {
			if( t != null ) t.dispose();
			var flags : Array<h3d.mat.Data.TextureFlags> = [Target];
			t = new h3d.mat.Texture(width, height, flags, format);
			cache[position] = t;
		}
		t.depthBuffer = defaultDepth ? defaultDepthBuffer : null;
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