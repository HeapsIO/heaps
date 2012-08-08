package h3d.dae;
import h3d.dae.DAE;

class Printer {
	
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
