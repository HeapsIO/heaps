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
			var flagsArray : Array<h3d.mat.Data.TextureFlags> = [Cube, MipMapped, ManualMipMapGen, Dynamic, IsArray, Writable];
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

	inline function targetLayerCount( flags : Array<h3d.mat.Data.TextureFlags>, layers : Int ) {
		return ( flags != null && flags.contains(Cube) ) ? 6 : layers;
	}

	inline function matchTargetFlags(t : h3d.mat.Texture, flags : Array<h3d.mat.Data.TextureFlags>, layers = 1) {
		var enumFlags = new haxe.EnumFlags<h3d.mat.Data.TextureFlags>();
		if ( flags != null ) {
			for ( f in flags )
				enumFlags.set(f);
		}
		if ( layers > 1 && !enumFlags.has(Cube) )
			enumFlags.set(IsArray);
		return (t.flags.toInt() & checkFlags) == (enumFlags.toInt() & checkFlags);
	}

	function lookupTarget( name, width, height, format, flags : Array<h3d.mat.Data.TextureFlags>, layers = 1 ) {
		var t = cache[position];
		var layerCount = targetLayerCount(flags, layers);
		// look for a suitable candidate
		for( i in position+1...cache.length ) {
			var t2 = cache[i];
			if( t2 != null && !t2.isDisposed() && t2.width == width && t2.height == height && t2.format == format && t2.layerCount == layerCount ) {
				if ( !matchTargetFlags(t2, flags, layers) )
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
		var allocFlags = flags == null ? [] : flags.copy();
		if ( !allocFlags.contains(Target) )
			allocFlags.push(Target);
		var isArray = !allocFlags.contains(Cube) && (layers > 1 || allocFlags.contains(IsArray));
		var newt : h3d.mat.Texture = isArray ? new h3d.mat.TextureArray(width, height, layers, allocFlags, format) : new h3d.mat.Texture(width, height, allocFlags, format);
		if( t != null )
			cache.insert(position,newt);
		else
			cache[position] = newt;
		return newt;
	}

	public function allocTarget( name : String, width : Int, height : Int, defaultDepth=true, ?format:hxd.PixelFormat, flags : Array<h3d.mat.Data.TextureFlags> = null, layers = 1 ) {
		var t = cache[position];
		if( format == null ) format = defaultFormat;
		var layerCount = targetLayerCount(flags, layers);
		var alloc = false;
		if( t == null || t.isDisposed() || t.width != width || t.height != height || t.format != format || t.layerCount != layerCount )
			alloc = true;
		else
			alloc = !matchTargetFlags(t, flags, layers);
		if ( alloc )
			t = lookupTarget(name,width,height,format,flags,layers);
		t.depthBuffer = defaultDepth ? defaultDepthBuffer : null;
		t.setName(name);
		position++;
		return t;
	}

	public function allocTargetScale( name : String, scale : Float, defaultDepth=true, ?format:hxd.PixelFormat, flags : Array<h3d.mat.Data.TextureFlags> = null, layers = 1 ) {
		var e = h3d.Engine.getCurrent();
		return allocTarget(name, Math.ceil(e.width * scale), Math.ceil(e.height * scale), defaultDepth, format, flags, layers);
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