package h3d.dae;
import h3d.dae.DAE;

class BAEWriter {

	var o : haxe.io.Output;
	
	public function new(o) {
		this.o = o;
	}
	
	public function write( n : DAE ) {
		o.writeString("BAE");
		o.writeByte(0); // version
		writeNode(n);
	}
	
	function writeNode( n : DAE ) {
		var h = 0;
		if( n.attribs != null ) h |= 1;
		if( n.subs != null ) h |= 2;
		if( n.value != null ) h |= 4;
		o.writeByte(h);
		writeString(n.name);
		if( n.attribs != null ) {
			o.writeByte(n.attribs.length);
			for( a in n.attribs ) {
				writeString(a.n);
				writeValue(a.v);
			}
		}
		if( n.subs != null ) {
			o.writeUInt16(n.subs.length);
			for( s in n.subs )
				writeNode(s);
		}
		if( n.value != null )
			writeValue(n.value);
	}
	
	function writeString( s : String ) {
		if( s.length < 0x80 )
			o.writeByte(s.length);
		else {
			o.writeByte(0x80 | (s.length & 0x7F));
			o.writeUInt24(s.length >> 7);
		}
		o.writeString(s);
	}
	
	function writeValue( v : DAEValue ) {
		switch( v ) {
		case DEmpty:
			o.writeByte(0);
		case DInt(i):
			o.writeByte(1);
			o.writeInt32(i);
		case DFloat(f):
			o.writeByte(2);
			o.writeFloat(f);
		case DBool(b):
			o.writeByte(b?3:4);
		case DString(v):
			o.writeByte(5);
			writeString(v);
		case DIntArray(v, g):
			o.writeByte(6);
			o.writeByte(g);
			o.writeUInt24(v.length);
			for( v in v )
				o.writeInt32(v);
		case DFloatArray(v, g):
			o.writeByte(7);
			o.writeByte(g);
			o.writeUInt24(v.length);
			for( v in v )
				o.writeFloat(v);
		}
	}
}
