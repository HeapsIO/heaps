package h3d.impl;

class TextureCache {
	static var checkFlags : Int = -1;
	var cache : Array<h3d.mat.Texture>;
	var position : Int = 0;
	var defaultDepthBuffer : h3d.mat.Texture;
	public var defaultFormat : hxd.PixelFormat;

	public function new() {
		cache = [];
		var engine = h3d.Engine.getCurrent();
		defaultFormat = h3d.mat.Texture.nativeFormat;
		defaultDepthBuffer = h3d.mat.Texture.getDefaultDepth();
		if ( checkFlags < 0 ) {
			var flags = new haxe.EnumFlags<h3d.mat.Data.TextureFlags>();
			var flagsArray : Array<h3d.mat.Data.TextureFlags> = [Cube, MipMapped, ManualMipMapGen, Dynamic, IsArray];
			for ( f in flagsArray )
				flags.set(f);
			checkFlags = flags.toInt();
		}
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

	inline function matchTargetFlags(t : h3d.mat.Texture, flags : Array<h3d.mat.Data.TextureFlags>) {
		var enumFlags = new haxe.EnumFlags<h3d.mat.Data.TextureFlags>();
		if ( flags != null ) {
			for ( f in flags )
				enumFlags.set(f);
		}
		return (t.flags.toInt() & checkFlags) == (enumFlags.toInt() & checkFlags);
	}

	function lookupTarget( name, width, height, format, flags : Array<h3d.mat.Data.TextureFlags> ) {
		var t = cache[position];
		// look for a suitable candidate
		for( i in position+1...cache.length ) {
			var t2 = cache[i];
			if( t2 != null && !t2.isDisposed() && t2.width == width && t2.height == height && t2.format == format ) {
				if ( !matchTargetFlags(t2, flags) )
					continue;
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
		if ( flags == null )
			flags = [];
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
		else
			alloc = !matchTargetFlags(t, flags);
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