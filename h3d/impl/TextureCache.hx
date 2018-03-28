package h3d.impl;

class TextureCache {

	var cache : Array<h3d.mat.Texture>;
	var position : Int = 0;
	var defaultDepthBuffer : h3d.mat.DepthBuffer;
	var ctx : h3d.impl.RenderContext;
	public var defaultFormat : hxd.PixelFormat;

	public function new(ctx) {
		this.ctx = ctx;
		cache = [];
		var engine = h3d.Engine.getCurrent();
		defaultFormat = h3d.mat.Texture.nativeFormat;
		defaultDepthBuffer = h3d.mat.DepthBuffer.getDefault();
	}

	public inline function get( index = 0 ) {
		return cache[index];
	}

	public function getNamed( name : String ) {
		for( i in 0...position )
			if( cache[i].name == name )
				return cache[i];
		return null;
	}

	public function set( t, index ) {
		cache[index] = t;
	}

	public function begin() {
		// dispose extra textures we didn't use in previous run
		while( cache.length > position ) {
			var t = cache.pop();
			if( t != null ) t.dispose();
		}
		position = 0;
	}

	public function allocTarget( name : String, width : Int, height : Int, defaultDepth=true, ?format:hxd.PixelFormat ) {
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
	}

}