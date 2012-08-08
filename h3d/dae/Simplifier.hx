package h3d.dae;

class Simplifier {

	var rules : Array<{ r : Rule, f : DAE -> Bool }>;
	
	public function new() {
		rules = new Array();
	}
	
	public function keep( path : String ) {
		filter(path, function(_) return true);
	}
	
	public function filter( path : String, f ) {
		rules.push( { r : new Rule(path), f : f } );
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
		if( n.attribs != null )
			n2.attribs = n.attribs.copy();
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
			switch( r.r.matchTree(stack) ) {
			case MNo, MSub:
			case MExact:
				if( r.f(n) )
					return copyNode(n);
			case MParent:
				checkSub = true;
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