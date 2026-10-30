package h3d.impl;

#if (!js || dx12)

#if hl
@:forward(setI32,setUI8,setUI16,getUI8,getUI16,getI32,setF32,getF32,sub,blit)
private abstract Bytes(hl.Bytes) from hl.Bytes to hl.Bytes {
	public function new(size) this = new hl.Bytes(size);
	public inline function compare( bytes : Bytes, size : Int ) {
		return this.compare(0, bytes, 0, size);
	}
	public inline function toBytes( size : Int ) : haxe.io.Bytes {
		return @:privateAccess new haxe.io.Bytes(this, size);
	}
}
#else
@:forward(sub)
private abstract Bytes(haxe.io.Bytes) from haxe.io.Bytes {
	public function new(size) {
		this = haxe.io.Bytes.alloc(size);
	}
	public inline function setI32(idx:Int,v:Int) {
		this.setInt32(idx, v);
	}
	public inline function setUI8(idx:Int,v:Int) {
		this.set(idx, v);
	}
	public inline function setUI16(idx:Int,v:Int) {
		this.setUInt16(idx, v);
	}
	public inline function getI32(idx:Int) {
		return this.getInt32(idx);
	}
	public inline function getUI8(idx:Int) {
		return this.get(idx);
	}
	public inline function getUI16(idx:Int) {
		return this.getUInt16(idx);
	}
	public inline function setF32(idx:Int,v:Float) {
		this.setFloat(idx, v);
	}
	public inline function getF32(idx:Int) : Float {
		return this.getFloat(idx);
	}
	public inline function blit(pos:Int,src:haxe.io.BytesData,srcPos:Int,len:Int) {
		this.blit(pos, haxe.io.Bytes.ofData(src), srcPos, len);
	}
	public inline function toBytes( size : Int ) : haxe.io.Bytes {
		return this.sub(0, size);
	}
	public function compare( bytes : Bytes, size : Int ) {
		var bytes : haxe.io.Bytes = cast bytes;
		for( i in 0...size ) {
			var d = this.get(i) - bytes.get(i);
			if( d != 0 ) return d;
		}
		return 0;
	}
}
#end

@:generic class CachedPipeline<T> {
	public var bytes : Bytes;
	public var size : Int;
	public var pipeline : T;
	public function new() {
	}

	public function getFields() : Array<{ name : String, value : String }> @:privateAccess {
		inline function depthFormatName( idx : Int ) : String {
			if( idx == 0 )
				return "none";
			return try Std.string(Type.createEnumIndex(hxd.PixelFormat, idx)) catch( e : Dynamic ) 'invalid($idx)';
		}

		inline function rtFormatName( rtBits : Int ) : String {
			if( rtBits == 0 )
				return "-";
			return try Std.string(@:privateAccess PipelineBuilder.getRTFormat(rtBits)) catch( e : Dynamic ) 'invalid($rtBits)';
		}

		var b = bytes;
		var matId = b.getI32(PipelineBuilder.PSIGN_MATID);
		var out = [{ name : "matId", value : '$matId' }];
		for( f in h3d.mat.Pass.bitsToFields(matId) )
			out.push(f);
		out.push({ name : "colorMask", value : '${b.getUI8(PipelineBuilder.PSIGN_COLOR_MASK)}' });
		out.push({ name : "depthBias",   value : '${b.getF32(PipelineBuilder.PSIGN_DEPTH_BIAS)}' });
		out.push({ name : "slopeBias",   value : '${b.getF32(PipelineBuilder.PSIGN_SLOPE_SCALED_DEPTH_BIAS)}' });
		out.push({ name : "stencilMask", value : '${b.getUI16(PipelineBuilder.PSIGN_STENCIL_MASK)}' });
		out.push({ name : "stencilOps",  value : '${b.getI32(PipelineBuilder.PSIGN_STENCIL_OPS)}' });
		out.push({ name : "depthFormat", value : depthFormatName(b.getI32(PipelineBuilder.PSIGN_DEPTH_TARGET_FORMAT)) });
		for( i in 0...8 )
			out.push({ name : 'rt$i', value : rtFormatName(b.getUI8(PipelineBuilder.PSIGN_RENDER_TARGETS + i)) });
		var inputCount = (size - PipelineBuilder.PSIGN_LAYOUT) >> PipelineBuilder.SHIFT_PER_BUFFER;
		for( i in 0...inputCount )
			out.push({ name : 'input$i', value : '${b.getUI16(PipelineBuilder.PSIGN_LAYOUT + (i << PipelineBuilder.SHIFT_PER_BUFFER))}' });
		return out;
	}

	public function toString() {
		var buf = new StringBuf();
		for( i => f in getFields() ) {
			if( i > 0 ) buf.add(" ");
			buf.add(f.name);
			buf.add("=");
			buf.add(f.value);
		}
		return buf.toString();
	}
}

@:forward(get,set,keys)
abstract PipelineCache<T>(Map<Int,#if hl hl.NativeArray #else Array #end<CachedPipeline<T>>>) {

	public function new() {
		this = new Map();
	}

	public function diff( cp : CachedPipeline<T>, max = 3 ) : String {
		inline function diffFields( a, b ) : Array<String> {
			var fa = a.getFields(), fb = b.getFields();
			var out = [];
			var n = fa.length < fb.length ? fa.length : fb.length;
			for( i in 0...n )
				if( fa[i].value != fb[i].value )
					out.push('${fa[i].name} ${fa[i].value} -> ${fb[i].value}');
			if( fa.length != fb.length )
				out.push('inputCount ${fa.length} -> ${fb.length}');
			return out;
		}

		var results = [];
		for( p in this ) @:privateAccess {
			for( i in 0...p.length ) {
				var other = p[i];
				if( other == null || other == cp )
					continue;
				results.push({ entry : other, diffs : diffFields(cp, other) });
			}
		}
		if( results.length == 0 )
			return "no other entries to compare against";
		results.sort((a, b) -> a.diffs.length - b.diffs.length);

		var buf = new StringBuf();
		buf.add('closest of ${results.length} entries:');
		for( i in 0...(results.length < max ? results.length : max) ) {
			var r = results[i];
			buf.add('\n  ');
			buf.add(r.diffs.length == 0 ? "identical fields (error?)" : r.diffs.join(", "));
		}
		return buf.toString();
	}
}

/**
	Pipeline state that a driver sets at draw time instead of baking it into the pipeline.
	It is left out of the pipeline key, so passes that only differ by it share a pipeline.
**/
enum PipelineDynamicState {
	Culling;
	DepthTest;
	DepthWrite;
	DepthBias;
	Stencil;
}

class DepthProps {
	public var format : hxd.PixelFormat;
	public var bias : Single;
	public var slopeScaledBias : Single;
	public function new() {}
}

class PipelineBuilder {

	static inline var PSIGN_MATID = 0;
	static inline var PSIGN_COLOR_MASK = PSIGN_MATID + 4;
	static inline var PSIGN_DEPTH_BIAS = PSIGN_COLOR_MASK + 1;
	static inline var PSIGN_SLOPE_SCALED_DEPTH_BIAS = PSIGN_DEPTH_BIAS + 4;
	static inline var PSIGN_STENCIL_MASK = PSIGN_SLOPE_SCALED_DEPTH_BIAS + 4;
	static inline var PSIGN_STENCIL_OPS = PSIGN_STENCIL_MASK + 2;
	static inline var PSIGN_RENDER_TARGETS = PSIGN_STENCIL_OPS + 4;
	static inline var PSIGN_DEPTH_TARGET_FORMAT = PSIGN_RENDER_TARGETS + 8;
	static inline var PSIGN_LAYOUT = PSIGN_DEPTH_TARGET_FORMAT + 4;

	static inline var MAX_BUFFERS = 8;
	static inline var SHIFT_PER_BUFFER = #if js 2 #else 1 #end;
	static inline var PSIGN_SIZE = PSIGN_LAYOUT + (MAX_BUFFERS << SHIFT_PER_BUFFER);

	public var needFlush : Bool;
	var signature = new Bytes(64);
	var keyMask : Bytes;
	var key : Bytes;
	var tmpDepth = new DepthProps();
	var tmpPass = new h3d.mat.Pass("");
	var tmpStencil = new h3d.mat.Stencil();
	#if hl
	var adlerOut = new Bytes(4);
	var lastCache : Dynamic;
	var lastSize = -1;
	var lastSignature = new Bytes(64);
	var lastPipeline : Dynamic;
	#end

	public function new( ?dynamicStates : haxe.EnumFlags<PipelineDynamicState> ) {
		if( PSIGN_SIZE > 64 ) throw "assert";
		setDepthBias(0, 0);
		if( dynamicStates != null && dynamicStates.toInt() != 0 )
			initKeyMask(dynamicStates);
	}

	function initKeyMask( states : haxe.EnumFlags<PipelineDynamicState> ) {
		keyMask = new Bytes(64);
		key = new Bytes(64);
		for( i in 0...16 )
			keyMask.setI32(i << 2, -1);
		var matMask = -1;
		if( states.has(Culling) ) matMask &= ~h3d.mat.Pass.culling_mask;
		if( states.has(DepthTest) ) matMask &= ~h3d.mat.Pass.depthTest_mask;
		if( states.has(DepthWrite) ) matMask &= ~h3d.mat.Pass.depthWrite_mask;
		keyMask.setI32(PSIGN_MATID, matMask);
		if( states.has(DepthBias) ) {
			keyMask.setI32(PSIGN_DEPTH_BIAS, 0);
			keyMask.setI32(PSIGN_SLOPE_SCALED_DEPTH_BIAS, 0);
		}
		if( states.has(Stencil) ) {
			keyMask.setUI16(PSIGN_STENCIL_MASK, 0);
			keyMask.setI32(PSIGN_STENCIL_OPS, 0);
		}
	}

	static function getRTBits( tex : h3d.mat.Texture ) {
		inline function mk(channels,format) {
			return ((format + 1) << 2) | (channels - 1);
		}
		return switch( tex.format ) {
		case R8:         mk(1, 0);
		case RG8:        mk(2, 0);
		case RGB8:       mk(3, 0);
		case RGBA:       mk(4, 0);
		case R16F:       mk(1, 1);
		case RG16F:      mk(2, 1);
		case RGB16F:     mk(3, 1);
		case RGBA16F:    mk(4, 1);
		case R32F:       mk(1, 2);
		case RG32F:      mk(2, 2);
		case RGB32F:     mk(3, 2);
		case RGBA32F:    mk(4, 2);
		case R16U:       mk(1, 3);
		case RG16U:      mk(2, 3);
		case RGB16U:     mk(3, 3);
		case RGBA16U:    mk(4, 3);
		case RG11B10UF:  mk(2, 4);
		case RGB10A2:    mk(3, 4);
		default: throw "Unsupported RT format "+tex.format;
		}
	}

	static function getRTFormat( rtBits : Int ) : hxd.PixelFormat {
		var channels = (rtBits & 3) + 1;
		var format = (rtBits >> 2) - 1;
		return switch( [channels, format] ) {
		case [1, 0]: R8;
		case [2, 0]: RG8;
		case [3, 0]: RGB8;
		case [4, 0]: RGBA;
		case [1, 1]: R16F;
		case [2, 1]: RG16F;
		case [3, 1]: RGB16F;
		case [4, 1]: RGBA16F;
		case [1, 2]: R32F;
		case [2, 2]: RG32F;
		case [3, 2]: RGB32F;
		case [4, 2]: RGBA32F;
		case [1, 3]: R16U;
		case [2, 3]: RG16U;
		case [3, 3]: RGB16U;
		case [4, 3]: RGBA16U;
		case [2, 4]: RG11B10UF;
		case [3, 4]: RGB10A2;
		default: throw "Invalid RT bits "+ rtBits;
		}
	}

	public inline function setShader( sh : hxsl.RuntimeShader ) {
		needFlush = sh.mode != Compute;
	}

	public function setDepthBias( depthBias : Float, slopeScaledBias : Float  ) {
		signature.setF32(PSIGN_DEPTH_BIAS, depthBias);
		signature.setF32(PSIGN_SLOPE_SCALED_DEPTH_BIAS, slopeScaledBias);
		needFlush = true;
	}

	static function initFormats() {
		var fmt = [];
		for( f in ([Depth16,Depth24,Depth24Stencil8,Depth32,Depth32Stencil8] : Array<hxd.PixelFormat>) )
			fmt[f.getIndex()] = f;
		return fmt;
	}

	public function getDepthProps() {
		static var FORMATS = initFormats();
		var d = tmpDepth;
		d.format = FORMATS[signature.getI32(PSIGN_DEPTH_TARGET_FORMAT)];
		d.bias = signature.getF32(PSIGN_DEPTH_BIAS);
		d.slopeScaledBias = signature.getF32(PSIGN_SLOPE_SCALED_DEPTH_BIAS);
		return d;
	}

	public function setRenderTarget( tex : h3d.mat.Texture, depth : h3d.mat.Texture  ) {
		signature.setI32(PSIGN_RENDER_TARGETS, tex == null ? 0 : getRTBits(tex));
		signature.setI32(PSIGN_RENDER_TARGETS + 4, 0);
		signature.setI32(PSIGN_DEPTH_TARGET_FORMAT, depth == null ? 0 : depth.format.getIndex());
		needFlush = true;
	}

	public function getDepthEnabled() {
		return signature.getI32(PSIGN_DEPTH_TARGET_FORMAT) != 0;
	}

	public function setDepth( depth : h3d.mat.Texture ) {
		signature.setI32(PSIGN_RENDER_TARGETS, 0);
		signature.setI32(PSIGN_RENDER_TARGETS + 4, 0);
		signature.setI32(PSIGN_DEPTH_TARGET_FORMAT, depth.format.getIndex());
		needFlush = true;
	}

	public function setRenderTargets( textures : Array<h3d.mat.Texture>, depth : h3d.mat.Texture  ) {
		for( i => t in textures )
			signature.setUI8(PSIGN_RENDER_TARGETS + i, getRTBits(t));
		for ( i in textures.length...8)
			signature.setUI8(PSIGN_RENDER_TARGETS + i, 0);
		var format = depth == null ? 0 : depth.format.getIndex();
		signature.setI32(PSIGN_DEPTH_TARGET_FORMAT, format);
		needFlush = true;
	}

	public function getRenderTargetsCount() {
		var rtCount = 0;
		for( i in 0...8 )
			rtCount += signature.getUI8(PSIGN_RENDER_TARGETS + i) != 0 ? 1 : 0;
		return rtCount;
	}

	public function getRenderTargetFormat(i : Int) {
		var rtBits = signature.getUI8(PSIGN_RENDER_TARGETS + i);
		return rtBits != 0 ? getRTFormat(rtBits) : null;
	}

	public function selectMaterial( pass : h3d.mat.Pass ) @:privateAccess {
		signature.setI32(PSIGN_MATID, pass.bits);
		signature.setUI8(PSIGN_COLOR_MASK, pass.colorMask);
		var st = pass.stencil;
		if( st != null ) {
			signature.setUI16(PSIGN_STENCIL_MASK, st.maskBits & 0xFFFF);
			signature.setI32(PSIGN_STENCIL_OPS, st.opBits);
		} else {
			signature.setUI16(PSIGN_STENCIL_MASK, 0);
			signature.setI32(PSIGN_STENCIL_OPS, 0);
		}
		needFlush = true;
	}

	public inline function setBuffer( i : Int, inf : hxd.BufferFormat.BufferMapping, stride : Int ) {
		if( inf.offset >= 256 || (inf.offset & 3) != 0 ) throw "assert";
		signature.setUI16(PSIGN_LAYOUT + (i<<SHIFT_PER_BUFFER), (inf.offset << 1) | inf.precision.toInt());
		#if js
		signature.setUI16(PSIGN_LAYOUT + (i<<SHIFT_PER_BUFFER) + 2, stride);
		#end
		needFlush = true;
	}

	public function getCurrentPass() @:privateAccess {
		var pass = tmpPass;
		pass.loadBits(signature.getI32(PSIGN_MATID));
		pass.colorMask = signature.getUI8(PSIGN_COLOR_MASK);
		var mask = signature.getUI16(PSIGN_STENCIL_MASK);
		var ops = signature.getI32(PSIGN_STENCIL_OPS);
		if( ops == 0 )
			pass.stencil = null;
		else {
			pass.stencil = tmpStencil;
			pass.stencil.loadMaskBits(mask);
			pass.stencil.loadOpBits(ops);
		}
		return pass;
	}

	public function getBufferInput( i : Int ) {
		var b = signature.getUI16(PSIGN_LAYOUT + (i<<SHIFT_PER_BUFFER));
		return new hxd.BufferFormat.BufferMapping(i, (b >> 1) & ~3, @:privateAccess new hxd.BufferFormat.Precision(b & 7));
	}

	#if js
	public function getBufferStride( i : Int ) {
		return signature.getUI16(PSIGN_LAYOUT + (i << SHIFT_PER_BUFFER) + 2);
	}
	#end

	function hashSign( sign : Bytes, size : Int ) {
		#if hl
		adlerOut.setI32(0, 0);
		hl.Format.digest(adlerOut, sign, size, 3);
		return adlerOut.getI32(0);
		#else
		var tot = 0;
		for( i in 0...size>>2 )
			tot = (tot * 31 + sign.getI32(i<<2)) % 0x7FFFFFFF;
		for( i in (size & ~3)...size )
			tot = (tot * 31 + sign.getUI8(i)) % 0x7FFFFFFF;
		return tot;
		#end
	}

	function makeKey( size : Int ) {
		for( i in 0...size >> 2 )
			key.setI32(i << 2, signature.getI32(i << 2) & keyMask.getI32(i << 2));
		for( i in (size & ~3)...size )
			key.setUI8(i, signature.getUI8(i) & keyMask.getUI8(i));
		return key;
	}

	public function lookup<T>( cache : PipelineCache<T>, inputs : Int ) : CachedPipeline<T> {
		needFlush = false;
		var signatureSize = PSIGN_LAYOUT + (inputs << SHIFT_PER_BUFFER);
		var signature = keyMask == null ? signature : makeKey(signatureSize);
		#if hl
		if( cache == lastCache && signatureSize == lastSize && lastSignature.compare(signature, signatureSize) == 0 )
			return lastPipeline;
		var p = findPipeline(cache, signature, signatureSize);
		lastCache = cache;
		lastSize = signatureSize;
		lastSignature.blit(0, signature, 0, signatureSize);
		lastPipeline = p;
		return p;
		#else
		return findPipeline(cache, signature, signatureSize);
		#end
	}

	function findPipeline<T>( cache : PipelineCache<T>, signature : Bytes, signatureSize : Int ) : CachedPipeline<T> {
		var hash = hashSign(signature, signatureSize);
		var pipes = cache.get(hash);
		if( pipes == null ) {
			pipes = #if hl new hl.NativeArray(1) #else [] #end;
			cache.set(hash, pipes);
		}
		var insert = -1;
		for( i in 0...pipes.length ) {
			var p = pipes[i];
			if( p == null ) {
				insert = i;
				break;
			}
			if( p.size == signatureSize && p.bytes.compare(signature, signatureSize) == 0 )
				return p;
		}
		if( insert < 0 ) {
			insert = pipes.length;
			#if hl
			var pipes2 = new hl.NativeArray(pipes.length + 1);
			pipes2.blit(0, pipes, 0, insert);
			cache.set(hash, pipes2);
			pipes = pipes2;
			#end
		}
		var cp = new CachedPipeline<T>();
		cp.bytes = signature.sub(0, signatureSize);
		cp.size = signatureSize;
		pipes[insert] = cp;
		return cp;
	}
}

/**
	Records the pipeline keys used by each shader so that their pipelines can be created as soon
	as the shader is compiled on the next run, instead of on its first draw.
**/
class PipelineConfigCache {
	static inline var MAX_SIGN_SIZE = 1024;
	static inline var MAX_PIPELINES_PER_SHADER = 4096;
	public static var VERSION = 1;

	var file : String;
	var outputFile : String;
	var dynamicStates : haxe.EnumFlags<PipelineDynamicState>;
	var configs : Map<String, Array<haxe.io.Bytes>>;
	var loadFailed = false;
	var canSave = true;
	public var allowSave = true;

	var magic : String;
	var isDirty = false;
	#if heaps_mt_hxsl_cache
	var mutex = new sys.thread.Mutex();
	#end

	public function new( file : String, ?outputFile : String ) {
		this.file = file;
		this.outputFile = outputFile ?? file;
		magic = 'PCFG-$VERSION';
	}

	static var INST : PipelineConfigCache;

	public static function get() {
		return INST;
	}

	public static function set( cache : PipelineConfigCache ) {
		INST = cache;
	}

	public function load( ?dynamicStates : haxe.EnumFlags<PipelineDynamicState> ) {
		this.dynamicStates = dynamicStates ?? new haxe.EnumFlags();
		configs = [];
		loadFailed = false;
		loadFile(file);
		if( outputFile != file )
			loadFile(outputFile);
	}

	function loadFile( file : String ) {
		try {
			if( !sys.FileSystem.exists(file) )
				return;
			var cache = new haxe.io.BytesInput(sys.io.File.getBytes(file));
			if( cache.length < magic.length || cache.readString(magic.length) != magic )
				return;
			while( cache.position < cache.length ) {
				var shaderSignSize = cache.readInt32();
				if( shaderSignSize <= 0 || shaderSignSize > MAX_SIGN_SIZE )
					return;
				var shaderSign = cache.readString(shaderSignSize);
				var cachedCount = cache.readInt32();
				if( cachedCount < 0 || cachedCount > MAX_PIPELINES_PER_SHADER )
					return;
				var pipelines = configs.get(shaderSign);
				if( pipelines == null ) {
					pipelines = [];
					configs.set(shaderSign, pipelines);
				}
				for( i in 0...cachedCount ) {
					var byteSize = cache.readInt32();
					if( byteSize <= 0 || byteSize > 64 )
						return;
					var bytes = cache.read(byteSize);
					var found = false;
					for( p in pipelines )
						if( p.compare(bytes) == 0 ) {
							found = true;
							break;
						}
					if( !found )
						pipelines.push(bytes);
				}
			}
		} catch( e : Dynamic ) {
			trace("Failed to load pipeline cache, keeping partial contents: " + e);
			loadFailed = true;
		}
	}

	/**
		Calls `create` once per recorded pipeline key of this shader, with a builder holding that key.
	**/
	public function resolveConfig( shader : hxsl.RuntimeShader, inputCount : Int, create : PipelineBuilder -> Void ) {
		#if heaps_mt_hxsl_cache
		mutex.acquire();
		var pipelines = configs.get(shader.signature)?.copy();
		mutex.release();
		#else
		var pipelines = configs.get(shader.signature);
		#end
		if( pipelines == null )
			return;
		var builder = new PipelineBuilder(dynamicStates);
		for( sign in pipelines ) @:privateAccess {
			if( (sign.length - PipelineBuilder.PSIGN_LAYOUT) >> PipelineBuilder.SHIFT_PER_BUFFER != inputCount ) continue;
			builder.signature.blit(0, sign.getData(), 0, sign.length);
			create(builder);
		}
	}

	public function addConfig<T>( shader : hxsl.RuntimeShader, p : CachedPipeline<T> ) {
		if( p.size > 64 )
			throw "assert";
		#if heaps_mt_hxsl_cache
		mutex.acquire();
		addConfigUnsafe(shader, p);
		mutex.release();
		#else
		addConfigUnsafe(shader, p);
		#end
	}

	function addConfigUnsafe<T>( shader : hxsl.RuntimeShader, p : CachedPipeline<T> ) {
		var pipelines = configs.get(shader.signature);
		if( pipelines == null ) {
			pipelines = [];
			configs.set(shader.signature, pipelines);
		}
		if( pipelines.length >= MAX_PIPELINES_PER_SHADER )
			return;
		var bytes = p.bytes.toBytes(p.size);
		for( existing in pipelines )
			if( existing.length == bytes.length && existing.compare(bytes) == 0 )
				return;
		pipelines.push(bytes);
		isDirty = true;
	}

	public function save() {
		if( configs == null || !allowSave || !canSave || !isDirty )
			return;
		if( loadFailed ) // Do not overwrite cache if loading failed due to IO exception (not corrupted file)
			return;

		var out = new haxe.io.BytesOutput();
		out.writeString(magic);
		#if heaps_mt_hxsl_cache
		mutex.acquire();
		#end
		var signs = [for( s in configs.keys() ) s];
		signs.sort(Reflect.compare);
		for( sign in signs ) {
			var pipelines = configs.get(sign);
			var signBytes = haxe.io.Bytes.ofString(sign);
			out.writeInt32(signBytes.length);
			out.write(signBytes);
			out.writeInt32(pipelines.length);
			for( p in pipelines ) {
				out.writeInt32(p.length);
				out.write(p);
			}
		}
		#if heaps_mt_hxsl_cache
		mutex.release();
		#end

		try {
			var tmpPath = outputFile + ".tmp";
			sys.io.File.saveBytes(tmpPath, out.getBytes());
			if( sys.FileSystem.exists(outputFile) )
				sys.FileSystem.deleteFile(outputFile);
			sys.FileSystem.rename(tmpPath, outputFile);
			isDirty = false;
		} catch( e : Dynamic ) {
			trace("Failed to save pipeline cache: " + e);
			canSave = false;
		}
	}
}
#end
