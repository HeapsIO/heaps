package h3d.fbx;
import h3d.fbx.Data;

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
		if( s.length < 0x80 )
			o.writeByte(s.length);
		else {
			o.writeByte(0x80 | (s.length & 0x7F));
			o.writeUInt24(s.length >> 7);
		}
		o.writeString(s);
	}
	
	public function writeNode( n : FbxNode)
	{
		writeString( n.name);
		o.writeByte( n.props.length );
		for ( p in n.props)
			writeProperty( p );
			
		o.writeInt24( n.childs.length );
		for ( c in n.childs )
			writeNode( c );
	}
	
	public function writeFloat(v)
	{
		o.writeDouble( v);
	}
	
	public function writeProperty( p : FbxProp )
	{
		o.writeByte( Type.enumIndex( p ) );
		
		switch( p )
		{
			case PInt( v ):		o.writeInt31( v );
			case PFloat( v ):	writeFloat( v );
			case PString( v ):	writeString( v );
			case PIdent( v ): 	writeString( v );
			case PInts( va ):
				o.writeInt31( va.length );
				for ( i in va ) o.writeInt31( i );
			case PFloats( va ):
				o.writeInt31( va.length );
				for ( i in va ) writeFloat( i );
		}
	}

}