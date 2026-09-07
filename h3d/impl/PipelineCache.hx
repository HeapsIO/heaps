package h3d.impl;

#if !js

#if hl
@:forward(setI32,setUI8,setUI16,getUI8,getUI16,getI32,setF32,getF32,sub,blit)
private abstract Bytes(hl.Bytes) from hl.Bytes to hl.Bytes {
	public function new(size) this = new hl.Bytes(size);
	public inline function compare( bytes : Bytes, size : Int ) {
		return this.compare(0, bytes, 0, size);
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
	var tmpDepth = new DepthProps();
	var tmpPass = new h3d.mat.Pass("");
	var tmpStencil = new h3d.mat.Stencil();
	#if hl
	var adlerOut = new Bytes(4);
	#end

	public function new() {
		if( PSIGN_SIZE > 64 ) throw "assert";
		setDepthBias(0, 0);
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

	function hashSign( size : Int ) {
		#if hl
		adlerOut.setI32(0, 0);
		hl.Format.digest(adlerOut, signature, size, 3);
		return adlerOut.getI32(0);
		#else
		var tot = 0;
		for( i in 0...size>>2 )
			tot = (tot * 31 + signature.getI32(i<<2)) % 0x7FFFFFFF;
		switch( size & 3 ) {
		case 0:
		case 2: tot = (tot * 31 + signature.getUI16(size - 2)) % 0x7FFFFFFF;
		default: throw "assert";
		}
		return tot;
		#end
	}

	public function lookup<T>( cache : PipelineCache<T>, inputs : Int ) : CachedPipeline<T> {
		needFlush = false;
		var signatureSize = PSIGN_LAYOUT + (inputs << SHIFT_PER_BUFFER);
		var hash = hashSign(signatureSize);
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
#end
