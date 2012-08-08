package h3d.dae;

enum RuleMatch {
	MNo;
	MParent;
	MExact;
	MSub;
}

class Rule {
	
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
						if( Tools.toString(a.v) != p.a.v )
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

