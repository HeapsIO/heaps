package hxd.fmt.blend;

// Ported from https://github.com/armory3d/blend


class Blend {

	public var pos:Int;
	var bytes: haxe.io.Bytes;

	// Header
	public var version:String;
	public var pointerSize:Int;
	public var littleEndian:Bool;
	// Data
	public var blocks:Array<Block> = [];
	public var dna:Dna;

	public function new(bytes: haxe.io.Bytes) {
		this.bytes = bytes;
		this.pos = 0;

		if (readChars(7) == 'BLENDER') parse();
		// else decompress();
	}

	public function dir(type:String):Array<String> {
		// Return structure fields
		var typeIndex = getTypeIndex(dna, type);
		if (typeIndex == -1) return null;
		var ds = getStruct(dna, typeIndex);
		var fields:Array<String> = [];
		for (i in 0...ds.fieldNames.length) {
			var nameIndex = ds.fieldNames[i];
			var typeIndex = ds.fieldTypes[i];
			fields.push(dna.types[typeIndex] + ' ' + dna.names[nameIndex]);
		}
		return fields;
	}

	public function get(type:String):Array<Handle> {
		// Return all structures of type
		var typeIndex = getTypeIndex(dna, type);
		if (typeIndex == -1) return null;
		var ds = getStruct(dna, typeIndex);
		var handles:Array<Handle> = [];
		for (b in blocks) {
			if (dna.structs[b.sdnaIndex].type == typeIndex) {
				var h = new Handle();
				handles.push(h);
				h.block = b;
				h.ds = ds;
			}
		}
		return handles;
	}

	public static function getStruct(dna:Dna, typeIndex:Int):DnaStruct {
		for (ds in dna.structs) if (ds.type == typeIndex) return ds;
		return null;
	}

	public static function getTypeIndex(dna:Dna, type:String):Int {
		for (i in 0...dna.types.length) if (type == dna.types[i]) { return i; }
		return -1;
	}

	function parse() {

		// Pointer size: _ 32bit, - 64bit
		pointerSize = readChar() == '_' ? 4 : 8;

		// v - little endian, V - big endian
		littleEndian = readChar() == 'v';
		if (littleEndian) {
			read16 = read16LE;
			read32 = read32LE;
		}
		else {
			read16 = read16BE;
			read32 = read32BE;
		}

		version = readChars(3);

		// Reading file blocks
		// Header - data
		while (pos < bytes.length) {

			align();

			var b = new Block();

			// Block type
			b.code = readChars(4);

			if (b.code == 'ENDB') break;

			blocks.push(b);
			b.blend = this;

			// Total block length
			b.size = read32();

			// var addr;
			pos += pointerSize;

			// Index of dna struct contained in this block
			b.sdnaIndex = read32();

			// Number of dna structs in this block
			b.count = read32();

			b.pos = pos;

			// This block stores dna structures
			if (b.code == 'DNA1') {
				dna = new Dna();

				var id = readChars(4); // SDNA
				var nameId = readChars(4); // NAME
				var namesCount = read32();
				for (i in 0...namesCount) {
					dna.names.push(readString());
				}
				align();


				var typeId = readChars(4); // TYPE
				var typesCount = read32();
				for (i in 0...typesCount) {
					dna.types.push(readString());
				}
				align();


				var lenId = readChars(4); // TLEN
				for (i in 0...typesCount) {
					dna.typesLength.push(read16());
				}
				align();


				var structId = readChars(4); // STRC
				var structCount = read32();
				for (i in 0...structCount) {
					var ds = new DnaStruct();
					dna.structs.push(ds);
					ds.dna = dna;
					ds.type = read16();
					var fieldCount = read16();
					if (fieldCount > 0) {
						ds.fieldTypes = [];
						ds.fieldNames = [];
						for (j in 0...fieldCount) {
							ds.fieldTypes.push(read16());
							ds.fieldNames.push(read16());
						}
					}
				}
			}
			else {
				pos += b.size;
			}
		}
	}

	function align() {
		// 4 bytes aligned
		var mod = pos % 4;
		if (mod > 0) pos += 4 - mod;
	}

	public function read8():Int {
		var i = bytes.get(pos);
		pos += 1;
		return i;
	}

	public var read16:Void->Int;
	public var read32:Void->Int;

	function read16LE():Int {
        var first = bytes.get(pos + 0);
		var second  = bytes.get(pos + 1);
		var sign = (second & 0x80) == 0 ? 1 : -1;
		second = second & 0x7F;
		pos += 2;
		if (sign == -1) return -0x7fff + second * 256 + first;
		else return second * 256 + first;
	}

	function read32LE():Int {
		var fourth = bytes.get(pos + 0);
		var third  = bytes.get(pos + 1);
		var second = bytes.get(pos + 2);
		var first  = bytes.get(pos + 3);
		var sign = (first & 0x80) == 0 ? 1 : -1;
		first = first & 0x7F;
		pos += 4;
		if (sign == -1) return -0x7fffffff + fourth + third * 256 + second * 256 * 256 + first * 256 * 256 * 256;
		else return fourth + third * 256 + second * 256 * 256 + first * 256 * 256 * 256;
	}

	function read16BE():Int {
		var first = bytes.get(pos + 0);
		var second  = bytes.get(pos + 1);
		pos += 2;
		var sign = (first & 0x80) == 0 ? 1 : -1;
		first = first & 0x7F;
		if (sign == -1) return -0x7fff + first * 256 + second;
		else return first * 256 + second;
	}

	function read32BE():Int {
		var fourth = bytes.get(pos + 0);
		var third  = bytes.get(pos + 1);
		var second = bytes.get(pos + 2);
		var first  = bytes.get(pos + 3);
		var sign = (fourth & 0x80) == 0 ? 1 : -1;
		fourth = fourth & 0x7F;
		pos += 4;
		if (sign == -1) return -0x7fffffff + first + second * 256 + third * 256 * 256 + fourth * 256 * 256 * 256;
		return first + second * 256 + third * 256 * 256 + fourth * 256 * 256 * 256;
	}

	public function readString():String {
		var s = '';
		while (true) {
			var ch = read8();
			if (ch == 0) break;
			s += String.fromCharCode(ch);
		}
		return s;
	}

	public function readChars(len:Int):String {
		var s = '';
		for (i in 0...len) s += readChar();
		return s;
	}

	public function readChar():String {
		return String.fromCharCode(read8());
	}
}

class Block {
	public var blend:Blend;
	public var code:String;
	public var size:Int;
	// public var addr:Dynamic;
	public var sdnaIndex:Int;
	public var count:Int;
	public var pos:Int; // Byte pos of data start in blob
	public function new() {}
}

class Dna {
	public var names:Array<String> = [];
	public var types:Array<String> = [];
	public var typesLength:Array<Int> = [];
	public var structs:Array<DnaStruct> = [];
	public function new() {}
}

class DnaStruct {
	public var dna:Dna;
	public var type:Int; // Index in dna.types
	public var fieldTypes:Array<Int>; // Index in dna.types
	public var fieldNames:Array<Int>; // Index in dna.names
	public function new() {}
}

class Handle {
	public var block:Block;
	public var offset:Int = 0; // Block data bytes offset
	public var ds:DnaStruct;
	public function new() {}
	function getSize(index:Int):Int {
		var nameIndex = ds.fieldNames[index];
		var typeIndex = ds.fieldTypes[index];
		var dna = ds.dna;
		var n = dna.names[nameIndex];
		var size = 0;
		if (n.indexOf('*') >= 0) size = block.blend.pointerSize;
		else size = dna.typesLength[typeIndex];
		if (n.indexOf('[') > 0) size *= Std.parseInt(n.substring(n.indexOf('[') + 1, n.indexOf(']')));
		return size;
	}
	function baseName(s:String):String {
		if (s.charAt(0) == '*') s = s.substring(1, s.length);
		if (s.charAt(s.length - 1) == ']') s = s.substring(0, s.indexOf('['));
		return s;
	}
	public function get(name:String):Dynamic {
		// Return raw type or structure
		var dna = ds.dna;
		for (i in 0...ds.fieldNames.length) {
			var nameIndex = ds.fieldNames[i];
			var dnaName = dna.names[nameIndex];
			if (name == baseName(dnaName)) {
				var typeIndex = ds.fieldTypes[i];
				var type = dna.types[typeIndex];
				var newOffset = offset;
				for (j in 0...i) newOffset += getSize(j);
				// Raw type
				if (typeIndex < 12) {
					var blend = block.blend;
					blend.pos = block.pos + newOffset;
					if (type == 'int') return blend.read32();
					else if (type == 'char') {
						var isString = dnaName.charAt(dnaName.length - 1) == ']';
						return isString ? blend.readString() : blend.read8();
					}
					else if (type == 'uchar') { return blend.read8(); }
					else if (type == 'short') { return blend.read16(); }
					else if (type == 'ushort') { return blend.read16(); }
					else if (type == 'long') { return blend.read32(); }
					else if (type == 'ulong') { return blend.read32(); }
					else if (type == 'float') { return blend.read32(); }
					else if (type == 'double') { return 0; } //blend.read64(); }
					else if (type == 'int64_t') { return 0; } //blend.read64(); }
					else if (type == 'uint64_t') { return 0; } //blend.read64(); }
					else if (type == 'void') { return 0; }
				}
				// Structure
				var h = new Handle();
				h.ds = Blend.getStruct(dna, typeIndex);
				h.block = block;
				h.offset = newOffset;
				return h;
			}
		}
		return null;
	}
}