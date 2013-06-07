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
		throw "Invalid JQuery " + query;
		return null;
	}
	
}