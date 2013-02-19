import h3d.fbx.*;
import h3d.fbx.Data;

class XBXMake
{
	var inFile : String;
	var outputFile : Null<String>;
	var verbose:Bool;
	var nozip:Bool;
	var doTest:Bool;
	function new()
	{
		
	}
	
	public function make(prm:Array<String>)
	{
		var params = prm;
		
		for ( a in 0...params.length )
		{
			var arg = params[a];
			if (null == arg) continue;
			
			switch(arg)
			{
				case "--usage", "/?":
					neko.Lib.println( "neko XBXMake.n <file> [-o|--output <file> ] [-z] ");
					neko.Lib.println( "writes FBX <file> in XBX which is basically a stripped binary version of it." );
					neko.Lib.println( "--no-zip impeach terminal fiel for compression (useful for debug)" );
					return;
					
				case "-o", "--output":
					outputFile = params[a + 1];
					params.remove( arg );
					params.remove( params[a + 1] );
		
				case "--no-zip": nozip = true;
				case "--test": doTest = true;
				case "-v", "--verbose":verbose=true;
				default:
					inFile = arg;
			}
		}
		
		var idx = inFile.toLowerCase().lastIndexOf(".fbx");
		
		if ( idx < 0 )
			throw inFile + " is not an Fbx file";
		
		if ( outputFile == null)
			outputFile = inFile.substr(0, idx) + ".xbx";
		
		var f = sys.io.File.read( inFile, true);
		var fbx = h3d.fbx.Parser.parse( f.readAll().toString() );
		f.close();
		
		var bout = new haxe.io.BytesOutput();
		var writer = new h3d.fbx.XBXWriter( bout );
		writer.write(fbx);
	
		var b = bout.getBytes();
		
		{
			var entry : format.zip.Data.Entry =
			{
				fileName:"fbx_root",
				fileSize : b.length,
				fileTime:Date.now(),
				compressed:false,
				dataSize:0,
				data:b,
				crc32:haxe.crypto.Crc32.make(b),
				extraFields:new List(),
			}
			
			var zb = new haxe.io.BytesOutput();
			var zw = new format.zip.Writer(zb);
			var  nl = new List();
			
			if( !nozip )
				format.zip.Tools.compress( entry, 9);
				
			nl.add( entry);
			zw.write(nl);
			var file = sys.io.File.write( outputFile, true);
			file.write( zb.getBytes() );
			file.flush();
			file.close();
			
			if ( doTest )
			{
				var f = sys.io.File.read( outputFile, true);
				var zr = new format.zip.Reader( f);
				var entries = zr.read();
				var p = entries.first();
				
				if ( p.compressed )
					format.zip.Tools.uncompress( p );

				var buf = p.data;

				var inp = new haxe.io.BytesInput( buf );
				var reader = new XBXReader( inp );
				
				function explore(n:h3d.fbx.Data.FbxNode)
				{
					trace( n.name );
					trace( n.props);
					for (n in n.childs)
						explore(n);
				}
				
				var rfbx = reader.read();
				
				function cmp(t0:FbxNode,t1:FbxNode)
				{
					if ( t0.name != t1.name)
					{
						trace( t0.name + " != " + t1.name );
						return false;
					}
					
					if ( t0.childs.length != t1.childs.length) {
						trace( t0.name + " has not same child num to its counterpart" );
						return false;
					}
					
					for ( idx in 0...t0.childs.length)
					{
						if ( !cmp( t0.childs[idx], t1.childs[idx] ))
						{
							return false;
						}
					}
					
					if ( t0.props.length != t1.props.length) {
						trace( t0.name + " has not same prop num to its counterpart" );
					}
					
					for ( idx in 0...t0.props.length)
					{
						var p0 = t0.props[idx];
						var p1 = t1.props[idx];
						
						var msg = function(s) trace( "prop (" + 	idx+") of " + t0.name + " has not same value as its counterpart "+s );
						
						switch( p0 )
						{
							case PInt(v0): switch(p1) { case PInt(v1): if (v0 != v1) { msg( v0 + "<>" + v1); return false; }  default: msg("type err PInt"); return false; };
							case PFloat(v0): switch(p1) { case PFloat(v1): if (v0 != v1) { msg( v0 + "<>" + v1); return false; }  default: msg("type err PFloat"); return false; };
							case PString(v0): switch(p1) { case PString(v1): if (v0 != v1) { msg( v0 + "<>" + v1); return false; }  default: msg("type err PString"); return false; };
							case PIdent(v0): switch(p1) { case PIdent(v1): if (v0 != v1) { msg( v0 + "<>" + v1); return false; }  default: msg("type err PIdent"); return false; };
							
							case PInts(v0):
								switch(p1) {
									default: msg("type err PInts"); return false;
									case PInts(v1):
										for ( idx in 0...v0.length)
											if ( v0[idx] != v1[idx])
											{
												msg("mismtched value in ints at index " + idx + " " + v0[idx] + "<>" + v1[idx]);
												return false;
											}
								}
								
							case PFloats(v0):
								switch(p1) {
									default: msg("type err PFloats "); return false;
									case PFloats(v1):
										for ( idx in 0...v0.length)
											if ( Math.abs( v0[idx] - v1[idx]) > 1e-3 )
											{
												msg("mismtched value in floats at index " + idx + " " + v0[idx] + "<>" + v1[idx]);
												return false;
											}
								}
						}
						
					}
				
					
						
					return true;
				}
			
				cmp( fbx, rfbx);
			}
		}
	}
	
	
	public static function main()
	{
		new XBXMake().make(  Sys.args().copy() );
	}
	
	public static function test()
	{
		
	}
}