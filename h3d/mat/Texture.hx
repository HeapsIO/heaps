package h3d.mat;
import h3d.mat.Data;

@:allow(h3d)
class Texture {

	static var UID = 0;
	static final PREVENT_AUTO_DISPOSE = 0x7FFFFFFF;

	/**
		The default texture color format
	**/
	public static var nativeFormat(default,never) : TextureFormat =
		#if flash
			BGRA
		#elseif (usesys && !hldx && !hlsdl && !usegl && !macro)
			haxe.GraphicsDriver.nativeFormat
		#else
			RGBA
		#end;

	var t : h3d.impl.Driver.Texture;
	var mem : h3d.impl.MemoryManager;
	#if track_alloc
	var allocPos : hxd.impl.AllocPos;
	#end
	public var id(default, null) : Int;
	public var name(default, null) : String;
	public var width(default, null) : Int;
	public var height(default, null) : Int;
	public var flags(default, null) : haxe.EnumFlags<TextureFlags>;
	public var format(default, null) : TextureFormat;

	var lastFrame(get,set) : Int;
	var bits : Int;
	var waitLoads : Array<Void -> Void>;
	public var mipMap(default,set) : MipMap;
	public var filter(default,set) : Filter;
	public var wrap(default, set) : Wrap;
	public var layerCount(get, never) : Int;
	public var lodBias : Float = 0.;
	public var mipLevels(get, never) : Int;

	/**
		If this callback is set, the texture can be re-allocated when the 3D context has been lost or when
		it's been free because of lack of memory.
	**/
	public var realloc : Void -> Void;

	/**
		When the texture is used as render target, tells which depth buffer will be used.
		If set to null, depth testing is disabled.
	**/
	public var depthBuffer : DepthBuffer;

	var _lastFrame:Int;

	function set_lastFrame(lf:Int) {
		// Make sure we do not override lastFrame of textures set to prevent auto dispose
		if(_lastFrame != PREVENT_AUTO_DISPOSE) {
			_lastFrame = lf;
		}
		return _lastFrame;
	}

	function get_lastFrame()
	{
		return _lastFrame;
	}

	function get_mipLevels() {
		if( !flags.has(MipMapped) )
			return 1;
		/* atm we don't allow textures with mipmaps < max levels */
		var lv = 1;
		var w = width, h = height;
		while( (w >> lv) >= 1 || (h >> lv) >= 1 ) lv++;
		return lv;
	}

	public function new(w, h, ?flags : Array<TextureFlags>, ?format : TextureFormat ) {
		#if !noEngine
		var engine = h3d.Engine.getCurrent();
		this.mem = engine.mem;
		#end
		if( format == null ) format = nativeFormat;
		this.id = ++UID;
		this.format = format;
		this.flags = new haxe.EnumFlags();
		if( flags != null )
			for( f in flags )
				this.flags.set(f);

		var tw = 1, th = 1;
		while( tw < w ) tw <<= 1;
		while( th < h) th <<= 1;
		if( tw != w || th != h )
			this.flags.set(IsNPOT);

		// make the texture disposable if we're out of memory
		// this can be disabled after allocation by reseting realloc
		if( this.flags.has(Target) ) realloc = function() { };

		this.width = w;
		this.height = h;
		this.mipMap = this.flags.has(MipMapped) ? Nearest : None;
		this.filter = Linear;
		this.wrap = Clamp;
		bits &= 0x7FFF;
		#if track_alloc
		this.allocPos = new hxd.impl.AllocPos();
		#end
		if( !this.flags.has(NoAlloc) ) alloc();
	}

	function get_layerCount() {
		return flags.has(Cube) ? 6 : 1;
	}

	public function alloc() {
		if( t == null )
			mem.allocTexture(this);
	}

	public function isSRGB() {
		return format.match(SRGB | SRGB_ALPHA);
	}

	function checkAlloc() {
		if( t == null && realloc != null ) {
			alloc();
			realloc();
		}
	}

	public function clone() {
		checkAlloc();
		if( t == null ) throw "Can't clone disposed texture";
		var old = lastFrame;
		preventAutoDispose();
		var flags = [];
		for( f in [Target,Cube,MipMapped,IsArray] )
			if( this.flags.has(f) )
				flags.push(f);
		var t = new Texture(width, height, flags, format);
		t.name = this.name;
		#if !macro
		if(this.flags.has(Cube))
			h3d.pass.CubeCopy.run(this, t);
		else
		#end
			h3d.pass.Copy.run(this, t);
		lastFrame = old;
		return t;
	}

	/**
		In case of out of GPU memory, textures that hasn't been used for a long time will be disposed.
		Calling this will make this texture not considered for auto disposal.
	**/
	public function preventAutoDispose() {
		lastFrame = PREVENT_AUTO_DISPOSE;
	}

	/**
		Some textures might take some time to load. You can check flags.has(Loading)
		or add a waitLoad callback which will get called either immediately if the texture is already loaded
		or when loading is complete.
	**/
	public function waitLoad( f : Void -> Void ) {
		if( !flags.has(Loading) ) {
			f();
			return;
		}
		if( waitLoads == null ) waitLoads = [];
		waitLoads.push(f);
	}

	function toString() {
		var str = name;
		if( name == null ) {
			str = "Texture_" + id;
			#if track_alloc
			if( allocPos != null ) str += "(" + allocPos.position + ")";
			#end
		}
		return str+"("+width+"x"+height+")";
	}

	public function setName(n) {
		name = n;
	}

	function set_mipMap(m:MipMap) {
		bits = (bits & ~(3 << 0)) | (Type.enumIndex(m) << 0);
		return mipMap = m;
	}

	function set_filter(f:Filter) {
		bits = (bits & ~(3 << 3)) | (Type.enumIndex(f) << 3);
		return filter = f;
	}

	function set_wrap(w:Wrap) {
		bits = (bits & ~(3 << 6)) | (Type.enumIndex(w) << 6);
		return wrap = w;
	}

	public inline function isDisposed() {
		return t == null && realloc == null;
	}

	public function resize(width, height) {
		dispose();

		var tw = 1, th = 1;
		while( tw < width ) tw <<= 1;
		while( th < height ) th <<= 1;
		if( tw != width || th != height )
			this.flags.set(IsNPOT);
		else
			this.flags.unset(IsNPOT);

		this.width = width;
		this.height = height;

		if( !flags.has(NoAlloc) )
			alloc();
	}

	public function clearF( r : Float = 0., g : Float = 0., b : Float = 0., a : Float = 0., layer = -1 ) {
		alloc();
		if( !flags.has(Target) ) throw "Texture should be target";
		var engine = h3d.Engine.getCurrent();
		var color = new h3d.Vector(r,g,b,a);
		if( layer < 0 ) {
			for( i in 0...layerCount ) {
				engine.pushTarget(this, i);
				engine.clearF(color);
				engine.popTarget();
			}
		} else {
			engine.pushTarget(this, layer);
			engine.clearF(color);
			engine.popTarget();
		}
	}

	public function clear( color : Int, alpha = 1., ?layer = -1 ) {
		alloc();
		if( width == 0 || height == 0 ) return;
		if( #if (usegl || hlsdl || js) true #else flags.has(Target) #end && (width != 1 || height != 1) ) {
			var engine = h3d.Engine.getCurrent();
			color |= Std.int(hxd.Math.clamp(alpha)*255) << 24;
			if( layer < 0 ) {
				for( i in 0...layerCount ) {
					engine.pushTarget(this, i);
					engine.clear(color);
					engine.popTarget();
				}
			} else {
				engine.pushTarget(this, layer);
				engine.clear(color);
				engine.popTarget();
			}
		} else {
			var p = hxd.Pixels.alloc(width, height, nativeFormat);
			var k = 0;
			var b = color & 0xFF, g = (color >> 8) & 0xFF, r = (color >> 16) & 0xFF, a = Std.int(alpha * 255);
			if( a < 0 ) a = 0 else if( a > 255 ) a = 255;
			switch( nativeFormat ) {
			case RGBA:
			case BGRA:
				// flip b/r
				var tmp = r;
				r = b;
				b = tmp;
			default:
				throw "TODO";
			}
			for( i in 0...width * height ) {
				p.bytes.set(k++,r);
				p.bytes.set(k++,g);
				p.bytes.set(k++,b);
				p.bytes.set(k++,a);
			}
			if( layer < 0 ) {
				for( i in 0...layerCount )
					uploadPixels(p, 0, i);
			} else
				uploadPixels(p, 0, layer);
			p.dispose();
		}
	}

	function checkSize(width, height, mip) {
		var mw = this.width >> mip; if( mw == 0 ) mw = 1;
		var mh = this.height >> mip; if( mh == 0 ) mh = 1;
		if( width != mw || height != mh )
			throw "Invalid upload size : " + width + "x" + height + " should be " + mw + "x" + mh;
	}

	function checkMipMapGen(mipLevel,layer) {
		if( mipLevel == 0 && flags.has(MipMapped) && !flags.has(ManualMipMapGen) && layer == layerCount - 1 )
			mem.driver.generateMipMaps(this);
	}

	public function uploadBitmap( bmp : hxd.BitmapData, mipLevel = 0, layer = 0 ) {
		alloc();
		checkSize(bmp.width, bmp.height, mipLevel);
		mem.driver.uploadTextureBitmap(this, bmp, mipLevel, layer);
		flags.set(WasCleared);
		checkMipMapGen(mipLevel, layer);
	}

	public function uploadPixels( pixels : hxd.Pixels, mipLevel = 0, layer = 0 ) {
		alloc();
		checkSize(pixels.width, pixels.height, mipLevel);
		mem.driver.uploadTexturePixels(this, pixels, mipLevel, layer);
		flags.set(WasCleared);
		checkMipMapGen(mipLevel, layer);
	}

	public function dispose() {
		if( t != null )
			mem.deleteTexture(this);
	}

	/**
		Swap two textures, this is an immediate operation.
		BEWARE : if the texture is a cached image (hxd.res.Image), the swap will affect the cache!
	**/
	public function swapTexture( t : Texture ) {
		checkAlloc();
		t.checkAlloc();
		if( isDisposed() || t.isDisposed() )
			throw "One of the two texture is disposed";
		var tmp = this.t;
		this.t = t.t;
		t.t = tmp;
	}

	/**
		Downloads the current texture data from the GPU.
		Beware, this is a very slow operation that shouldn't be done during rendering.
	**/
	public function capturePixels( face = 0, mipLevel = 0, ?region:h2d.col.IBounds ) : hxd.Pixels {
		#if flash
		if( flags.has(Cube) ) throw "Can't capture cube texture on this platform";
		if( region != null ) throw "Can't capture texture region on this platform";
		if( face != 0 || mipLevel != 0 ) throw "Can't capture face/mipLevel on this platform";
		return capturePixelsFlash();
		#else
		var old = lastFrame;
		preventAutoDispose();
		var pix = mem.driver.capturePixels(this, face, mipLevel, region);
		lastFrame = old;
		return pix;
		#end
	}

	#if flash
	function capturePixelsFlash() {
		var e = h3d.Engine.getCurrent();
		var oldW = e.width, oldH = e.height;
		var oldF = filter, oldM = mipMap, oldWrap = wrap;
		if( e.width < width || e.height < height )
			e.resize(width, height);
		e.driver.clear(new h3d.Vector(0, 0, 0, 0),1,0);
		var s2d = new h2d.Scene();
		var b = new h2d.Bitmap(h2d.Tile.fromTexture(this), s2d);
		var shader = new h3d.shader.AlphaChannel();
		b.addShader(shader); // erase alpha
		b.blendMode = None;

		mipMap = None;

		s2d.render(e);

		var pixels = hxd.Pixels.alloc(width, height, ARGB);
		e.driver.captureRenderBuffer(pixels);

		shader.showAlpha = true;
		s2d.render(e); // render only alpha channel
		var alpha = hxd.Pixels.alloc(width, height, ARGB);
		e.driver.captureRenderBuffer(alpha);
		var alphaPos = hxd.Pixels.getChannelOffset(alpha.format, A);
		var redPos = hxd.Pixels.getChannelOffset(alpha.format, R);
		var bpp = @:privateAccess alpha.bytesPerPixel;
		for( y in 0...height ) {
			var p = y * width * bpp;
			for( x in 0...width ) {
				pixels.bytes.set(p + alphaPos, alpha.bytes.get(p + redPos)); // copy alpha value only
				p += bpp;
			}
		}
		alpha.dispose();
		pixels.flags.unset(AlphaPremultiplied);

		if( e.width != oldW || e.height != oldH )
			e.resize(oldW, oldH);
		e.driver.clear(new h3d.Vector(0, 0, 0, 0));
		s2d.dispose();

		filter = oldF;
		mipMap = oldM;
		wrap = oldWrap;
		return pixels;
	}
	#end

	public static function fromBitmap( bmp : hxd.BitmapData ) {
		var t = new Texture(bmp.width, bmp.height);
		t.uploadBitmap(bmp);
		return t;
	}

	public static function fromPixels( pixels : hxd.Pixels ) {
		var t = new Texture(pixels.width, pixels.height);
		t.uploadPixels(pixels);
		return t;
	}

	/**
		Creates a 1x1 texture using the RGB color passed as parameter.
	**/
	public static function fromColor( color : Int, ?alpha = 1. ) {
		var engine = h3d.Engine.getCurrent();
		var aval = Std.int(alpha * 255);
		if( aval < 0 ) aval = 0 else if( aval > 255 ) aval = 255;
		var key = (color&0xFFFFFF) | (aval << 24);
		var t = @:privateAccess engine.textureColorCache.get(key);
		if( t != null )
			return t;
		var t = new Texture(1, 1, null);
		t.clear(color, alpha);
		t.realloc = function() t.clear(color, alpha);
		@:privateAccess engine.textureColorCache.set(key, t);
		return t;
	}

	#if !macro

	public static function genDisc( size : Int, color : Int, ?alpha = 1. ) {
		return genTexture(0,size,color,alpha);
	}

	static function genTexture( mode : Int, size : Int, color : Int, alpha : Float ) {
		var engine = h3d.Engine.getCurrent();
		var aval = Std.int(alpha * 255);
		if( aval < 0 ) aval = 0 else if( aval > 255 ) aval = 255;
		color = (color&0xFFFFFF)|(aval<<24);
		var key = ((size << 16) | mode) + "," + color;
		var k = genTextureKeys.get(key);
		var t : Texture = k == null ? null : @:privateAccess engine.resCache.get(k);
		if( t != null )
			return t;
		if( k == null ) {
			k = {};
			genTextureKeys.set(key, k);
		}
		t = new Texture(size,size,[Target]);
		t.realloc = function() drawGenTexture(t,color,mode);
		drawGenTexture(t,color,mode);
		@:privateAccess engine.resCache.set(k, t);
		return t;
	}

	static function drawGenTexture( t : h3d.mat.Texture, color : Int, mode : Int ) {
		var s = new h3d.pass.ScreenFx(new h3d.shader.GenTexture());
		var engine = h3d.Engine.getCurrent();
		s.shader.mode = mode;
		s.shader.color.setColor(color);
		engine.pushTarget(t);
		s.render();
		engine.popTarget();
	}

	#end

	/**
		Returns a default dummy 1x1 black cube texture
	**/
	public static function defaultCubeTexture() {
		var engine = h3d.Engine.getCurrent();
		var t : h3d.mat.Texture = @:privateAccess engine.resCache.get(Texture);
		if( t != null )
			return t;
		t = new Texture(1, 1, [Cube]);
		t.clear(0x202020);
		t.realloc = function() t.clear(0x202020);
		@:privateAccess engine.resCache.set(Texture,t);
		return t;
	}

	/**
		Returns a checker texture of size x size, than can be repeated
	**/
	public static function genChecker(size) {
		var engine = h3d.Engine.getCurrent();
		var k = checkerTextureKeys.get(size);
		var t : Texture = k == null ? null : @:privateAccess engine.resCache.get(k);
		if( t != null && !t.isDisposed() )
			return t;
		if( k == null ) {
			k = {};
			checkerTextureKeys.set(size, k);
		}
		var t = new h3d.mat.Texture(size, size, [NoAlloc]);
		t.realloc = allocChecker.bind(t,size);
		@:privateAccess engine.resCache.set(k, t);
		return t;
	}

	static var checkerTextureKeys = new Map<Int,{}>();
	static var noiseTextureKeys = new Map<Int,{}>();
	static var genTextureKeys= new Map<String,{}>();

	public static function genNoise(size) {
		var engine = h3d.Engine.getCurrent();
		var k = noiseTextureKeys.get(size);
		var t : Texture = k == null ? null : @:privateAccess engine.resCache.get(k);
		if( t != null && !t.isDisposed() )
			return t;
		if( k == null ) {
			k = {};
			noiseTextureKeys.set(size, k);
		}
		var t = new h3d.mat.Texture(size, size, [NoAlloc]);
		t.realloc = allocNoise.bind(t,size);
		@:privateAccess engine.resCache.set(k, t);
		return t;
	}

	static function allocNoise( t : h3d.mat.Texture, size : Int ) {
		var b = new hxd.BitmapData(size, size);
		for( x in 0...size )
			for( y in 0...size ) {
				var n = Std.random(256);
				b.setPixel(x, y, 0xFF000000 | n | (n << 8) | (n << 16));
			}
		t.uploadBitmap(b);
		b.dispose();
	}

	static function allocChecker( t : h3d.mat.Texture, size : Int ) {
		var b = new hxd.BitmapData(size, size);
		b.clear(0xFFFFFFFF);
		for( x in 0...size>>1 )
			for( y in 0...size>>1 ) {
				b.setPixel(x, y, 0xFF000000);
				b.setPixel(x+(size>>1), y+(size>>1), 0xFF000000);
			}
		t.uploadBitmap(b);
		b.dispose();
	}

}