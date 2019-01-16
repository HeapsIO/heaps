package h2d.uikit;

class Element {

	public var id : String;
	public var obj : h2d.Object;
	public var component : Component<Dynamic>;
	public var classes : Array<String>;
	public var parent : Element;
	public var children : Array<Element> = [];
	public var style : Array<Property> = [];
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

	public function setProp( p : Property ) {
		switch( p ) {
		case PClasses(cl):
			classes = cl.copy();
			needStyleRefresh = true;
			return true;
		default:
			return component.handleProp(obj, p);
		}
	}

}