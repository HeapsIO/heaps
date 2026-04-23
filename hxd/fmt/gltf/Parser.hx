package hxd.fmt.gltf;
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

	public function parseBytes(bytes : Bytes) : GltfNode {
		var pos = 0;
		if (bytes.getInt32(pos) != MAGIC_FLAG)
			throw "Not a GLTF file";
		pos += 4;
		var version = bytes.getInt32(pos);
		pos += 4;
		var length = bytes.getInt32(pos);
		pos += 4;

		var chunks : Array<Chunk> = [];
		while (pos < length) {
			var c : Chunk = { length: 0, type: 0, data: null };
			c.length = bytes.getInt32(pos);
			c.type = bytes.getInt32(pos + 4);
			c.data = bytes.sub(pos + 8, c.length);
			chunks.push(c);

			// chunks.push({ length: bytes.getInt32(pos), type: bytes.getInt32(pos + 4), data: bytes.sub(pos + 8, bytes.getInt32(pos + 4)) });
			pos += 4 + 4 + c.length;
		}

		// Parse JSON chunk
		if (chunks[0].type != JSON_CHUNK_TYPE_FLAG)
			throw "First chunk of the file should be JSON Chunk";

		var jsonChunk = chunks[0];

		return null;
	}

	public function parseText(str : String) : GltfNode {
		return null;
	}

	public static inline function parse(data : Bytes) : GltfNode {
		return new Parser().parseBytes(data);
	}

}