package h3d.dae;

enum RuleMatch {
	MNo;
	MParent;
	MExact;
	MSub;
}

class Rule {
	
	var rule : String;
	var parts : Array<{ n : String, ?a : { n : String, v : Array<DAE> -> String -> Bool } }>;
	
	public function new( r : String ) {
		rule = r;
		parts = [];
		var r_ident = ~/^[A-Za-z0-9_-]+|[?]$/;
		var r_attr = ~/^([A-Za-z0-9_-]+|[?])\[([A-Za-z0-9_-]+)=/;
		var pl = r.split(".");
		while( pl.length > 0 ) {
			var p = pl.shift();
			if( r_attr.match(p) ) {
				var n = r_attr.matched(1).toLowerCase();
				var attr = r_attr.matched(2).toLowerCase();
				var rest = r_attr.matchedRight() + (pl.length == 0 ? "" : "." + pl.join("."));
				var close = rest.indexOf(']');
				var open = rest.indexOf('{');
				var check = null;
				if( open >= 0 && open < close ) {
					var count = 1;
					var prefix = rest.substr(0, open);
					var pos = open + 1;
					while( true ) {
						var c = StringTools.fastCodeAt(rest, pos);
						if( StringTools.isEOF(c) )
							throw "Unclosed }";
						if( c == '{'.code )
							count++;
						if( c == '}'.code ) {
							count--;
							if( count == 0 ) break;
						}
						pos++;
					}
					if( rest.charCodeAt(pos + 1) != ']'.code )
						throw "Unclosed ]";
					var expr = rest.substr(open + 1, pos - (open + 1));
					check = checkAttrRule(prefix, parts.length, expr);
					rest = rest.substr(pos + 3);
				} else {
					if( close < 0 ) throw "Unclosed [";
					var value = rest.substr(0, close);
					rest = rest.substr(close + 2);
					check = function(_, v) return v == value;
				}
				pl = rest == "" ? [] : rest.split(".");
				parts.push( { n : n, a : { n : attr, v : check } } );
			} else if( r_ident.match(p) )
				parts.push( { n : p.toLowerCase() } );
			else
				throw "Invalid '"+p+"' in '" + r+"'";
		}
	}
	
	function checkAttrRule( prefix : String, depth : Int, expr : String ) {
		var r = new Rule(expr);
		var attrib = r.parts.pop().n.toLowerCase();
		while( r.parts.length > 0 ) {
			var p0 = r.parts[0];
			if( p0.a == null && p0.n == "_" ) {
				depth--;
				r.parts.shift();
			} else
				break;
		}
		var p0 = { n : "" };
		var targetPrefix = "";
		if( prefix == "&" ) {
			targetPrefix = "#";
			prefix = "";
		}
		r.parts.unshift(p0);
		return function(tree:Array<DAE>, v:String) {
			var p = tree[depth];
			if( p == null )
				return false;
			p0.n = p.name;
			for( x in r.match(p) ) {
				for( a in x.attribs )
					if( a.n.toLowerCase() == attrib ) {
						if( prefix + Tools.toString(a.v) == targetPrefix + v )
							return true;
						break;
					}
			}
			return false;
		};
	}
	
	public function matchTree( tree : Array<DAE> ) : RuleMatch {
		for( i in 0...parts.length ) {
			var t = tree[i];
			if( t == null ) return MParent;
			var p = parts[i];
			if( t.name.toLowerCase() != p.n && p.n != "?" )
				return MNo;
			if( p.a != null ) {
				if( t.attribs == null )
					return MNo;
				var found = false;
				for( a in t.attribs )
					if( a.n.toLowerCase() == p.a.n ) {
						if( !p.a.v(tree,Tools.toString(a.v)) )
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
	
	public function matchSingleOpt( n : DAE ) {
		var r = match(n);
		if( r.length == 0 ) return null;
		if( r.length > 1 ) throw r.length + " nodes matching " + rule + " found";
		return r[0];
	}

}

