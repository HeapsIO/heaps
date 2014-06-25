package h3d.prim;

/**
	Enable to add more than 65K triangles into a single primitive.
**/
class BigPrimitive extends Primitive {

	var stride : Int;
	var buffers : Array<Buffer>;
	var allIndexes : Array<Indexes>;
	var tmpBuf : hxd.FloatBuffer;
	var tmpIdx : hxd.IndexBuffer;

	public function new(stride) {
		buffers = [];
		allIndexes = [];
		this.stride = stride;
		if( stride < 3 ) throw "Minimum stride = 3";
	}

	override function triCount() {
		var count = 0;
		for( i in allIndexes )
			count += i.count;
		if( tmpIdx != null )
			count += tmpIdx.length;
		return Std.int(count/3);
	}

	public function flush() {
		if( tmpBuf != null ) {
			if( tmpBuf.length > 0 && tmpIdx.length > 0 ) {
				buffers.push(h3d.Buffer.ofFloats(tmpBuf, stride));
				allIndexes.push(h3d.Indexes.alloc(tmpIdx));
			}
			tmpBuf = null;
			tmpIdx = null;
		}
	}

	override function render( engine : h3d.Engine ) {
		if( tmpBuf != null ) flush();
		for( i in 0...buffers.length )
			engine.renderIndexed(buffers[i],allIndexes[i]);
	}

	override function dispose() {
		clear();
	}

	public function clear() {
		for( b in buffers )
			b.dispose();
		for( i in allIndexes )
			i.dispose();
		buffers = [];
		allIndexes = [];
		tmpBuf = null;
		tmpIdx = null;
	}

	public function add( buf : hxd.FloatBuffer, idx : hxd.IndexBuffer, dx : Float = 0. , dy : Float = 0., dz : Float = 0., rotation = 0., scale = 1., stride = -1 ) {
		if( tmpBuf == null ) {
			tmpBuf = new hxd.FloatBuffer();
			tmpIdx = new hxd.IndexBuffer();
		}
		if( stride < 0 ) stride = this.stride;
		var start = Std.int(tmpBuf.length / this.stride);
		var nvert = Std.int(buf.length / stride);
		if( start + nvert >= 65535 ) {
			if( nvert >= 65535 ) throw "Too many vertices in buffer";
			flush();
			tmpBuf = new hxd.FloatBuffer();
			tmpIdx = new hxd.IndexBuffer();
		}
		var cr = Math.cos(rotation);
		var sr = Math.sin(rotation);
		if( stride < this.stride ) throw "only stride >= " + this.stride+" allowed";
		for( i in 0...nvert ) {
			var p = i * stride;
			var x = buf[p++];
			var y = buf[p++];
			var z = buf[p++];
			var tx = (x * cr - y * sr) * scale;
			var ty = (x * sr + y * cr) * scale;
			tmpBuf.push(dx + tx);
			tmpBuf.push(dy + ty);
			tmpBuf.push(dz + z * scale);
			switch( this.stride ) {
			case 3:
				continue;
			case 4:
				tmpBuf.push(buf[p++]);
			case 5:
				tmpBuf.push(buf[p++]);
				tmpBuf.push(buf[p++]);
			case 6:
				tmpBuf.push(buf[p++]);
				tmpBuf.push(buf[p++]);
				tmpBuf.push(buf[p++]);
			case 7:
				tmpBuf.push(buf[p++]);
				tmpBuf.push(buf[p++]);
				tmpBuf.push(buf[p++]);
				tmpBuf.push(buf[p++]);
			default:
				// UV
				tmpBuf.push(buf[p++]);
				tmpBuf.push(buf[p++]);
				var nx = buf[p++];
				var ny = buf[p++];
				var nz = buf[p++];
				var tnx = nx * cr - y * sr;
				var tny = nx * sr + y * cr;
				tmpBuf.push(tnx);
				tmpBuf.push(tny);
				tmpBuf.push(nz);
				for( i in 8...this.stride )
					tmpBuf.push(buf[p++]);
			}
		}
		for( i in idx )
			tmpIdx.push(i + start);
	}

}