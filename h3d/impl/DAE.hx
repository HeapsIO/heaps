package h3d.impl;

typedef DAE = {
	var name : String;
	@:optional var attribs : Null<Array<{ n : String, v : DAEValue }>>;
	@:optional var subs : Null<Array<DAE>>;
	@:optional var value : Null<DAEValue>;
}

typedef DAETable<T> = #if flash flash.Vector<T> #else Array<T> #end

enum DAEValue {
	DEmpty;
	DInt( v : Int );
	DFloat( v : Float );
	DBool( b : Bool );
	DString( v : String );
	DIntArray( v : DAETable<Int>, group : Int );
	DFloatArray( v : DAETable<Float>, group : Int );
}

class DAETools {
	
	public static function attr( n : DAE, name : String ) {
		if( n.attribs != null )
			for( a in n.attribs )
				if( a.n == name )
					return a.v;
		throw n.name + " has no attribute " + name;
	}
	
	public static function get( n : DAE, rq : String ) {
		return new DAERule(n.name + "." + rq).matchSingle(n);
	}
	
	public static function getAll( n : DAE, rq : String ) {
		return new DAERule(n.name + "." + rq).match(n);
	}
	
	public static function toString(v:DAEValue) {
		if( v == null ) return "null";
		return switch( v ) {
		case DEmpty: "<empty>";
		case DInt(i): Std.string(i);
		case DFloat(f): Std.string(f);
		case DIntArray(a,_): a.join(" ");
		case DFloatArray(a,_): a.join(" ");
		case DBool(b): b?"true":"false";
		case DString(v): v;
		}
	}
	
	public static function toInt( v : DAEValue ) {
		if( v != null )
			switch( v ) {
			case DInt(i): return i;
			default:
			}
		throw "Invalid value " + Std.string(v);
	}
	
}


class DAEParser {
	
	var r_spaces : EReg;
	var r_floats : EReg;
	var r_split : EReg;
	var r_isfloat : EReg;
	var r_line : EReg;
	
	public function new() {
		r_spaces = ~/^[ \r\n\t]*$/;
		r_floats = ~/^[-+0-9eE \r\n\t.]*$/;
		r_split = ~/[ \r\n\t]+/g;
		r_isfloat = ~/[.eE]/;
	}

	public function parse( dae : String ) : DAE {
		return parseNode(Xml.parse(dae).firstElement());
	}
	
	function parseNode( x : Xml ) {
		if( x.nodeType != Xml.Element )
			throw "Unexpected " + x.toString();
		var n : DAE = {
			name : x.nodeName,
		};
		var attr = [];
		for( a in x.attributes() )
			attr.push( { n : a, v : parseValue(n,x.get(a),a) } );
		if( attr.length > 0 )
			n.attribs = attr;
		for( s in x ) {
			switch( s.nodeType ) {
			case Xml.PCData:
				if( r_spaces.match(s.nodeValue) )
					continue;
				if( n.value != null || n.subs != null )
					throw "Multiple content for " + x.nodeName;
				n.value = parseValue(n,s.nodeValue,null);
			case Xml.Element:
				if( n.value != null )
					throw "Multiple content for " + x.nodeName;
				if( n.subs == null ) n.subs = [];
				n.subs.push(parseNode(s));
			default:
				throw "Not supported " + s.nodeType;
			}
		}
		if( n.subs == null && n.value == null && x.firstChild() != null )
			n.value = DEmpty;
		return n;
	}
	
	function parseValue( n : DAE, v : String, attName : String ) {
		
		if( r_floats.match(v) ) {
			v = StringTools.trim(v);
			var values = r_split.split(v);
			if( values.length == 1 ) {
				var f = Std.parseFloat(v);
				var i = Std.int(f);
				return f == i ? DInt(i) : DFloat(f);
			}
			var line = v.indexOf('\n');
			var group = if( line < 0 ) 0 else r_split.split(StringTools.trim(v.substr(0, line-1))).length;
			if( r_isfloat.match(v)) {
				var floats = new DAETable();
				for( v in values )
					floats.push(Std.parseFloat(v));
				return DFloatArray(floats,group);
			} else {
				var ints = new DAETable();
				for( v in values )
					ints.push(Std.parseInt(v));
				return DIntArray(ints,group);
			}
		}
		switch( v ) {
		case "false": return DBool(false);
		case "true": return DBool(true);
		default:
		}
			
		return DString(v);
	}
	
}

enum RuleMatch {
	MNo;
	MParent;
	MExact;
	MSub;
}

class DAERule {
	
	var rule : String;
	var parts : Array<{ n : String, ?a : { n : String, v : String } }>;
	
	public function new( r : String ) {
		rule = r;
		parts = [];
		var r_attr = ~/^(.*)\[([A-Za-z0-9_-]+)=([^\]]*)\]$/;
		for( p in r.split(".") ) {
			if( r_attr.match(p) )
				parts.push( { n : r_attr.matched(1).toLowerCase(), a : { n : r_attr.matched(2).toLowerCase(), v : r_attr.matched(3) } } );
			else
				parts.push( { n : p.toLowerCase() } );
		}
	}
	
	public function matchTree( tree : Array<DAE> ) : RuleMatch {
		for( i in 0...parts.length ) {
			var t = tree[i];
			if( t == null ) return MParent;
			var p = parts[i];
			if( t.name.toLowerCase() != p.n )
				return MNo;
			if( p.a != null ) {
				if( t.attribs == null )
					return MNo;
				var found = false;
				for( a in t.attribs )
					if( a.n.toLowerCase() == p.a.n ) {
						if( DAETools.toString(a.v) != p.a.v )
							return MNo;
						found = true;
						break;
					}
				if( !found )
					return MNo;
			}
		}
		return tree[parts.length] == null ? MExact : MSub;
	}
	
	public function match( n : DAE ) : Array<DAE> {
		var acc = [];
		matchRec(n, acc, [null]);
		return acc;
	}
	
	function matchRec( n : DAE, acc : Array<DAE>, stack : Array<DAE> ) {
		stack[stack.length - 1] = n;
		switch( matchTree(stack) ) {
		case MNo:
			return;
		case MParent:
			if( n.subs != null ) {
				stack.push(null);
				for( s in n.subs )
					matchRec(s, acc, stack);
				stack.pop();
			}
		case MExact:
			acc.push(n);
		case MSub:
			throw "assert";
		}
	}
	
	public function matchSingle( n : DAE ) {
		var r = match(n);
		if( r.length == 0 ) throw rule + " not found";
		if( r.length > 1 ) throw r.length + " nodes matching " + rule + " found";
		return r[0];
	}
	
}


class DAESimplifier {

	var rules : Array<DAERule>;
	
	public function new() {
		rules = new Array();
	}
	
	public function keep( path : String ) {
		rules.push(new DAERule(path));
	}
	
	public function simplify( n : DAE ) : DAE {
		return checkNode([], n);
	}
	
	function copyNode( n : DAE ) {
		var n2 : DAE = {
			name : n.name
		};
		if( n.value != null )
			n2.value = n.value;
		if( n.subs != null ) {
			n2.subs = [];
			for( s in n.subs )
				n2.subs.push(copyNode(s));
		}
		return n2;
	}
	
	function checkNode( stack : Array<DAE>, n : DAE ) {
		var checkSub = false;
		for( r in rules )
			switch( r.matchTree(stack) ) {
			case MNo:
			case MExact:
				return copyNode(n);
			case MParent:
				checkSub = true;
			case MSub:
				throw "assert";
			}
		if( !checkSub )
			return null;
		var n2 : DAE = {
			name : n.name,
			subs : [],
		};
		if( n.attribs != null )
			n2.attribs = n.attribs.copy();
		stack.push(null);
		for( s in n.subs ) {
			stack[stack.length - 1] = s;
			var s = checkNode(stack, s);
			if( s != null )
				n2.subs.push(s);
		}
		stack.pop();
		return n2.subs.length == 0 ? null : n2;
	}
	
}

class DAEPrinter {
	
	var buf : StringBuf;
	var space : String;
	
	public function new(?space = "    ") {
		this.space = space;
	}
	
	public function toString( n : DAE ) {
		buf = new StringBuf();
		buf.add('<?xml version="1.0" encoding="utf-8" ?>\n');
		addNode("", n);
		return buf.toString();
	}
	
	function addNode( tabs : String, n : DAE ) {
		buf.add(tabs + '<' + n.name);
		if( n.attribs != null )
			for( a in n.attribs	) {
				buf.add(' ' + a.n + '="');
				addValue("",a.v);
				buf.add('"');
			}
		if( n.value != null ) {
			buf.add('>');
			addValue(tabs,n.value);
			buf.add('</' + n.name + '>\n');
		} else if( n.subs != null ) {
			buf.add('>\n');
			for( s in n.subs )
				addNode(tabs + space, s);
			buf.add(tabs+'</' + n.name + '>\n');
		} else
			buf.add(' />\n');
	}
	
	function addValue( tabs : String, v : DAEValue ) {
		switch( v ) {
		case DEmpty:
		case DInt(i): buf.add(i);
		case DFloat(f): buf.add(f);
		case DString(s): buf.add(s);
		case DIntArray(v, g):
			if( g == 0 )
				buf.add(v.join(" "));
			else {
				for( i in 0...v.length ) {
					if( i % g == 0 )
						buf.add('\n' + tabs + space);
					else
						buf.add(' ');
					buf.add(v[i]);
				}
				buf.add('\n' + tabs);
			}
		case DFloatArray(v, g):
			if( g == 0 )
				buf.add(v.join(" "));
			else {
				for( i in 0...v.length ) {
					if( i % g == 0 )
						buf.add('\n' + tabs + space);
					else
						buf.add(' ');
					buf.add(v[i]);
				}
				buf.add('\n' + tabs);
			}
		case DBool(v): buf.add(v);
		}
	}
}

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
			o.writeInt31(i);
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
				o.writeInt31(v);
		case DFloatArray(v, g):
			o.writeByte(7);
			o.writeByte(g);
			o.writeUInt24(v.length);
			for( v in v )
				o.writeFloat(v);
		}
	}
}

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
			DInt(i.readInt31());
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
				a[k] = i.readInt31();
			DIntArray(a, g);
		case 7:
			var g = i.readByte();
			var a = new DAETable();
			for( k in 0...i.readUInt24() )
				a[k] = i.readFloat();
			DFloatArray(a, g);
		}
	}
}