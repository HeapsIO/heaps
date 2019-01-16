package h2d.uikit;

private class Rule {
	public var id : Int;
	public var priority : Int;
	public var cl : CssParser.CssClass;
	public var properties : Array<Property>;
	public function new() {
	}
}

@:access(h2d.uikit.Element)
class CssEngine {

	var rules : Array<Rule>;
	var needSort = true;

	public function new() {
		rules = [];
	}

	function sortByPriority(r1:Rule, r2:Rule) {
		var dp = r1.priority - r2.priority;
		return dp == 0 ? r1.id - r2.id : dp;
	}

	public function applyStyle( e : Element ) {
		if( needSort ) {
			needSort = false;
			rules.sort(sortByPriority);
		}
		if( e.needStyleRefresh ) {
			e.needStyleRefresh = false;
			for( r in rules ) {
				if( !ruleMatch(r.cl,e) ) continue;
			}
		}
	}

	public function add( sheet : CssParser.CssSheet ) {
		for( r in sheet ) {
			var important = [];
			for( p in r.style ) {
				switch( p ) {
				case PImportant(p): important.push(p);
				default:
				}
			}
			var style = r.style;
			if( important.length != 0 )
				style = [for( p in r.style ) if( !p.match(PImportant(_)) ) p];
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

				if( style.length > 0 ) {
					var rule = new Rule();
					rule.id = rules.length;
					rule.cl = cl;
					rule.properties = style;
					rule.priority = priority;
					rules.push(rule);
				}

				if( important.length > 0 ) {
					var rule = new Rule();
					rule.id = rules.length;
					rule.cl = cl;
					rule.properties = important;
					rule.priority = (1<<24) | priority;
					rules.push(rule);
				}
			}
		}
		needSort = true;
	}

	public static function ruleMatch( c : CssParser.CssClass, e : Element ) {
		if( c.pseudoClass != null ) {
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
		if( c.node != null && c.node != e.obj.name )
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
