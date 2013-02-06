package h3d.dae;
import h3d.dae.DAE;

class BAEReader {

	var i : haxe.io.Input;
	var version : Int;
	
	public function new(i) {
		this.i = i;
	}
	
	function error() {
		throw "Invalid BAE data";
	}
	
	public function read() : DAE {
		if( i.readString(3) != "BAE" )
			error();
		version = i.readByte();
		if( version > 0 )
			error();
		return readNode();
	}

	function readNode() {
		var h = i.readByte();
		var n : DAE = {
			name : readString(),
		};
		if( h & 1 != 0 ) {
			n.attribs = [];
			for( i in 0...i.readByte() )
				n.attribs.push( { n : readString(), v : readValue() } );
		}
		if( h & 2 != 0 ) {
			n.subs = [];
			for( i in 0...i.readUInt16() )
				n.subs.push(readNode());
		}
		if( h & 4 != 0 )
			n.value = readValue();
		return n;
	}
	
	function readString() {
		var len = i.readByte();
		if( len >= 0x80 )
			len = (i.readUInt24() << 7) | (len & 0x7F);
		return i.readString(len);
	}
	
	function readValue() : DAEValue {
		return switch( i.readByte() ) {
		case 0:
			DEmpty;
		case 1:
			DInt(i.readInt32());
		case 2:
			DFloat(i.readFloat());
		case 3:
			DBool(true);
		case 4:
			DBool(false);
		case 5:
			DString(readString());
		case 6:
			var g = i.readByte();
			var a = new DAETable();
			for( k in 0...i.readUInt24() )
				a[k] = i.readInt32();
			DIntArray(a, g);
		case 7:
			var g = i.readByte();
			var a = new DAETable();
			for( k in 0...i.readUInt24() )
				a[k] = i.readFloat();
			DFloatArray(a, g);
		default:
			throw "assert";
		}
	}
}
