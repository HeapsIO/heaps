package h2d.uikit;

enum SetAttributeResult {
	Ok;
	Unknown;
	Unsupported;
	InvalidValue( ?msg : String );
}

class Element {

	public var id : String;
	public var obj : h2d.Object;
	public var component : Component<Dynamic>;
	public var classes : Array<String>;
	public var parent : Element;
	public var children : Array<Element> = [];
	var style : Array<{ p : Property, value : Any }> = [];
	var currentSet : Array<Property> = [];
	var needStyleRefresh : Bool = true;

	public function new(obj,component,?parent) {
		this.obj = obj;
		this.component = component;
		this.parent = parent;
		if( parent != null ) parent.children.push(this);
	}

	public function remove() {
		if( parent != null ) {
			parent.children.remove(this);
			parent = null;
		}
		obj.remove();
	}

	/*
	public function initAttributes( attr : haxe.DynamicAccess<String> ) {
		var p = new CssParser();
		for( a in attr.keys() ) {
			var h = component.getHandler()
			var v = attr.get(a);
			var value = p.parseValue(v);
		}
	}*/

	public function setAttribute( p : String, value : CssValue ) : SetAttributeResult {
		var p = Property.get(p,false);
		if( p == null )
			return Unknown;
		if( p.id == pclass.id ) {
			switch( value ) {
			case VIdent(i): classes = [i];
			case VGroup(vl): classes = [for( v in vl ) switch( v ) { case VIdent(i): i; default: return InvalidValue(); }];
			default: return InvalidValue();
			}
			needStyleRefresh = true;
			return Ok;
		}
		var handler = component.getHandler(p);
		if( handler == null )
			return Unsupported;
		var v : Dynamic;
		try {
			v = handler.parser(value);
		} catch( e : Property.InvalidProperty ) {
			return InvalidValue(e.message);
		}
		var found = false;
		for( s in style )
			if( s.p == p ) {
				s.value = v;
				style.remove(s);
				style.push(s);
				found = true;
				break;
			}
		if( !found ) {
			style.push({ p : p , value : v });
			for( s in currentSet )
				if( s == p ) {
					found = true;
					break;
				}
			if( !found ) currentSet.push(p);
		}
		handler.apply(obj,v);
		return Ok;
	}

	static var pclass = Property.get("class");

}