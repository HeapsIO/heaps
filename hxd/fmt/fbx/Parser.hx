package hxd.fmt.fbx;
import haxe.io.Bytes;
using hxd.fmt.fbx.Data;

private enum Token {
	TIdent( s : String );
	TNode( s : String );
	TInt( s : String );
	TFloat( s : String );
	TString( s : String );
	TLength( v : Int );
	TBraceOpen;
	TBraceClose;
	TColon;
	TEof;
}

class Parser {

	var line : Int;
	var buf : String;
	var bytes : Bytes;
	var pos : Int;
	var token : Null<Token>;
	var binary : Bool;
	var fbxVersion:Int;

	function new() {
	}

	function parseText( str ) : FbxNode {
		this.buf = str;
		this.pos = 0;
		this.line = 1;
		this.binary = false;
		token = null;
		return {
			name : "Root",
			props : [PInt(0),PString("Root"),PString("Root")],
			childs : parseNodes(),
		};
	}

	function parseBytes( bytes : Bytes ) : FbxNode {
		this.bytes = bytes;
		this.pos = 0;
		this.line = 0;
		this.binary = (bytes.getString(0, 20) == "Kaydara FBX Binary  ") && bytes.get(20) == 0;

		token = null;
		if (this.binary) {
			// Skip header, magic [0x1A, 0x00] and version number.
			fbxVersion = bytes.getInt32(0x17);

			this.pos = 21 + 2 + 4;
			var firstNode = parseBinaryNode(getVersionedInt32());
			if (firstNode.name != "") {

				// Root was omitted, read until all data obtained.
				var nodes : Array<FbxNode> = [firstNode];
				var size:Int = getVersionedInt32();

				while (size != 0) {
					nodes.push(parseBinaryNode(size));
					size = getVersionedInt32();
				}

				return {
					name: "Root",
					props: [PInt(0), PString("Root"), PString("Root")],
					childs: nodes
				};
			}
			else
			{
				return firstNode;
			}
		}

		return {
			name: "Root",
			props : [PInt(0),PString("Root"),PString("Root")],
			childs : parseNodes(),
		};
	}

	function parseNodes() {
		var nodes = [];
		while( true ) {
			switch( peek() ) {
			case TEof, TBraceClose:
				return nodes;
			default:
			}
			nodes.push(parseNode());
		}
		return nodes;
	}

	function parseNode() : FbxNode {
		var t = next();
		var name = switch( t ) {
		case TNode(n): n;
		default: unexpected(t);
		};
		var props = [], childs = null;
		while( true ) {
			t = next();
			switch( t ) {
			case TFloat(s):
				props.push(PFloat(Std.parseFloat(s)));
			case TInt(s):
				props.push(PInt(Std.parseInt(s)));
			case TString(s):
				props.push(PString(s));
			case TIdent(s):
				props.push(PIdent(s));
			case TBraceOpen, TBraceClose, TNode(_):
				token = t;
			case TLength(v):
				except(TBraceOpen);
				except(TNode("a"));
				var ints : Array<Int> = [];
				var floats : Array<Float> = null;
				var i = 0;
				while( i < v ) {
					t = next();
					switch( t ) {
					case TColon:
						continue;
					case TInt(s):
						i++;
						if( floats == null )
							ints.push(Std.parseInt(s));
						else
							floats.push(Std.parseInt(s));
					case TFloat(s):
						i++;
						if( floats == null ) {
							floats = [];
							for( i in ints )
								floats.push(i);
							ints = null;
						}
						floats.push(Std.parseFloat(s));
					default:
						unexpected(t);
					}
				}
				props.push(floats == null ? PInts(ints) : PFloats(floats));
				if (peek()==TColon) except(TColon); // Allow trailing ,
				except(TBraceClose);
				break;
			default:
				unexpected(t);
			}
			t = next();
			switch( t ) {
			case TNode(_), TBraceClose:
				token = t; // next
				break;
			case TColon:
				// next prop
			case TBraceOpen:
				childs = parseNodes();
				except(TBraceClose);
				break;
			default:
				unexpected(t);
			}
		}
		if( childs == null ) childs = [];
		return { name : name, props : props, childs : childs };
	}

	function parseBinaryNodes( output : Array<FbxNode> ) {
		var size : Int = getVersionedInt32();
		while (size != 0)
		{
			output.push(parseBinaryNode(size));
			size = getVersionedInt32();
		}
	}

	function readBinaryString( length : Int ) : String {
		if  (length == 0 ) return "";
		var str = bytes.getString(pos, length);
		pos += length;
		// Blender inserts extra data to strings following `\0\1` byte sequence
		// expecting them to be stripped away due to 0 byte being terminator.
		final len = str.length;
		for ( i in 0...len ) {
			if ( str.charCodeAt(i) == 0 ) {
				return str.substr(0, i);
			}
		}
		return str;
	}

	function parseBinaryNode( nextRecord : Int ) : FbxNode {

		var numProperties : Int = getVersionedInt32();
		var propertyListLength : UInt = getVersionedInt32();
		var name : String = readBinaryString(getByte());

		var props : Array<FbxProp> = new Array();
		var childs : Array<FbxNode> = new Array();

		var propStart : Int = pos;

		for ( i in 0...numProperties ) {
			props.push(readBinaryProperty());
		}

		pos = propStart + propertyListLength;

		if ( pos < nextRecord ) {
			parseBinaryNodes(childs);
		}
		pos = nextRecord;

		return { name: name, props: props, childs: childs };
	}

	function readBinaryProperty() : FbxProp {

		var arrayLen : Int = 0;
		var arrayEncoding:Int;
		var arrayCompressedLen:Int;
		var arrayBytes:Bytes = null;
		var arrayBytesPos:Int = 0;

		inline function readArray(entrySize:Int) {
			arrayLen = getInt32();
			arrayEncoding = getInt32();
			arrayCompressedLen = getInt32();

			switch( arrayEncoding ) {
				case 0:
					arrayBytes = bytes;
					arrayBytesPos = pos;
					pos += arrayLen * entrySize;
				case 1:
					arrayBytesPos = 0;
					var buf = bytes.sub(pos, arrayCompressedLen);
					#if hxnodejs
					try {
						arrayBytes = haxe.zip.Uncompress.run(buf);
					} catch( e : Dynamic ) {
						arrayBytes = haxe.zip.InflateImpl.run(new haxe.io.BytesInput(buf));
					}
					#else
					arrayBytes = haxe.zip.Uncompress.run(buf);
					#end
					pos += arrayCompressedLen;
				default:
					error("Unsupported array encoding: " + arrayEncoding);
			}
		}

		// Limitations:
		// Int64 records are converted to Floats with top bits being lost.
		// Raw binary data converted to Strings.

		var type : Int = getByte();
		switch( type ) {
			case 'Y'.code:
				return PInt(getInt16());
			case 'C'.code:
				return PInt(getByte());
			case 'I'.code:
				return PInt(getInt32());
			case 'F'.code:
				return PFloat(getFloat());
			case 'D'.code:
				return PFloat(getDouble());
			case 'L'.code:
				var i64 : haxe.Int64 = bytes.getInt64(pos);
				pos += 8;
				return PFloat(i64ToFloat(i64));
			case 'f'.code:
				readArray(4);
				var floats:Array<Float> = new Array();
				while ( arrayLen > 0 ) {
					floats.push(arrayBytes.getFloat(arrayBytesPos));
					arrayBytesPos += 4;
					arrayLen--;
				}
				return PFloats(floats);
			case 'd'.code:
				readArray(8);
				var doubles:Array<Float> = new Array();
				while ( arrayLen > 0 ) {
					doubles.push(arrayBytes.getDouble(arrayBytesPos));
					arrayBytesPos += 8;
					arrayLen--;
				}
				return PFloats(doubles);
			case 'l'.code:
				readArray(8);
				var i64s:Array<Float> = new Array();
				while ( arrayLen > 0 ) {
					i64s.push(i64ToFloat(arrayBytes.getInt64(arrayBytesPos)));
					arrayBytesPos += 8;
					arrayLen--;
				}
				return PFloats(i64s);
			case 'i'.code:
				readArray(4);
				var ints:Array<Int> = new Array();
				while ( arrayLen > 0 ) {
					ints.push(arrayBytes.getInt32(arrayBytesPos));
					arrayBytesPos += 4;
					arrayLen--;
				}
				return PInts(ints);
			case 'b'.code:
				readArray(1);
				var bools:Array<Int> = new Array();
				while ( arrayLen > 0 ) {
					bools.push(arrayBytes.get(arrayBytesPos++));
					arrayLen--;
				}
				return PInts(bools);
			case 'S'.code:
				return PString(readBinaryString(getInt32()));
			case 'R'.code:
				var len:Int = getInt32();
				var data = Bytes.alloc(len);
				data.blit(0, bytes, pos, len);
				pos += len;
				return PBinary(data);
			default:
				return error("Unknown property type: " + type + "/" + String.fromCharCode(type));
		}
	}

	function except( except : Token ) {
		var t = next();
		if( !Type.enumEq(t, except) )
			error("Unexpected '" + tokenStr(t) + "' (" + tokenStr(except) + " expected)");
	}

	function peek() {
		if( token == null )
			token = nextToken();
		return token;
	}

	function next() {
		if( token == null )
			return nextToken();
		var tmp = token;
		token = null;
		return tmp;
	}

	function error( msg : String ) : Dynamic {
		throw msg + " (line " + line + ")";
		return null;
	}

	function unexpected( t : Token ) : Dynamic {
		return error("Unexpected "+tokenStr(t));
	}

	function tokenStr( t : Token ) {
		return switch( t ) {
		case TEof: "<eof>";
		case TBraceOpen: '{';
		case TBraceClose: '}';
		case TIdent(i): i;
		case TNode(i): i+":";
		case TFloat(f): f;
		case TInt(i): i;
		case TString(s): '"' + s + '"';
		case TColon: ',';
		case TLength(l): '*' + l;
		};
	}

	inline function nextChar() {
		return StringTools.fastCodeAt(buf, pos++);
	}

	inline function getVersionedInt32() {
		var i : Int = bytes.getInt32(pos);
		// No support for file sizes over Int32.
		pos += fbxVersion >= 7500 ? 8 : 4;
		return i;
	}

	inline function getInt32() {
		var i : Int = bytes.getInt32(pos);
		pos += 4;
		return i;
	}

	inline function getInt16() {
		var i : Int = bytes.get(pos) | (bytes.get(pos + 1) << 8);
		pos += 2;
		return i;
	}

	inline function getFloat() {
		var f : Float = bytes.getFloat(pos);
		pos += 4;
		return f;
	}

	inline function getDouble() {
		var d : Float = bytes.getDouble(pos);
		pos += 8;
		return d;
	}

	inline function i64ToFloat( i64 : haxe.Int64 ) : Float {
		return (i64.high * 4294967296) +
						( (i64.low & 0x80000000) != 0 ? ((i64.low & 0x7fffffff) + 2147483648) : i64.low );
	}

	inline function getByte() {
		return bytes.get(pos++);
	}

	inline function getBuf( pos : Int, len : Int ) {
		return buf.substr(pos, len);
	}

	inline function isIdentChar(c) {
		return (c >= 'a'.code && c <= 'z'.code) || (c >= 'A'.code && c <= 'Z'.code) || (c >= '0'.code && c <= '9'.code) || c == '_'.code || c == '-'.code;
	}

	@:noDebug
	function nextToken() {
		var start = pos;
		while( true ) {
			var c = nextChar();
			switch( c ) {
			case ' '.code, '\r'.code, '\t'.code:
				start++;
			case '\n'.code:
				line++;
				start++;
			case ';'.code:
				while( true ) {
					var c = nextChar();
					if( StringTools.isEof(c) || c == '\n'.code ) {
						pos--;
						break;
					}
				}
				start = pos;
			case ','.code:
				return TColon;
			case '{'.code:
				return TBraceOpen;
			case '}'.code:
				return TBraceClose;
			case '"'.code:
				start = pos;
				while( true ) {
					c = nextChar();
					if( c == '"'.code )
						break;
					if( StringTools.isEof(c) || c == '\n'.code )
						error("Unclosed string");
				}
				return TString(getBuf(start, pos - start - 1));
			case '*'.code:
				start = pos;
				do {
					c = nextChar();
				} while( c >= '0'.code && c <= '9'.code );
				pos--;
				return TLength(Std.parseInt(getBuf(start, pos - start)));
			default:
				if( (c >= 'a'.code && c <= 'z'.code) || (c >= 'A'.code && c <= 'Z'.code) || c == '_'.code ) {
					do {
						c = nextChar();
					} while( isIdentChar(c) );
					if( c == ':'.code )
						return TNode(getBuf(start, pos - start - 1));
					pos--;
					return TIdent(getBuf(start, pos - start));
				}
				if( (c >= '0'.code && c <= '9'.code) || c == '-'.code ) {
					do {
						c = nextChar();
					} while( c >= '0'.code && c <= '9'.code );
					if( c != '.'.code && c != 'E'.code && c != 'e'.code && pos - start < 10 ) {
						pos--;
						return TInt(getBuf(start, pos - start));
					}
					if( c == '.'.code ) {
						do {
							c = nextChar();
						} while( c >= '0'.code && c <= '9'.code );
					}
					if( c == 'e'.code || c == 'E'.code ) {
						c = nextChar();
						if( c != '-'.code && c != '+'.code )
							pos--;
						do {
							c = nextChar();
						} while( c >= '0'.code && c <= '9'.code );
					}
					pos--;
					return TFloat(getBuf(start, pos - start));
				}
				if( StringTools.isEof(c) ) {
					pos--;
					return TEof;
				}
				error("Unexpected char '" + String.fromCharCode(c) + "'");
			}
		}
	}

	public static function parse( data : Bytes ) {
		if (data.length > 20 && data.getString(0, 20) == "Kaydara FBX Binary  ") {
			return new Parser().parseBytes(data);
		}
		return new Parser().parseText(data.toString());
	}

}
