package hxd.fs;

class ConvertFont extends Convert {
	public function new() {
		super("fnt", "bfnt");
	}

	inline static function parseCode( code : String ) : Int {
		return StringTools.startsWith(code, "&#") ? Std.parseInt(code.substr(2,code.length-3)) : haxe.Utf8.charCodeAt(code,0);
	}

	override function convert() {
		if( srcBytes.getInt32(0) != 0x6D783F3C ){
			save(srcBytes);
			return;
		}

		var xml = Xml.parse(srcBytes.toString()).firstElement();
		var fast = new haxe.xml.Fast(xml);

		var out = new haxe.io.BytesOutput();
		out.writeString("BFNT");
		out.writeByte(0);
		out.writeByte(1); // version
		writeString(out, fast.att.family);
		writeString(out, fast.att.style);
		writeByte(out, Std.parseInt(fast.att.size));
		writeByte(out, Std.parseInt(fast.att.height));

		var kernings = new Map();
		for( char in fast.nodes.Char ){
			var prev = parseCode(char.att.code);
			for( k in char.nodes.Kerning ){
				var next = parseCode(k.att.id);
				var adv = Std.parseInt(k.att.advance);
				var arr = kernings.get(next);
				if( arr == null ) 
					kernings.set(next, arr=[]);
				arr.push({prev: prev, adv: adv});
			}
		}

		for( char in fast.nodes.Char ){
			var code = parseCode(char.att.code);
			if( code > 0xFFFF )
				throw "Invalid charcode";
			writeUInt16(out, code);
			writeByte(out, Std.parseInt(char.att.width));
			var offset = char.att.offset.split(" ").map(Std.parseInt);
			writeInt8(out, offset[0]);
			writeInt8(out, offset[1]);
			var rect = char.att.rect.split(" ").map(Std.parseInt);
			writeUInt16(out, rect[0]);
			writeUInt16(out, rect[1]);
			writeByte(out, rect[2]);
			writeByte(out, rect[3]);

			var karr = kernings.get(code);
			if( karr != null ) 
				for( k in karr ){
					writeUInt16(out, k.prev);
					writeInt8(out, k.adv);
				}
			writeUInt16(out, 0);
		}

		save(out.getBytes());
	}

	static function writeUInt16( out : haxe.io.BytesOutput, i : Int ){
		if( i < 0 || i > 0xFFFF ) throw "Invalid value: "+i;
		out.writeUInt16(i);
	}

	static function writeByte( out : haxe.io.BytesOutput, i : Int ){
		if( i < 0 || i > 0xFF ) throw "Invalid value: "+i;
		out.writeByte(i);
	}

	static function writeInt8( out : haxe.io.BytesOutput, i : Int ){
		if( i < -128 || i > 127 ) throw "Invalid value: "+i;
		out.writeInt8(i);
	}

	static function writeString( out : haxe.io.BytesOutput, s : String ){
		if( s == null || s.length == 0 ) throw "Invalid string";
		var b = haxe.io.Bytes.ofString(s);
		if( b.length > 0xFFFF )
			throw "Invalid string";
		if( b.length < 0xFF ){
			out.writeByte(b.length);
		}else{
			out.writeByte(0xFF);
			out.writeUInt16(b.length);
		}
		out.writeBytes(b,0,b.length);
	}

}