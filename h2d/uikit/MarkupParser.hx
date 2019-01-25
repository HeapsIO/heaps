package h2d.uikit;

using StringTools;

enum abstract MToken(Int) {
	var IGNORE_SPACES;
	var BEGIN;
	var BEGIN_NODE;
	var TAG_NAME;
	var BODY;
	var ATTRIB_NAME;
	var EQUALS;
	var ATTVAL_BEGIN;
	var ATTRIB_VAL;
	var CHILDS;
	var CLOSE;
	var WAIT_END;
	var WAIT_END_RET;
	var PCDATA;
	var HEADER;
	var COMMENT;
	var DOCTYPE;
	var CDATA;
	var ESCAPE;
}

enum MarkupKind {
	Node( name : String );
	Text( text : String );
}

enum AttributeValue {
	RawValue( v : String );
	Code( v : haxe.macro.Expr );
}

typedef Markup = {
	var kind : MarkupKind;
	var pmin : Int;
	var pmax : Int;
	var ?attributes : Array<{ name : String, value : AttributeValue, pmin : Int, vmin : Int, pmax : Int }>;
	var ?children : Array<Markup>;
}

class MarkupParser {

	static var escapes = {
		var h = new haxe.ds.StringMap();
		h.set("lt", "<");
		h.set("gt", ">");
		h.set("amp", "&");
		h.set("quot", '"');
		h.set("apos", "'");
		h;
	}

	var fileName : String;
	var filePos : Int;

	public function new() {
	}

	public function parse(str:String,fileName:String,filePos:Int) {
		var p : Markup = {
			kind : Node(null),
			pmin : 0,
			pmax : 0,
			children : [],
		};
		this.fileName = fileName;
		this.filePos = filePos;
		doParse(str, 0, p);
		return p;
	}

	function error( msg : String, position : Int, pmax = -1 ) : Dynamic {
		throw new Error(msg, position, pmax);
		return null;
	}

	function parseAttr( val : String, start : Int ) {
		var v = StringTools.trim(val);
		if( v.length == 0 || v.charCodeAt(0) != "$".code )
			return RawValue(val);
		#if macro
		if( v.charCodeAt(1) == "{".code && v.charCodeAt(v.length-1) == "}".code )
			v = v.substr(2,v.length - 3);
		else
			v = v.substr(1);
		start += val.indexOf(v);
		var e = try haxe.macro.Context.parseInlineString(v,haxe.macro.Context.makePosition({ min : filePos + start, max : filePos + start + v.length, file : fileName })) catch( e : Dynamic ) error(""+e, start, start + v.length);
		return Code(e);
		#else
		return error("Unsupported runtime code attribute", start, start + val.length);
		#end
	}

	function doParse(str:String, p:Int = 0, ?parent:Markup):Int {
		var obj : Markup = null;
		var state = BEGIN;
		var next = BEGIN;
		var aname = null;
		var start = 0;
		var nsubs = 0;
		var nbrackets = 0;
		var attr_start = 0;
		var c = str.fastCodeAt(p);
		var buf = new StringBuf();
		// need extra state because next is in use
		var escapeNext = BEGIN;
		var attrValQuote = -1;
		inline function addChild(m:Markup) {
			parent.children.push(m);
			nsubs++;
		}
		while (!StringTools.isEof(c)) {
			switch(state) {
				case IGNORE_SPACES:
					switch(c)
					{
						case
							'\n'.code,
							'\r'.code,
							'\t'.code,
							' '.code:
						default:
							state = next;
							continue;
					}
				case BEGIN:
					switch(c)
					{
						case '<'.code:
							state = IGNORE_SPACES;
							next = BEGIN_NODE;
						default:
							start = p;
							state = PCDATA;
							continue;
					}
				case PCDATA:
					if (c == '<'.code)
					{
						buf.addSub(str, start, p - start);
						var child : Markup = {
							kind : Text(buf.toString()),
							pmin : start,
							pmax : p,
						};
						buf = new StringBuf();
						addChild(child);
						state = IGNORE_SPACES;
						next = BEGIN_NODE;
					} else if (c == '&'.code) {
						buf.addSub(str, start, p - start);
						state = ESCAPE;
						escapeNext = PCDATA;
						start = p + 1;
					}
				case CDATA:
					if (c == ']'.code && str.fastCodeAt(p + 1) == ']'.code && str.fastCodeAt(p + 2) == '>'.code)
					{
						var child : Markup = {
							kind : Text(str.substr(start, p - start)),
							pmin : start,
							pmax : p,
						};
						addChild(child);
						p += 2;
						state = BEGIN;
					}
				case BEGIN_NODE:
					switch(c)
					{
						case '!'.code:
							if (str.fastCodeAt(p + 1) == '['.code)
							{
								p += 2;
								if (str.substr(p, 6).toUpperCase() != "CDATA[")
									error("Expected <![CDATA[", p);
								p += 5;
								state = CDATA;
								start = p + 1;
							}
							else if (str.fastCodeAt(p + 1) == 'D'.code || str.fastCodeAt(p + 1) == 'd'.code)
							{
								if(str.substr(p + 2, 6).toUpperCase() != "OCTYPE")
									error("Expected <!DOCTYPE", p);
								p += 8;
								state = DOCTYPE;
								start = p + 1;
							}
							else if( str.fastCodeAt(p + 1) != '-'.code || str.fastCodeAt(p + 2) != '-'.code )
								error("Expected <!--", p);
							else
							{
								p += 2;
								state = COMMENT;
								start = p + 1;
							}
						case '?'.code:
							state = HEADER;
							start = p;
						case '/'.code:
							if( parent == null )
								error("Expected node name", p);
							start = p + 1;
							state = IGNORE_SPACES;
							next = CLOSE;
						default:
							state = TAG_NAME;
							start = p;
							continue;
					}
				case TAG_NAME:
					if (!isValidChar(c))
					{
						if( p == start )
							error("Expected node name", p);
						obj = {
							kind : Node(str.substr(start, p - start)),
							pmin : start,
							pmax : p,
							attributes : [],
							children : [],
						};
						addChild(obj);
						state = IGNORE_SPACES;
						next = BODY;
						continue;
					}
				case BODY:
					switch(c)
					{
						case '/'.code:
							state = WAIT_END;
						case '>'.code:
							state = CHILDS;
						default:
							state = ATTRIB_NAME;
							start = p;
							continue;
					}
				case ATTRIB_NAME:
					if (!isValidChar(c))
					{
						var tmp;
						if( start == p )
							error("Expected attribute name", p);
						tmp = str.substr(start,p-start);
						aname = tmp;
						for( a in obj.attributes )
							if( a.name == aname )
								error("Duplicate attribute '" + aname + "'", p);
						attr_start = start;
						state = IGNORE_SPACES;
						next = EQUALS;
						continue;
					}
				case EQUALS:
					switch(c)
					{
						case '='.code:
							state = IGNORE_SPACES;
							next = ATTVAL_BEGIN;
						default:
							error("Expected =", p);
					}
				case ATTVAL_BEGIN:
					switch(c)
					{
						case '"'.code | '\''.code:
							buf = new StringBuf();
							state = ATTRIB_VAL;
							start = p + 1;
							attrValQuote = c;
						default:
							error("Expected \"", p);
					}
				case ATTRIB_VAL:
					switch (c) {
						case '&'.code:
							buf.addSub(str, start, p - start);
							state = ESCAPE;
							escapeNext = ATTRIB_VAL;
							start = p + 1;
						case '>'.code | '<'.code:
							// HTML allows these in attributes values
							error("Invalid unescaped " + String.fromCharCode(c) + " in attribute value", p);
						case _ if (c == attrValQuote):
							buf.addSub(str, start, p - start);
							var val = buf.toString();
							buf = new StringBuf();
							obj.attributes.push({ name : aname, value : parseAttr(val,start), pmin : attr_start, vmin : start, pmax : p });
							state = IGNORE_SPACES;
							next = BODY;
					}
				case CHILDS:
					p = doParse(str, p, obj);
					start = p;
					state = BEGIN;
				case WAIT_END:
					switch(c)
					{
						case '>'.code:
							state = BEGIN;
						default :
							error("Expected >", p);
					}
				case WAIT_END_RET:
					switch(c)
					{
						case '>'.code:
							if( nsubs == 0 )
								parent.children.push({ kind : Text(""), pmin : p, pmax : p });
							return p;
						default :
							error("Expected >", p);
					}
				case CLOSE:
					if (!isValidChar(c))
					{
						if( start == p )
							error("Expected node name", p);

						var v = str.substr(start,p - start);
						var ok = true;
						if( parent == null )
							ok = false;
						else switch( parent.kind ) {
						case Node(name) if( v == name ): // ok
						case Node(name):
							error("Unclosed node", parent.pmin, parent.pmax);
						default:
							ok = false;
						}
						if( !ok )
							error('Unexpected </$v>', p);
						state = IGNORE_SPACES;
						next = WAIT_END_RET;
						continue;
					}
				case COMMENT:
					if (c == '-'.code && str.fastCodeAt(p +1) == '-'.code && str.fastCodeAt(p + 2) == '>'.code)
					{
						//addChild(Xml.createComment(str.substr(start, p - start)));
						p += 2;
						state = BEGIN;
					}
				case DOCTYPE:
					if(c == '['.code)
						nbrackets++;
					else if(c == ']'.code)
						nbrackets--;
					else if (c == '>'.code && nbrackets == 0)
					{
						//addChild(Xml.createDocType(str.substr(start, p - start)));
						state = BEGIN;
					}
				case HEADER:
					if (c == '?'.code && str.fastCodeAt(p + 1) == '>'.code)
					{
						p++;
						var str = str.substr(start + 1, p - start - 2);
						//addChild(Xml.createProcessingInstruction(str));
						state = BEGIN;
					}
				case ESCAPE:
					if (c == ';'.code)
					{
						var s = str.substr(start, p - start);
						if (s.fastCodeAt(0) == '#'.code) {
							var c = s.fastCodeAt(1) == 'x'.code
								? Std.parseInt("0" +s.substr(1, s.length - 1))
								: Std.parseInt(s.substr(1, s.length - 1));
							buf.addChar(c);
						} else if (!escapes.exists(s)) {
							error("Undefined entity: " + s, p);
							buf.add('&$s;');
						} else {
							buf.add(escapes.get(s));
						}
						start = p + 1;
						state = escapeNext;
					} else if (!isValidChar(c) && c != "#".code) {
						error("Invalid character in entity: " + String.fromCharCode(c), p);
						buf.addChar("&".code);
						buf.addSub(str, start, p - start);
						p--;
						start = p + 1;
						state = escapeNext;
					}
			}
			c = str.fastCodeAt(++p);
		}

		if (state == BEGIN)
		{
			start = p;
			state = PCDATA;
		}

		if (state == PCDATA)
		{
			switch( parent.kind ) {
			case Node(name) if( name != null ):
				error("Unclosed node <" + name + ">", p);
			default:
			}
			if (p != start || nsubs == 0) {
				buf.addSub(str, start, p-start);
				addChild({ kind : Text(buf.toString()), pmin : start, pmax : p });
			}
			return p;
		}

		error("Unexpected end", p);
		return p;
	}

	static inline function isValidChar(c) {
		return (c >= 'a'.code && c <= 'z'.code) || (c >= 'A'.code && c <= 'Z'.code) || (c >= '0'.code && c <= '9'.code) || c == ':'.code || c == '.'.code || c == '_'.code || c == '-'.code;
	}
}
