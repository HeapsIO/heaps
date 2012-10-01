package h3d.fbx;

class XBXFile extends flash.utils.ByteArray {
	
	public function getLibrary() {
		
		var rb = new haxe.io.BytesInput(haxe.io.Bytes.ofData(this));
		var reader = new format.zip.Reader(rb);
		var entries = reader.read();
		var root :format.zip.Data.Entry = entries.first();
		var data : haxe.io.Bytes = root.data;
		var l =  new Library();
		var ba = root.data.getData();
		
		if( root.compressed )
			ba.inflate();//??
		
		//trace(ba);
		var inStream = new haxe.io.BytesInput( haxe.io.Bytes.ofData(ba) );
		
		var a = [];
		var rdr = new XBXReader( inStream );
		while ( true )
		{
			try {
				a.push( rdr.read() );
			}
			catch( d:Dynamic )
			{
				trace("finished on " + d);
				break;
			}
		}
		l.load( a );
		
		return l;
	}
}