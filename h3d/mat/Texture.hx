package h3d.mat;
import h3d.mat.Data;

@:allow(h3d)
#if !macro
@:build(hxd.impl.BitsBuilder.build())
#end
class Texture {

	static var UID = 0;
	static final PREVENT_AUTO_DISPOSE = 0x7FFFFFFF;
	static final PREVENT_FORCED_DISPOSE = -1;

	/**
		The default texture color format
	**/
	public static var nativeFormat(default,never) : TextureFormat =
		#if (usesys && !hldx && !hlsdl && !usegl && !macro)
			haxe.GraphicsDriver.nativeFormat
		#else
			RGBA
		#end;
	public static var TRILINEAR_FILTERING_ENABLED : Bool = true;
	public static var DEFAULT_WRAP : Wrap = Clamp;

	var t : h3d.impl.Driver.Texture;
	var mem : h3d.impl.MemoryManager;
	var allocPos : hxd.impl.AllocPos;
	public var id(default, null) : Int;
	public var name(default, null) : String;
	public var width(default, null) : Int;
	public var height(default, null) : Int;
	public var flags(default, null) : haxe.EnumFlags<TextureFlags>;
	public var format(default, null) : TextureFormat;

	var lastFrame(get,set) : Int;
	var bits : Int;
	var waitLoads : Array<Void -> Void>;
	@:bits(bits) public var mipMap : MipMap;
	@:bits(bits) public var filter : Filter;
	@:bits(bits) public var wrap : Wrap;
	public var layerCount(get, never) : Int;
	@:bits(bits, 4) public var startingMip : Int = 0;
	@:bits(bits, 16) var packedLodBias : Int;
	public var lodBias(get, set) : Float;
	public var mipLevels(get, never) : Int;
	var customMipLevels : Int;

	/**
		If this callback is set, the texture can be re-allocated when the 3D context has been lost or when
		it's been free because of lack of memory.
	**/
	public var realloc : Void -> Void;

	/**
		When the texture is used as render target, tells which depth buffer will be used.
		If set to null, depth testing is disabled.
	**/
	public var depthBuffer : Texture;

	var _lastFrame:Int;

	function set_lastFrame(lf:Int) {
		// Make sure we do not override lastFrame of textures set to prevent auto dispose
		if(_lastFrame != PREVENT_AUTO_DISPOSE) {
			_lastFrame = lf;
		}
		return _lastFrame;
	}

	inline function get_lastFrame()
	{
		return _lastFrame;
	}

	function get_mipLevels() {
		if( !flags.has(MipMapped) )
			return 1;
		if( customMipLevels > 0 )
			return customMipLevels;
		/* atm we don't allow textures with mipmaps < max levels */
		var lv = 1;
		var w = width, h = height;
		while( (w >> lv) >= 1 || (h >> lv) >= 1 ) lv++;
		return lv;
	}

	function get_lodBias() : Float {
		final fBits = 1 << (16 - 4);
		var iPart = (packedLodBias >> (16 - 4)) - 15;
		var fPart = packedLodBias & (fBits - 1);
		var v : Float = iPart + (fPart / fBits);
		return v;
	}

	function set_lodBias(v:Float) {
		v = hxd.Math.clamp(v, -15.0, 16.0) + 15.0;
		var iPart = hxd.Math.floor(v);
		var fPart = v % 1.0;
		packedLodBias = iPart << (16 - 4) | hxd.Math.floor(fPart * (1 << (16 - 4)));
		return v;
	}

	public function new(w, h, ?flags : Array<TextureFlags>, ?format : TextureFormat ) {
		if( format == null ) format = nativeFormat;
		this.id = ++UID;
		this.format = format;
		this.flags = new haxe.EnumFlags();
		if( flags != null )
			for( f in flags )
				this.flags.set(f);

		#if !noEngine
		var engine = h3d.Engine.getCurrent();
		this.mem = engine.mem;
		#end

		var tw = 1, th = 1;
		while( tw < w ) tw <<= 1;
		while( th < h) th <<= 1;
		if( tw != w || th != h )
			this.flags.set(IsNPOT);

		this.width = w;
		this.height = h;
		if ( this.flags.has(MipMapped) )
			this.mipMap = TRILINEAR_FILTERING_ENABLED ? Linear : Nearest;
		else
			this.mipMap = None;
		this.filter = Linear;
		this.wrap = DEFAULT_WRAP;
		this.lodBias = 0.0;
		this.allocPos = hxd.impl.AllocPos.make();
		if( !this.flags.has(NoAlloc) && width > 0 ) alloc();
	}

	function get_layerCount() {
		return flags.has(Cube) ? 6 : 1;
	}

	public function alloc() {
		if ( t == null )
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

	public function preventForcedDispose() {
		lastFrame = PREVENT_FORCED_DISPOSE;
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
			if( allocPos != null ) str += "(" + allocPos.position + ")";
		}
		if ( flags.has(Is3D) )
			str += "("+width+"x"+height+"x"+layerCount+")";
		else
			str += "("+width+"x"+height+")";
		return str;
	}

	public function setName(n) {
		name = n;
	}

	public inline function isDisposed() {
		// realloc unsupported on depth buffers.
		return t == null && (isDepth() || realloc == null);
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
		var color = new h3d.Vector4(r,g,b,a);
		if( layer < 0 ) {
			for( i in 0...layerCount ) {
				for ( j in 0...mipLevels ) {
					engine.pushTarget(this, i, j);
					engine.clearF(color);
					engine.popTarget();
				}
			}
		} else {
			for ( i in 0...mipLevels ) {
				engine.pushTarget(this, layer, i);
				engine.clearF(color);
				engine.popTarget();
			}
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
					for ( j in 0...mipLevels ) {
						engine.pushTarget(this, i, j);
						engine.clear(color);
						engine.popTarget();
					}
				}
			} else {
				for ( i in 0...mipLevels ) {
					engine.pushTarget(this, layer, i);
					engine.clear(color);
					engine.popTarget();
				}
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

	public function hasStencil() {
		return switch( format ) {
		case Depth24Stencil8: true;
		default: false;
		}
	}

	public function isDepth() {
		return switch( format ) {
		case Depth16, Depth24, Depth24Stencil8, Depth32: true;
		default: false;
		}
	}

	/**
		This will return the default depth buffer, which is automatically resized to the screen size.
	**/
	public static function getDefaultDepth() {
		return h3d.Engine.getCurrent().driver.getDefaultDepthBuffer();
	}

	/**
		Downloads the current texture data from the GPU.
		Beware, this is a very slow operation that shouldn't be done during rendering.
	**/
	public function capturePixels( face = 0, mipLevel = 0, ?region:h2d.col.IBounds ) : hxd.Pixels {
		var old = lastFrame;
		preventAutoDispose();
		var pix = mem.driver.capturePixels(this, face, mipLevel, region);
		lastFrame = old;
		return pix;
	}

	public static function fromBitmap( bmp : hxd.BitmapData ) {
		var t = new Texture(bmp.width, bmp.height);
		t.uploadBitmap(bmp);
		return t;
	}

	public static function fromPixels( pixels : hxd.Pixels, ?format ) {
		var t = new Texture(pixels.width, pixels.height, null, format != null ? format : pixels.format);
		t.uploadPixels(pixels);
		return t;
	}

	/**
		Creates a 1x1 texture using the RGB color passed as parameter.
	**/
	public static function fromColor( color : Int, alpha = 1. ) {
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