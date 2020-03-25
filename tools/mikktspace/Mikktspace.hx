class Mikktspace {

	static function main() {
		var args = Sys.args();
		if( args.length < 2 ) {
			Sys.println("mikkspace [input] [output] (angle)");
			Sys.exit(1);
		}

		var threshold = args.length > 2 ? Std.parseFloat(args[2]) : 180;

		var input = new haxe.io.BytesInput(sys.io.File.getBytes(args[0]));
		var m = new hl.Format.Mikktspace();
		var vertCount = input.readInt32();
		m.stride = input.readInt32();
		m.xPos = input.readInt32();
		m.normalPos = input.readInt32();
		m.uvPos = input.readInt32();
		m.buffer = input.read(vertCount * m.stride * 4);

		m.indices = input.readInt32();
		m.indexes = input.read(m.indices * 4);

		var tangents = haxe.io.Bytes.alloc(4 * 4 * vertCount);
		tangents.fill(0,tangents.length,0);
		for( i in 0...vertCount )
			tangents.setFloat(i * 16, 1);
		m.tangents = tangents;
		m.tangentStride = 4;
		m.tangentPos = 0;

		m.compute(threshold);

		sys.io.File.saveBytes(args[1], tangents);
	}

}