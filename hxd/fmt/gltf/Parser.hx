package hxd.fmt.gltf;
import haxe.io.BytesInput;
import haxe.io.Bytes;
using hxd.fmt.gltf.Data;

typedef Chunk = {
	var length : Int;
	var type : Int;
	var data : Bytes;
}

class Parser {
	public static var MAGIC_FLAG = 0x46546C67;

	public static var JSON_CHUNK_TYPE_FLAG = 0x4E4F534A;
	public static var BIN_CHUNK_TYPE_FLAG = 0x004E4942;

	public function new() {
	}

	public function parseBytes(bytes : Bytes) : hxd.fmt.gltf.Data.GltfDocument {
		var input = new BytesInput(bytes);
		input.bigEndian = false;

		var magic = input.readInt32();
		var version = input.readInt32();
		var length = input.readInt32();

		if (magic != MAGIC_FLAG)
			throw "Not a GLTF file";

		var chunks = [];
		while (input.position < length) {
			var c : Chunk = { length: 0, type: 0, data: null };
			c.length = input.readInt32();
			c.type = input.readInt32();
			c.data = input.read(c.length);
        	chunks.push(c);
        }

		// Parse JSON chunk
		if (chunks[0].type != JSON_CHUNK_TYPE_FLAG)
			throw "First chunk of the file should be JSON Chunk";

		var jsonChunk = chunks[0];
		var gltfDocument : GltfDocument = haxe.format.JsonParser.parse(jsonChunk.data.toString());
		return gltfDocument;
	}

	public static inline function parse(data : Bytes) : GltfDocument {
		return new Parser().parseBytes(data);
	}

}