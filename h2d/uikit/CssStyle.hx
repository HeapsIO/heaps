package h2d.uikit;

private class Rule {
	public var id : Int;
	public var priority : Int;
	public var cl : CssParser.CssClass;
	public var style : Array<Property.PValue<Dynamic>>;
	public var next : Rule;
	public function new() {
	}
}

@:access(h2d.uikit.Element)
class CssStyle {

	static var TAG = 0;

	var rules : Array<Rule>;
	var needSort = true;

	public function new() {
		rules = [];
	}

	function sortByPriority(r1:Rule, r2:Rule) {
		var dp = r2.priority - r1.priority;
		return dp == 0 ? r2.id - r1.id : dp;
	}

	function applyStyle( e : Element, force : Bool ) {
		if( needSort ) {
			needSort = false;
			rules.sort(sortByPriority);
		}
		if( e.needStyleRefresh || force ) {
			e.needStyleRefresh = false;
			var head = null;
			var tag = ++TAG;
			for( p in e.style )
				p.p.tag = tag;
			for( r in rules ) {
				if( !ruleMatch(r.cl,e) ) continue;
				var match = false;
				for( p in r.style )
					if( p.p.tag != tag ) {
						p.p.tag = tag;
						match = true;
					}
				if( match ) {
					r.next = head;
					head = r;
				}
			}
			// reset to default previously set properties that are no longer used
			var changed = false;
			var ntag = ++TAG;
			var i = e.currentSet.length - 1;
			while( i >= 0 ) {
				var p = e.currentSet[i--];
				if( p.tag == tag )
					p.tag = ntag;
				else {
					changed = true;
					e.currentSet.remove(p);
					e.component.getHandler(p)(e.obj,p.defaultValue);
				}
			}
			// apply new properties
			var r = head;
			while( r != null ) {
				for( p in r.style ) {
					var pr = p.p;
					var h = e.component.getHandler(pr);
					if( h == null ) continue;
					h(e.obj, p.v);
					changed = true;
					if( pr.tag != ntag ) {
						e.currentSet.push(pr);
						pr.tag = ntag;
					}
				}
				var n = r.next;
				r.next = null;
				r = n;
			}
			// reapply style properties
			if( changed )
				for( p in e.style ) {
					var h = e.component.getHandler(p.p);
					if( h != null ) h(e.obj, p.v);
				}
			// parent style has changed, we need to sync children
			force = true;
		}
		for( c in e.children )
			applyStyle(c, force);
	}

	public function add( sheet : CssParser.CssSheet ) {
		for( r in sheet ) {
			for( cl in r.classes ) {
				var nids = 0, nothers = 0, nnodes = 0;
				var c = cl;
				while( c != null ) {
					if( c.id != null ) nids++;
					if( c.node != null ) nnodes++;
					if( c.pseudoClass != null ) nothers++;
					if( c.className != null ) nothers++;
					c = c.parent;
				}
				var priority = (nids << 16) | (nothers << 8) | nnodes;
				var rule = new Rule();
				rule.id = rules.length;
				rule.cl = cl;
				rule.style = r.style;
				rule.priority = priority;
				rules.push(rule);
			}
		}
		needSort = true;
	}

	public static function ruleMatch( c : CssParser.CssClass, e : Element ) {
		if( c.pseudoClass != null ) {
			if( e.classes == null )
				return false;
			var pc = ":" + c.pseudoClass;
			var found = false;
			for( cc in e.classes )
				if( cc == pc ) {
					found = true;
					break;
				}
			if( !found )
				return false;
		}
		if( c.className != null ) {
			if( e.classes == null )
				return false;
			var found = false;
			for( cc in e.classes )
				if( cc == c.className ) {
					found = true;
					break;
				}
			if( !found )
				return false;
		}
		if( c.node != null && c.node != e.component.name )
			return false;
		if( c.id != null && c.id != e.id )
			return false;
		if( c.parent != null ) {
			var p = e.parent;
			while( p != null ) {
				if( ruleMatch(c.parent, p) )
					break;
				p = p.parent;
			}
			if( p == null )
				return false;
		}
		return true;
	}

}
