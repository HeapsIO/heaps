package hxd.fmt.gltf;
import haxe.io.Bytes;
import hxd.fmt.gltf.Data;
class Parser extends hxd.fmt.Parser<Data> {

	public static inline var MAGIC = 0x46546C67; // "glTF"
	public static inline var CHUNK_JSON = 0x4E4F534A;
	public static inline var CHUNK_BIN = 0x004E4942;

	public function read( bytes : Bytes ) : Data {
		if( bytes.length >= 12 && bytes.getInt32(0) == MAGIC )
			return readBinary(bytes);
		return new Data(parseJson(bytes.toString()));
	}

	function readBinary( bytes : Bytes ) : Data {
		var version = bytes.getInt32(4);
		if( version != 2 )
			throw "Unsupported GLB version " + version + " (glTF 2.0 required)";
		var length = bytes.getInt32(8);
		if( length > bytes.length )
			throw "Truncated GLB file";

		var doc : GltfDocument = null;
		var bin : Bytes = null;
		var pos = 12;
		while( pos + 8 <= length ) {
			var chunkLength = bytes.getInt32(pos);
			var chunkType = bytes.getInt32(pos + 4);
			pos += 8;
			if( pos + chunkLength > length )
				throw "Invalid GLB chunk length";
			switch( chunkType ) {
				case CHUNK_JSON:
					if( doc != null ) throw "Multiple JSON chunks in GLB file";
					doc = parseJson(bytes.getString(pos, chunkLength));
				case CHUNK_BIN:
					if( doc == null ) throw "First chunk of a GLB file should be JSON";
					if( bin == null ) bin = bytes.sub(pos, chunkLength);
				default:
					// Unknown chunks must be ignored
			}
			pos += chunkLength;
		}
		if( doc == null )
			throw "Missing JSON chunk in GLB file";
		return new Data(doc, bin);
	}

	function parseJson( str : String ) : GltfDocument {
		var doc : GltfDocument = haxe.Json.parse(str);
		if( doc.asset == null || doc.asset.version == null )
			throw "Not a glTF file";
		if( doc.asset.version.split(".")[0] != "2" )
			throw "Unsupported glTF version " + doc.asset.version + " (glTF 2.0 required)";
		return doc;
	}

	public static function parse( data : Bytes ) : Data {
		return new Parser().read(data);
	}

}
