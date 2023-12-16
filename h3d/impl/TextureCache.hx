package h3d.impl;

class TextureCache {

	var cache : Array<h3d.mat.Texture>;
	var position : Int = 0;
	var defaultDepthBuffer : h3d.mat.Texture;
	public var defaultFormat : hxd.PixelFormat;

	public function new() {
		cache = [];
		var engine = h3d.Engine.getCurrent();
		defaultFormat = h3d.mat.Texture.nativeFormat;
		defaultDepthBuffer = h3d.mat.Texture.getDefaultDepth();
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

	function lookupTarget( name, width, height, format, flags : Array<h3d.mat.Data.TextureFlags> ) {
		var t = cache[position];
		// look for a suitable candidate
		for( i in position+1...cache.length ) {
			var t2 = cache[i];
			if( t2 != null && !t2.isDisposed() && t2.width == width && t2.height == height && t2.format == format ) {
				if ( flags != null ) {
					var fitFlags = true;
					for ( f in flags ) {
						if ( !t2.flags.has(f) ) {
							fitFlags = false;
							break;
						}
					}
					if ( !fitFlags )
						continue;
				}
				// swap
				cache[position] = t2;
				cache[i] = t;
				return t2;
			}
		}
		// same name, most likely resolution changed, dispose before allocating new
		if( t != null && t.name == name ) {
			t.dispose();
			t = null;
		}
		if ( flags == null ) flags = [];
		if ( !flags.contains(Target) )
			flags.push(Target);
		var newt = new h3d.mat.Texture(width, height, flags, format);
		// make the texture disposable if we're out of memory
		newt.realloc = function() {};
		if( t != null )
			cache.insert(position,newt);
		else
			cache[position] = newt;
		return newt;
	}

	public function allocTarget( name : String, width : Int, height : Int, defaultDepth=true, ?format:hxd.PixelFormat, flags : Array<h3d.mat.Data.TextureFlags> = null ) {
		var t = cache[position];
		if( format == null ) format = defaultFormat;
		var alloc = false;
		if( t == null || t.isDisposed() || t.width != width || t.height != height || t.format != format )
			alloc = true;
		if ( !alloc && flags != null ) {
			for ( f in flags ) {
				if ( !t.flags.has(f) ) {
					alloc = true;
					break;
				}
			}
		}
		if ( alloc )
			t = lookupTarget(name,width,height,format,flags);
		t.depthBuffer = defaultDepth ? defaultDepthBuffer : null;
		t.setName(name);
		position++;
		return t;
	}

	public function allocTargetScale( name : String, scale : Float, defaultDepth=true, ?format:hxd.PixelFormat ) {
		var e = h3d.Engine.getCurrent();
		return allocTarget(name, Math.ceil(e.width * scale), Math.ceil(e.height * scale), defaultDepth, format);
	}

	public function allocTileTarget( name : String, tile : h2d.Tile, defaultDepth=false, ?format:hxd.PixelFormat ) {
		return allocTarget( name, tile.iwidth, tile.iheight, defaultDepth, format );
	}

	public function dispose() {
		for( t in cache )
			t.dispose();
		cache = [];
	}

}