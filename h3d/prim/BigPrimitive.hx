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
	var bounds : h3d.col.Bounds;

	public function new(stride) {
		buffers = [];
		allIndexes = [];
		bounds = new h3d.col.Bounds();
		this.stride = stride;
		if( stride < 3 ) throw "Minimum stride = 3";
	}

	public function begin(count) {
		if( currentVerticesCount() + count >= 65535 )
			flush();
		if( tmpBuf == null ) {
			tmpBuf = new hxd.FloatBuffer();
			tmpIdx = new hxd.IndexBuffer();
		}
	}

	public function currentVerticesCount() {
		return tmpBuf == null ? 0 : Std.int(tmpBuf.length / stride);
	}

	public inline function addPoint(x, y, z) {
		tmpBuf.push(x);
		tmpBuf.push(y);
		tmpBuf.push(z);
		bounds.addPos(x, y, z);
	}

	public inline function addBounds(x, y, z) {
		bounds.addPos(x, y, z);
	}

	public inline function addVerticeValue(v) {
		tmpBuf.push(v);
	}

	public inline function addIndex(i) {
		tmpIdx.push(i);
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
				var b = h3d.Buffer.ofFloats(tmpBuf, stride);
				if( stride < 8 ) b.flags.set(RawFormat);
				buffers.push(b);
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

	override function getBounds() {
		return bounds;
	}

	override function dispose() {
		clear();
	}

	public function clear() {
		bounds.empty();
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
		return addSub(buf, idx, 0, 0, Std.int(buf.length / (stride < 0 ? this.stride : stride)), Std.int(idx.length / 3), dx, dy, dz, rotation, scale, stride);
	}

	public function addSub( buf : hxd.FloatBuffer, idx : hxd.IndexBuffer, startVert, startTri, nvert, triCount, dx : Float = 0. , dy : Float = 0., dz : Float = 0., rotation = 0., scale = 1., stride = -1, deltaU = 0., deltaV = 0. ) {
		if( tmpBuf == null ) {
			tmpBuf = new hxd.FloatBuffer();
			tmpIdx = new hxd.IndexBuffer();
		}
		if( stride < 0 ) stride = this.stride;
		var start = Std.int(tmpBuf.length / this.stride);
		if( start + nvert >= 65535 ) {
			if( nvert >= 65535 ) throw "Too many vertices in buffer";
			flush();
			tmpBuf = new hxd.FloatBuffer();
			tmpIdx = new hxd.IndexBuffer();
			start = 0;
		}
		var cr = Math.cos(rotation);
		var sr = Math.sin(rotation);
		if( stride < this.stride ) throw "only stride >= " + this.stride+" allowed";
		for( i in 0...nvert ) {
			var p = (i + startVert) * stride;
			var x = buf[p++];
			var y = buf[p++];
			var z = buf[p++];
			var tx = (x * cr - y * sr) * scale;
			var ty = (x * sr + y * cr) * scale;

			var vx = dx + tx;
			var vy = dy + ty;
			var vz = dz + z * scale;
			tmpBuf.push(vx);
			tmpBuf.push(vy);
			tmpBuf.push(vz);
			bounds.addPos(vx, vy, vz);

			switch( this.stride ) {
			case 3:
				continue;
			case 4:
				tmpBuf.push(buf[p++]);
			case 5:
				// assume no normal
				tmpBuf.push(buf[p++] + deltaU);
				tmpBuf.push(buf[p++] + deltaV);
			case 6:
				var nx = buf[p++];
				var ny = buf[p++];
				var nz = buf[p++];
				var tnx = nx * cr - ny * sr;
				var tny = nx * sr + ny * cr;
				tmpBuf.push(tnx);
				tmpBuf.push(tny);
				tmpBuf.push(nz);
			case 7:
				var nx = buf[p++];
				var ny = buf[p++];
				var nz = buf[p++];
				var tnx = nx * cr - ny * sr;
				var tny = nx * sr + ny * cr;
				tmpBuf.push(tnx);
				tmpBuf.push(tny);
				tmpBuf.push(nz);
				tmpBuf.push(buf[p++]);
			default:
				var nx = buf[p++];
				var ny = buf[p++];
				var nz = buf[p++];
				var tnx = nx * cr - ny * sr;
				var tny = nx * sr + ny * cr;
				tmpBuf.push(tnx);
				tmpBuf.push(tny);
				tmpBuf.push(nz);

				// UV
				tmpBuf.push(buf[p++] + deltaU);
				tmpBuf.push(buf[p++] + deltaV);

				for( i in 8...this.stride )
					tmpBuf.push(buf[p++]);
			}
		}
		start -= startVert;
		for( i in 0...triCount * 3 )
			tmpIdx.push(idx[i+startTri*3] + start);
	}

}