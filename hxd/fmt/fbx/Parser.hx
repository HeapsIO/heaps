package hxd.fmt.fbx;
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
	var pos : Int;
	var token : Null<Token>;

	function new() {
	}

	function parseText( str ) : FbxNode {
		this.buf = str;
		this.pos = 0;
		this.line = 1;
		token = null;
		return {
			name : "Root",
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
				var ints = [];
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

	public static function parse( text : String ) {
		return new Parser().parseText(text);
	}

}