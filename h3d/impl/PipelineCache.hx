package h3d.impl;

@:generic class CachedPipeline<T> {
	public var bytes : hl.Bytes;
	public var size : Int;
	public var pipeline : T;
	public function new() {
	}
}

@:forward(get,set)
abstract PipelineCache<T>(Map<Int,hl.NativeArray<CachedPipeline<T>>>) {

	public function new() {
		this = new Map();
	}

}

class PipelineBuilder {

	static inline var PSIGN_MATID = 0;
	static inline var PSIGN_COLOR_MASK = PSIGN_MATID + 4;
	static inline var PSIGN_UNUSED = PSIGN_COLOR_MASK + 1;
	static inline var PSIGN_STENCIL_MASK = PSIGN_UNUSED + 1;
	static inline var PSIGN_STENCIL_OPS = PSIGN_STENCIL_MASK + 2;
	static inline var PSIGN_RENDER_TARGETS = PSIGN_STENCIL_OPS + 4;
	static inline var PSIGN_LAYOUT = PSIGN_RENDER_TARGETS + 8;
	static inline var MAX_BUFFERS = 8;
	static inline var PSIGN_SIZE = PSIGN_LAYOUT + MAX_BUFFERS * 2;

	public var needFlush : Bool;
	var signature = new hl.Bytes(64);
	var adlerOut = new hl.Bytes(4);
	var tmpPass = new h3d.mat.Pass("");
	var tmpStencil = new h3d.mat.Stencil();

	public function new() {
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
		default: throw "Unsupported RT format "+tex.format;
		}
	}

	public inline function setShader( sh : hxsl.RuntimeShader ) {
		needFlush = true;
	}

	public function setRenderTarget( tex : h3d.mat.Texture, depthEnabled : Bool ) {
		signature.setI32(PSIGN_RENDER_TARGETS, tex == null ? 0 : getRTBits(tex) | (depthEnabled ? 0x80000000 : 0));
		needFlush = true;
	}

	public function setDepth( depth : h3d.mat.Texture ) {
		signature.setI32(PSIGN_RENDER_TARGETS, 0x80000000);
		needFlush = true;
	}

	public function setRenderTargets( textures : Array<h3d.mat.Texture>, depthEnabled : Bool ) {
		var bits = 0;
		for( i => t in textures )
			bits |= getRTBits(t) << (i << 2);
		signature.setI32(PSIGN_RENDER_TARGETS, bits | (depthEnabled ? 0x80000000 : 0));
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

	public inline function setBuffer( i : Int, inf : hxd.BufferFormat.BufferMapping ) {
		signature.setUI16(PSIGN_LAYOUT + (i<<1), (inf.offset << 1) | inf.precision.toInt());
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
		var b = signature.getUI16(PSIGN_LAYOUT + (i<<1));
		return new hxd.BufferFormat.BufferMapping(i, (b >> 1) & ~3, @:privateAccess new hxd.BufferFormat.Precision(b & 7));
	}

	public function lookup<T>( cache : PipelineCache<T>, inputs : Int ) : CachedPipeline<T> {
		needFlush = false;
		var signature = signature;
		var signatureSize = PSIGN_LAYOUT + (inputs << 1);
		adlerOut.setI32(0, 0);
		hl.Format.digest(adlerOut, signature, signatureSize, 3);
		var hash = adlerOut.getI32(0);
		var pipes = cache.get(hash);
		if( pipes == null ) {
			pipes = new hl.NativeArray(1);
			cache.set(hash, pipes);
		}
		var insert = -1;
		for( i in 0...pipes.length ) {
			var p = pipes[i];
			if( p == null ) {
				insert = i;
				break;
			}
			if( p.size == signatureSize && p.bytes.compare(0, signature, 0, signatureSize) == 0 )
				return p;
		}
		var signatureBytes = @:privateAccess new haxe.io.Bytes(signature, signatureSize);
		if( insert < 0 ) {
			var pipes2 = new hl.NativeArray(pipes.length + 1);
			pipes2.blit(0, pipes, 0, insert);
			cache.set(hash, pipes2);
			pipes = pipes2;
		}
		var cp = new CachedPipeline<T>();
		cp.bytes = signature.sub(0, signatureSize);
		cp.size = signatureSize;
		pipes[insert] = cp;
		return cp;
	}


}