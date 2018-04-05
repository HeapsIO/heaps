package hxd.fs;

class ConvertAtlas extends Convert {
	public function new() {
		super("atlas", "batlas");
	}

	override function convert() {
		var lines = srcBytes.toString().split("\n");

		var out = new haxe.io.BytesOutput();
		out.writeString("BATL");
		while( lines.length > 0 ) {
			var line = StringTools.trim(lines.shift());
			if ( line == "" ) continue;

			writeString(out, line);
			while( lines.length > 0 ) {
				var line = StringTools.trim(lines.shift());
				if( line == "" ) break;
				var prop = line.split(": ");
				if( prop.length > 1 ) continue;
				var key = line;
				var tileX = 0, tileY = 0, tileW = 0, tileH = 0, tileDX = 0, tileDY = 0, origW = 0, origH = 0, index = 0;
				while( lines.length > 0 ) {
					var line = StringTools.trim(lines.shift());
					var prop = line.split(": ");
					if( prop.length == 1 ) {
						lines.unshift(line);
						break;
					}
					var v = prop[1];
					switch( prop[0] ) {
					case "rotate":
						if( v == "true" ) throw "Rotation not supported in atlas";
					case "xy":
						var vals = v.split(", ");
						tileX = Std.parseInt(vals[0]);
						tileY = Std.parseInt(vals[1]);
					case "size":
						var vals = v.split(", ");
						tileW = Std.parseInt(vals[0]);
						tileH = Std.parseInt(vals[1]);
					case "offset":
						var vals = v.split(", ");
						tileDX = Std.parseInt(vals[0]);
						tileDY = Std.parseInt(vals[1]);
					case "orig":
						var vals = v.split(", ");
						origW = Std.parseInt(vals[0]);
						origH = Std.parseInt(vals[1]);
					case "index":
						index = Std.parseInt(v);
						if( index < 0 ) index = 0;
					default:
						throw "Unknown prop " + prop[0];
					}
				}
				// offset is bottom-relative
				tileDY = origH - (tileH + tileDY);

				writeString(out, key);
				writeUInt16(out, index);
				writeUInt16(out, tileX);
				writeUInt16(out, tileY);
				writeUInt16(out, tileW);
				writeUInt16(out, tileH);
				writeUInt16(out, tileDX);
				writeUInt16(out, tileDY);
				writeUInt16(out, origW);
				writeUInt16(out, origH);
			}
			out.writeByte(0);
		}
		out.writeByte(0);
		save(out.getBytes());
	}

	static function writeUInt16( out : haxe.io.BytesOutput, i : Int ){
		if( i < 0 || i > 0xFFFF ) throw "Invalid value: "+i;
		out.writeUInt16(i);
	}

	static function writeString( out : haxe.io.BytesOutput, s : String ){
		if( s == null || s.length == 0 ) throw "Invalid string";
		var b = haxe.io.Bytes.ofString(s);
		if( b.length > 0xFFFF )
			throw "Invalid string length";
		if( b.length < 0xFF ){
			out.writeByte(b.length);
		}else{
			out.writeByte(0xFF);
			out.writeUInt16(b.length);
		}
		out.writeBytes(b,0,b.length);
	}

}