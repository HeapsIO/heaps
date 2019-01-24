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

	public function initAttributes( attr : haxe.DynamicAccess<String> ) {
		var parser = new CssParser();
		for( a in attr.keys() ) {
			var p = Property.get(a,false);
			if( p == null ) continue;
			var h = component.getHandler(p);
			if( h == null && p != pclass && p != pid ) continue;
			setAttribute(a, parser.parseValue(attr.get(a)));
		}
	}

	public function setAttribute( p : String, value : CssValue ) : SetAttributeResult {
		var p = Property.get(p,false);
		if( p == null )
			return Unknown;
		if( p.id == pid.id ) {
			switch( value ) {
			case VIdent(i):
				if( id != i ) {
					id = i;
					needStyleRefresh = true;
				}
			default: return InvalidValue();
			}
			return Ok;
		}
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
	static var pid = Property.get("id");
	public static function create( comp : String, attributes : haxe.DynamicAccess<String>, ?parent : Element, ?value : h2d.Object ) {
		var c = Component.get(comp);
		if( c == null ) throw "Unknown component "+comp;
		var e = new Element(value == null ? c.make(parent == null ? null : parent.obj) : value, c, parent);
		if( attributes != null ) e.initAttributes(attributes);
		return e;
	}

}