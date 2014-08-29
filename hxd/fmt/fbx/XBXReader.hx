package hxd.fmt.fbx;
import hxd.fmt.fbx.Data;

class XBXReader
{
	var i : haxe.io.Input;
	var version : Int;

	public function new(i) {
		this.i = i;
	}

	function error(?msg) {
		throw "Invalid XBX data"+((null!=msg)? (": "+msg) : "");
	}

	function readString() {
		var len = i.readByte();
		if( len >= 0x80 )
			len = (i.readUInt24() << 7) | (len & 0x7F);
		return i.readString(len);
	}

	public function read() : FbxNode {
		if( i.readString(3) != "XBX" )
			error("no XBX sig");
		version = i.readByte();
		if( version > 0 )
			error("version err "+version);
		return readNode();
	}

	public function readNode() : FbxNode
	{
		return {
			name: readString(),
			props: {
				var a = [];
				var l = i.readByte();
				a[l-1] = null;
				for( i in 0...l )
					a[i] = readProp();
				a;
			},
			childs: {
				var a = [];
				var l = i.readInt24();
				a[l - 1] = null;
				for( i in 0...l)
					a[i] = readNode();
				a;
			}
		};
	}

	inline function readInt() {
		#if haxe3
		return i.readInt32();
		#else
		return i.readInt31();
		#end
	}

	public function readProp()
	{
		var b = i.readByte();
		var t = switch( b )
		{
			case 0: PInt( readInt());
			case 1: PFloat( i.readDouble() );
			case 2: PString( readString() );
			case 3: PIdent( readString() );
			case 4:
				var l = readInt();
				var a = [];
				var tmp = hxd.impl.Tmp.getBytes(l * 4);
				i.readFullBytes(tmp, 0, l * 4);
				var r = hxd.impl.Memory.select(tmp);
				a[l - 1] = 0;
				for( idx in 0...l )
					a[idx] = r.i32(idx << 2);
				r.end();
				hxd.impl.Tmp.saveBytes(tmp);
				PInts( a );
			case 5:
				var l = readInt();
				var a = [];
				var tmp = hxd.impl.Tmp.getBytes(l * 8);
				i.readFullBytes(tmp, 0, l * 8);
				var r = hxd.impl.Memory.select(tmp);
				a[l - 1] = 0.;
				for( idx in 0...l)
					a[idx] = r.double(idx << 3);
				r.end();
				hxd.impl.Tmp.saveBytes(tmp);
				PFloats( a );
			default:
				error( "unknown prop " + b);
				null;
		}

		return t;
	}
}