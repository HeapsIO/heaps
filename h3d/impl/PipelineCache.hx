package h3d.impl;

#if !js

#if hl
@:forward(setI32,setUI8,setUI16,getUI8,getUI16,getI32,setF32,getF32,sub)
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
}

@:forward(get,set)
abstract PipelineCache<T>(Map<Int,#if hl hl.NativeArray #else Array #end<CachedPipeline<T>>>) {

	public function new() {
		this = new Map();
	}

}

class DepthProps {
	public var format : hxd.PixelFormat;
	public var bias : Single;
	public var slopeScaledBias : Single;
	public var clamp : Bool;
	public function new() {}
}

class PipelineBuilder {

	static inline var PSIGN_MATID = 0;
	static inline var PSIGN_COLOR_MASK = PSIGN_MATID + 4;
	static inline var PSIGN_DEPTH_BIAS = PSIGN_COLOR_MASK + 4;
	static inline var PSIGN_SLOPE_SCALED_DEPTH_BIAS = PSIGN_DEPTH_BIAS + 4;
	static inline var PSIGN_DEPTH_CLAMP = PSIGN_SLOPE_SCALED_DEPTH_BIAS + 4;
	static inline var PSIGN_STENCIL_MASK = PSIGN_DEPTH_CLAMP + 1;
	static inline var PSIGN_STENCIL_OPS = PSIGN_STENCIL_MASK + 2;
	static inline var PSIGN_RENDER_TARGETS = PSIGN_STENCIL_OPS + 4;
	static inline var PSIGN_DEPTH_TARGET_FORMAT = PSIGN_RENDER_TARGETS + 1;
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
	}

	static function getRTBits( tex : h3d.mat.Texture ) {
		inline function mk(channels,format) {
			return ((channels - 1) << 2) | (format + 1);
		}
		return switch( tex.format ) {
		case RGBA: mk(4,0);
		case R8: mk(1, 0);
		case RG8: mk(2, 0);
		case RGB8: mk(3, 0);
		case R16F: mk(1,1);
		case RG16F: mk(2,1);
		case RGB16F: mk(3,1);
		case RGBA16F: mk(4,1);
		case R32F: mk(1,2);
		case RG32F: mk(2,2);
		case RGB32F: mk(3,2);
		case RGBA32F: mk(4,2);
		case RG11B10UF: mk(2, 3);
		case RGB10A2: mk(3, 4);
		default: throw "Unsupported RT format "+tex.format;
		}
	}

	public inline function setShader( sh : hxsl.RuntimeShader ) {
		needFlush = sh.mode != Compute;
	}

	function setDepthProps( depth : h3d.mat.Texture ) {
		if( depth == null ) {
			signature.setI32(PSIGN_DEPTH_TARGET_FORMAT,0);
			signature.setI32(PSIGN_DEPTH_BIAS,0);
			signature.setF32(PSIGN_SLOPE_SCALED_DEPTH_BIAS,0);
			signature.setUI8(PSIGN_DEPTH_CLAMP,0);
		} else {
			signature.setI32(PSIGN_DEPTH_TARGET_FORMAT, depth.format.getIndex());
			signature.setI32(PSIGN_DEPTH_BIAS, Std.int(depth.depthBias));
			signature.setF32(PSIGN_SLOPE_SCALED_DEPTH_BIAS, depth.slopeScaledBias);
			signature.setUI8(PSIGN_DEPTH_CLAMP, depth.depthClamp ? 1 : 0);
		}
	}

	static function initFormats() {
		var fmt = [];
		for( f in ([Depth16,Depth24,Depth24Stencil8,Depth32] : Array<hxd.PixelFormat>) )
			fmt[f.getIndex()] = f;
		return fmt;
	}

	public function getDepthProps() {
		static var FORMATS = initFormats();
		var d = tmpDepth;
		d.format = FORMATS[signature.getI32(PSIGN_DEPTH_TARGET_FORMAT)];
		d.bias = signature.getI32(PSIGN_DEPTH_BIAS);
		d.clamp = signature.getUI8(PSIGN_DEPTH_CLAMP) != 0;
		d.slopeScaledBias = signature.getF32(PSIGN_SLOPE_SCALED_DEPTH_BIAS);
		return d;
	}

	public function setRenderTarget( tex : h3d.mat.Texture, depthEnabled : Bool ) {
		signature.setI32(PSIGN_RENDER_TARGETS, (tex == null ? 0 : getRTBits(tex)) | (depthEnabled ? 0x80000000 : 0));
		var depth = tex == null || !depthEnabled ? null : tex.depthBuffer;
		setDepthProps(depth);
		needFlush = true;
	}

	public function getDepthEnabled() {
		return signature.getI32(PSIGN_RENDER_TARGETS) & 0x80000000 != 0;
	}

	public function setDepth( depth : h3d.mat.Texture ) {
		signature.setI32(PSIGN_RENDER_TARGETS, 0x80000000);
		setDepthProps(depth);
		needFlush = true;
	}

	public function setRenderTargets( textures : Array<h3d.mat.Texture>, depthEnabled : Bool ) {
		var bits = 0;
		for( i => t in textures )
			bits |= getRTBits(t) << (i << 2);
		signature.setI32(PSIGN_RENDER_TARGETS, bits | (depthEnabled ? 0x80000000 : 0));
		var tex = textures[0];
		var depth = tex == null || !depthEnabled ? null : tex.depthBuffer;
		setDepthProps(depth);
		needFlush = true;
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
		if( inf.offset >= 256 ) throw "assert";
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
			#if hl
			var pipes2 = new hl.NativeArray(pipes.length + 1);
			pipes2.blit(0, pipes, 0, insert);
			cache.set(hash, pipes2);
			pipes = pipes2;
			#else
			insert = pipes.length + 1;
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
