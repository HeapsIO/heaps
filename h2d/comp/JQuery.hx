package h2d.comp;
import h2d.css.Defs;

private typedef Query = Array<CssClass>;

@:access(h2d.comp.Component)
@:keep
class JQuery {

	var root : Component;
	var select : Array<Component>;

	public function new( root : Component, query : Dynamic ) {
		while( root.parentComponent != null )
			root = root.parentComponent;
		this.root = root;
		select = getSet(query);
	}

	public function getComponents() {
		return select;
	}

	public function toggleClass( cl : String, ?flag : Bool ) {
		for( s in select ) s.toggleClass(cl,flag);
		return this;
	}

	public function find( q : Dynamic ) {
		if( Std.is(q, Component) )
			return new JQuery(root, Lambda.has(select, q) ? null : q);
		if( Std.is(q, String) ) {
			var q = parseQuery(q);
			var out = [];
			for( s in select )
				lookupRec(s, q, out);
			return new JQuery(root, out);
		}
		throw "Invalid JQuery " + q;
		return null;
	}

	public function filter( q : Dynamic ) {
		if( Std.is(q, Component) )
			return new JQuery(root, Lambda.has(select, q) ? null : q);
		if( Std.is(q, String) ) {
			var q = parseQuery(q);
			return new JQuery(root, [for( s in select ) if( matchQuery(q, s) ) s]);
		}
		if( Std.is(q, JQuery) ) {
			var q : JQuery = q;
			return  new JQuery(root, [for( s in select ) if( Lambda.has(q.select, s) ) s]);
		}
		throw "Invalid JQuery " + q;
		return null;
	}

	public function not( q : Dynamic ) {
		if( Std.is(q, Component) )
			return new JQuery(root, [for( s in select ) if( s != q ) s]);
		if( Std.is(q, String) ) {
			var q = parseQuery(q);
			return new JQuery(root, [for( s in select ) if( !matchQuery(q, s) ) s]);
		}
		if( Std.is(q, JQuery) ) {
			var q : JQuery = q;
			return  new JQuery(root, [for( s in select ) if( !Lambda.has(q.select, s) ) s]);
		}
		throw "Invalid JQuery " + q;
		return null;
	}

	public function click( f : JQuery -> Void ) {
		for( c in select ) {
			var int = Std.instance(c, Interactive);
			if( int == null ) throw c + " is not interactive";
			int.onClick = function() f(new JQuery(root,c));
		}
		return this;
	}

	public function show() {
		for( s in select )
			s.getStyle(true).display = true;
		return this;
	}

	public function hide() {
		for( s in select )
			s.getStyle(true).display = false;
		return this;
	}

	public function toggle() {
		for( s in select ) {
			var s = s.getStyle(true);
			s.display = !s.display;
		}
		return this;
	}

	public function iterator() {
		var it = select.iterator();
		return {
			hasNext : it.hasNext,
			next : function() return new JQuery(root, it.next()),
		};
	}

	function _get_val() : Dynamic {
		var c = select[0];
		if( c == null ) return null;
		return switch( c.name ) {
		case "slider":
			cast(c, h2d.comp.Slider).value;
		case "checkbox":
			cast(c, h2d.comp.Checkbox).checked;
		case "input":
			cast(c, h2d.comp.Input).value;
		case "color":
			cast(c, h2d.comp.Color).value;
		case "itemlist":
			cast(c, h2d.comp.ItemList).selected;
		case "select":
			cast(c, h2d.comp.Select).value;
		default:
			null;
		}
	}

	function _set_val( v : Dynamic ) {
		for( c in select )
			switch( c.name ) {
			case "slider":
				cast(c, h2d.comp.Slider).value = v;
			case "checkbox":
				cast(c, h2d.comp.Checkbox).checked = v != null && v != false;
			case "input":
				cast(c, h2d.comp.Input).value = Std.string(v);
			case "color":
				cast(c, h2d.comp.Color).value = v;
			case "itemlist":
				cast(c, h2d.comp.ItemList).selected = v;
			case "select":
				cast(c, h2d.comp.Select).setValue(v);
			default:
				null;
			}
		return this;
	}

	function _get_text() {
		var c = select[0];
		if( c == null ) return "";
		return switch( c.name ) {
		case "button":
			cast(c, h2d.comp.Button).text;
		case "label":
			cast(c, h2d.comp.Label).text;
		default:
			"";
		}
	}

	function _set_text(v:String) {
		for( c in select )
			switch( c.name ) {
			case "button":
				cast(c, h2d.comp.Button).text = v;
			case "label":
				cast(c, h2d.comp.Label).text = v;
			default:
			}
		return this;
	}

	function _set_style(v:String) {
		var s = new h2d.css.Style();
		new h2d.css.Parser().parse(v, s);
		for( c in select )
			c.addStyle(s);
		return this;
	}

	function getSet( query : Dynamic ) {
		var set;
		if( query == null )
			set = [];
		else if( Std.is(query,Component) )
			set = [query];
		else if( Std.is(query, Array) ) {
			var a : Array<Dynamic> = query;
			for( v in a ) if( !Std.is(v, Component) ) throw "Invalid JQuery "+query;
			set = a;
		} else if( Std.is(query, String) )
			set = lookup(root, query);
		else
			throw "Invalid JQuery " + query;
		return set;
	}

	function lookup( root : Component, query : String ) {
		var set = [];
		lookupRec(root, parseQuery(query), set);
		return set;
	}

	function parseQuery(q) : Query {
		return new h2d.css.Parser().parseClasses(q);
	}

	function matchQuery(q:Query, comp:Component) {
		for( r in q )
			if( h2d.css.Engine.ruleMatch(r, comp) )
				return true;
		return false;
	}

	function lookupRec(comp:Component, q, set : Array<Component> ) {
		if( matchQuery(q, comp) )
			set.push(comp);
		for( s in comp.components )
			lookupRec(s, q, set);
	}

}