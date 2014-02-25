package hxd.fmt.awd;
import hxd.fmt.awd.Data;

class Reader {
	
	static inline var TTRIANGLE_GEOM = 1;
	static inline var TINSTANCE = 23;
	static inline var TSKELETON = 101;
	static inline var TSIMPLE_MATERIAL = 81;
	static inline var TBITMAP_TEXURE = 82;
	
	var i : haxe.io.BytesInput;
	var blocks : Map<Int,Block>;

	public function new() {
	}
	
	public function read( bytes ) {
		blocks = new Map();
		i = new haxe.io.BytesInput(bytes);
		var h = readHeader();
		var size = h.size;
		if( i.length - size != 12 ) throw "truncated file";
		var uBytes = null;
		switch( h.compress ) {
		case 0:
		case 1:
			var tmp = hxd.impl.Tmp.getBytes(size);
			i.readFullBytes(tmp, 0, size);
			uBytes = haxe.zip.Uncompress.run(tmp, 1 << 15);
			hxd.impl.Tmp.saveBytes(tmp);
			i = new haxe.io.BytesInput(uBytes);
		case 2:
			throw "LZMA not supported";
		default:
			throw "assert";
		}
		while( i.position < i.length )
			readBlock();
		if( uBytes != null )
			hxd.impl.Tmp.saveBytes(uBytes);
		return blocks;
	}
	
	function readHeader() {
		if( i.readString(3) != "AWD" ) throw "assert";
		var major = i.readByte();
		var minor = i.readByte();
		var flags = i.readUInt16();
		var compress = i.readByte();
		var size = i.readInt32();
		return { compress : compress, size : size };
	}
	
	function readMatrix() {
		var m = new h3d.Matrix();
		m._11 = readFloat();
		m._12 = readFloat();
		m._13 = readFloat();
		m._14 = readFloat();
		m._21 = readFloat();
		m._22 = readFloat();
		m._23 = readFloat();
		m._24 = readFloat();
		m._31 = readFloat();
		m._32 = readFloat();
		m._33 = readFloat();
		m._34 = readFloat();
		m._41 = readFloat();
		m._42 = readFloat();
		m._43 = readFloat();
		m._44 = readFloat();
		return m;
	}
	
	function readMatrix3x4() {
		var m = new h3d.Matrix();
		m._11 = readFloat();
		m._12 = readFloat();
		m._13 = readFloat();
		m._14 = 0;
		m._21 = readFloat();
		m._22 = readFloat();
		m._23 = readFloat();
		m._24 = 0;
		m._31 = readFloat();
		m._32 = readFloat();
		m._33 = readFloat();
		m._34 = 0;
		m._41 = readFloat();
		m._42 = readFloat();
		m._43 = readFloat();
		m._44 = 1;
		return m;
	}
	
	inline function readBool() {
		return i.readByte() != 0;
	}
	
	function readString() {
		return i.readString(i.readUInt16());
	}
	
	function readName() {
		var len = i.readUInt16();
		return len == 0 ? null : i.readString(len);
	}
	
	inline function readID() {
		return i.readInt32();
	}
	
	inline function readList<T>( decode : Void -> T ) : Array<T> {
		return [for( i in 0...i.readInt32() ) decode()];
	}
	
	inline function readFloat() {
		return i.readFloat();
	}
	
	function readAttrs() {
		var count = i.readInt32();
		if( count == 0 )
			return null;
		var a = new Map<String,Dynamic>();
		for( k in 0...count ) {
			var ns = i.readByte();
			var name = readString();
			var len = i.readInt32();
			var value : Dynamic = switch( i.readByte() ) {
			case 1: i.readInt8();
			case 2: i.readInt16();
			case 3, 6: i.readInt32();
			case 4: i.readByte();
			case 5: i.readUInt16();
			case 11: i.readFloat();
			case 12: i.readDouble();
			case 21: readBool();
			case 22: i.readInt32(); // color
			case 23: readID(); // block
			case 31: i.readString(len);
			case 32: i.read(len);
			case 41: new h3d.Vector(readFloat(), readFloat());
			case 42: new h3d.Vector(readFloat(), readFloat(), readFloat());
			case 43: new h3d.Vector(readFloat(), readFloat(), readFloat(), readFloat());
			case 51: // m3x2
				var m = new h3d.Matrix();
				m._11 = readFloat();
				m._12 = readFloat();
				m._13 = readFloat();
				m._14 = 0;
				m._21 = readFloat();
				m._22 = readFloat();
				m._23 = readFloat();
				m._24 = 0;
				m._31 = 0;
				m._32 = 0;
				m._33 = 0;
				m._34 = 0;
				m._41 = 0;
				m._42 = 0;
				m._43 = 0;
				m._44 = 1;
				m;
			case 52: // m3x3
				var m = new h3d.Matrix();
				m._11 = readFloat();
				m._12 = readFloat();
				m._13 = readFloat();
				m._14 = 0;
				m._21 = readFloat();
				m._22 = readFloat();
				m._23 = readFloat();
				m._24 = 0;
				m._31 = readFloat();
				m._32 = readFloat();
				m._33 = readFloat();
				m._34 = 0;
				m._41 = 0;
				m._42 = 0;
				m._43 = 0;
				m._44 = 1;
				m;
			case 53: readMatrix3x4();
			case 54: readMatrix();
			case unk:
				i.read(len);
				"?" + unk;
			}
			a.set(name, value);
		};
		return a;
	}
	
	function readSkelJoint( joints:Map<Int,Joint> ) {
		var j = new Joint(i.readUInt16());
		var pid = i.readUInt16();
		if( pid > 0 ) {
			var p = joints.get(pid);
			if( p == null ) throw "Missing parent joint #" + pid;
			j.parent = p;
		}
		j.name = readName();
		j.bindPos = readMatrix3x4();
		if( i.readInt32() != 0 ) throw "assert";
		j.attributes = readAttrs();
		return j;
	}
	
	inline function numAttribs( decode : Int -> Int -> Void ) {
		var totalLen = i.readInt32();
		if( totalLen == 0 ) return;
		var end = i.position + totalLen;
		while( i.position < end ) {
			var aid = i.readUInt16();
			var len = i.readInt32();
			var pos = i.position;
			decode(aid,len);
			var delta = i.position - (pos + len);
			if( delta > 0 ) throw "Invalid delta " + delta + " for attribute #" + aid;
		}
	}
	
	function getBlock < T:Block > ( id : Int, c : Class<T> ) : T {
		if( id == 0 )
			return null;
		var b = blocks.get(id);
		if( b == null ) throw "Block #" + id + " not found";
		var v = b.to(c);
		if( v == null ) throw "Block " + b + " should be " + c;
		return v;
	}
	
	function readSubMesh() {
		var s = new SubMesh();
		var len = i.readInt32();
		numAttribs(function(id, len) {
			
		});
		var end = i.position + len;
		while( i.position < end ) {
			var stype = i.readByte();
			var dtype = i.readByte();
			var len = i.readInt32();
			switch( [stype, dtype] ) {
			case [1, 7]:
				s.vertexData = i.read(len);
			case [2, 5]:
				s.indexes = i.read(len);
			case [3, 7]:
				s.uvs = i.read(len);
			default:
				throw "Unsupported stream " + stype + "/" + dtype+" ["+len+"]";
			}
		}
		readAttrs();
		return null;
	}
	
	function readBlock() {
		var id = readID();
		var ns = i.readByte();
		var tid = i.readByte();
		var flags = i.readByte();
		var size = i.readInt32();
		var startPos = i.position;
		var skip = false;
		var hasNumAttr = true;
		var block : Block;
	
		inline function noAttribute() {
			if( hasNumAttr ) {
				if( i.readInt32() != 0 ) throw "unexpected numattr";
				hasNumAttr = false;
			}
		}
		
		if( ns != 0 ) {
			block = null;
			skip = true;
		} else switch( tid ) {
		case TTRIANGLE_GEOM:
			var g = new TriangleGeometry(id);
			g.name = readName();
			var subGeom = i.readUInt16();
			numAttribs(function(id, len) {
				switch( id ) {
				default:
					throw "Unknown attrib #" + id + "[" + len + "]";
				}
			});
			var subMeshes = [for( i in 0...subGeom ) readSubMesh()];
			hasNumAttr = false;
			block = g;
		case TINSTANCE:
			var inst = new Instance(id);
			inst.parent = getBlock(readID(), SceneElement);
			inst.transform = readMatrix3x4();
			inst.name = readName();
			inst.geometry = getBlock(readID(), TriangleGeometry);
			inst.materials = [for( i in 0...i.readUInt16() ) getBlock(readID(), SimpleMaterial)];
			numAttribs(function(id, len) {
				switch( id ) {
				case 5:
					var castShadows = readBool();
				default:
					throw "Unknown attrib #" + id + "[" + len + "]";
				}
			});
			hasNumAttr = false;
			block = inst;
		case TSKELETON:
			var b = new Skeleton(id);
			b.name = readName();
			var njoints = i.readUInt16();
			noAttribute();
			for( i in 0...njoints ) {
				var j = readSkelJoint(b.joints);
				b.joints.set(j.id, j);
			}
			hasNumAttr = false;
			block = b;
		case TBITMAP_TEXURE:
			var b = new BitmapTexture(id);
			b.name = readName();
			switch( i.readByte() ) {
			case 0: b.url = i.readString(i.readInt32());
			case 1: b.data = i.read(i.readInt32());
			case unk: throw "assert " + unk;
			};
			block = b;
		case TSIMPLE_MATERIAL:
			var m = new SimpleMaterial(id);
			m.name = readName();
			var t = i.readByte();
			var s = i.readByte();
			numAttribs(function(id,len) {
				switch( id ) {
				case 1:
					m.color = i.readInt32();
				case 2:
					m.texture = getBlock(readID(), BitmapTexture);
				default:
					throw "Unknown attrib #" + id+"["+len+"]";
				}
			});
			hasNumAttr = false;
			block = m;
		default:
			#if debug
			trace("Unknown Block #" + tid);
			#end
			skip = true;
			block = null;
		}

		if( skip ) {
			var tmp = hxd.impl.Tmp.getBytes(size);
			i.readFullBytes(tmp, 0, size);
			hxd.impl.Tmp.saveBytes(tmp);
		} else {

			// do not support custom attributes
			noAttribute();
			block.attributes = readAttrs();
			blocks.set(block.id, block);
			
			var delta = i.position - (startPos + size);
			if( delta != 0 ) throw "Invalid delta " + delta + " for type " + tid;
		}
	}
	
}
