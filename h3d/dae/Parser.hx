package h3d.dae;
import h3d.dae.DAE;

class Parser {
	
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