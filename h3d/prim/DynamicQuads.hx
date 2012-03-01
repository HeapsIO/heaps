package h3d.prim;

class DynamicQuads extends h3d.prim.Primitive {
	
	static inline var STRIDE = 5;
	
	public var size(default,null) : Int;
	public var count(default,null) : Int;
	var data : flash.utils.ByteArray;

	public function new() {
	}

	public function resize( size : Int ) {
		dispose();
		
		this.size = size;
		
		data = new flash.utils.ByteArray();
		data.length = (size * 4 * STRIDE) << 2;
		if( data.length < 1024 ) data.length = 1024;
		
		data.position = 0;
		data.endian = flash.utils.Endian.LITTLE_ENDIAN;
		for( i in 0...size ) {
			data.position += 3 * 4;
			data.writeFloat(-1.0);
			data.writeFloat(-1.0);
			data.position += 3 * 4;
			data.writeFloat(1.0);
			data.writeFloat(-1.0);
			data.position += 3 * 4;
			data.writeFloat(-1.0);
			data.writeFloat(1.0);
			data.position += 3 * 4;
			data.writeFloat(1.0);
			data.writeFloat(1.0);
		}
	}
	
	public function synchronize( parts : Array<h3d.Point> ) {
		count = parts.length;
		if( count > size ) resize(count);
		flash.Memory.select(data);
		var pos = 0;
		for( p in parts ) {
			for( i in 0...4 ) {
				flash.Memory.setFloat(pos, p.x); pos += 4;
				flash.Memory.setFloat(pos, p.y); pos += 4;
				flash.Memory.setFloat(pos, p.z); pos += 4;
				pos += 8;
			}
		}
		if( buffer != null )
			buffer.upload(data, 0, count * 4);
	}
	
	override function alloc( engine : h3d.Engine ) {
		dispose();
		buffer = engine.mem.allocSub(size * 4, STRIDE, false);
		buffer.upload(data, 0, count * 4);
	}

	override function render(engine) {
		if( buffer == null ) alloc(engine);
		engine.renderIndexes(buffer, engine.mem.quadIndexes, 2, count * 2);
	}

}
