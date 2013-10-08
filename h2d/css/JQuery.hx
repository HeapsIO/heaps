package h2d.css;
import h2d.comp.Component;

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
	
	public function toggleClass( cl : String ) {
		for( s in select ) s.toggleClass(cl);
		return this;
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
		var s = new Style();
		new Parser().parse(v, s);
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
		} else if( Std.is(query, String) ) {
			set = lookupSet(query);
		} else
			throw "Invalid JQuery " + query;
		return set;
	}
	
	function lookupSet( query : String ) {
		var classes = new Parser().parseClasses(query);
		var set = [];
		lookupRec(root, classes, set);
		return set;
	}
	
	function lookupRec(comp:Component, classes:Array<Defs.CssClass>, set : Array<Component> ) {
		for( c in classes )
			if( Engine.ruleMatch(c, comp) ) {
				set.push(comp);
				break;
			}
		for( s in comp.components )
			lookupRec(s, classes, set);
	}
	
}