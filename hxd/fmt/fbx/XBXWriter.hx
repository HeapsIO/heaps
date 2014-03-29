package hxd.fmt.fbx;
import hxd.fmt.fbx.Data;

/**
 * ...
 * @author de
 */
class XBXWriter
{
	var o : haxe.io.Output;
	public function new(o) {
		this.o = o;
	}

	public function write( n : FbxNode )
	{
		o.writeString("XBX");
		o.writeByte(0); // version
		writeNode(n);
	}

	function writeString( s : String ) {
		var len = haxe.io.Bytes.ofString(s).length;
		if( len < 0x80 )
			o.writeByte(len);
		else {
			o.writeByte(0x80 | (len & 0x7F));
			o.writeUInt24(len >> 7);
		}
		o.writeString(s);
	}

	public function writeNode( n : FbxNode)
	{
		writeString( n.name );
		o.writeByte( n.props.length );
		for ( p in n.props)
			writeProperty( p );

		o.writeInt24( n.childs.length );
		for ( c in n.childs )
			writeNode( c );
	}

	inline function writeInt(v) {
		#if haxe3
		o.writeInt32(v);
		#else
		o.writeInt31(v);
		#end
	}


	public function writeProperty( p : FbxProp )
	{
		o.writeByte( Type.enumIndex( p ) );

		switch( p )
		{
			case PInt( v ):		writeInt( v );
			case PFloat( v ):	o.writeDouble(v);
			case PString( v ):	writeString( v );
			case PIdent( v ): 	writeString( v );
			case PInts( va ):
				writeInt( va.length );
				for ( i in va ) writeInt( i );
			case PFloats( va ):
				#if haxe3
				o.writeInt32( va.length );
				#else
				o.writeInt31( va.length );
				#end
				for ( i in va ) o.writeDouble(i);
		}
	}

}