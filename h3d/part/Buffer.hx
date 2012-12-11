package h3d.part;

class Buffer extends h3d.prim.Primitive {
	
	static inline var STRIDE = 8;
	
	public var maxVert(default,null) : Int;
	public var nvert(default, null) : Int;
	public var isQuads : Bool;
	var data : flash.utils.ByteArray;

	public function new() {
		data = new flash.utils.ByteArray();
		data.endian = flash.utils.Endian.LITTLE_ENDIAN;
		data.length = 1024;
		maxVert = Std.int(data.length / (STRIDE * 4));
	}

	public function synchronize( parts : Array<Particle> ) {
		nvert = 0;
		flash.Memory.select(data);
		var pos = 0;
		for( p in parts ) {
			var v = p.verts;
			while( v != null ) {
				if( nvert == maxVert ) {
					data.length += STRIDE * 4;
					maxVert++;
				}
				flash.Memory.setFloat(pos, p.x); pos += 4;
				flash.Memory.setFloat(pos, p.y); pos += 4;
				flash.Memory.setFloat(pos, p.z); pos += 4;
				flash.Memory.setFloat(pos, v.u); pos += 4;
				flash.Memory.setFloat(pos, v.v); pos += 4;
				flash.Memory.setFloat(pos, v.dx); pos += 4;
				flash.Memory.setFloat(pos, v.dy); pos += 4;
				flash.Memory.setFloat(pos, p.light); pos += 4;
				nvert++;
				v = v.next;
			}
		}
		if( buffer != null ) {
			if( buffer.nvert < nvert )
				dispose();
			else
				buffer.upload(data, 0, nvert);
		}
	}
	
	override function alloc( engine : h3d.Engine ) {
		dispose();
		buffer = engine.mem.alloc(nvert, STRIDE, isQuads ? 4 : 3);
		buffer.upload(data, 0, nvert);
	}

	override function render(engine) {
		if( buffer == null ) alloc(engine);
		if( isQuads )
			engine.renderQuadBuffer(buffer);
		else
			engine.renderTriBuffer(buffer);
	}

}
