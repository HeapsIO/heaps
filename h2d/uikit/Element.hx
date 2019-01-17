package h2d.uikit;

class Element {

	public var id : String;
	public var obj : h2d.Object;
	public var component : Component<Dynamic>;
	public var classes : Array<String>;
	public var parent : Element;
	public var children : Array<Element> = [];
	public var style : Array<Property.PValue<Dynamic>> = [];
	var currentSet : Array<Property<Dynamic>> = [];
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

	public function setAttribute<P>( p : Property<P>, value : P ) {
		if( p.id == pclass.id ) {
			classes = cast value;
			classes = classes.copy();
			needStyleRefresh = true;
			return true;
		}
		var handler = component.getHandler(p);
		if( handler == null )
			return false;
		var found = false;
		for( s in style )
			if( s.p == p ) {
				style.remove(s);
				s.v = value;
				style.push(s);
				found = true;
				break;
			}
		if( !found ) {
			currentSet.push(p);
			style.push(new Property.PValue(p,value));
		}
		handler(obj,value);
		return true;
	}

	static var pclass = new Property("class", parseClass, []);
	static function parseClass( v : CssParser.Value ) {
		return switch( v ) {
		case VIdent(i):
			return [i];
		case VGroup(l):
			return [for( v in l ) switch(v) { case VIdent(i): i; default: throw new Property.InvalidProperty(); }];
		default:
			throw new Property.InvalidProperty();
		}
	}

}