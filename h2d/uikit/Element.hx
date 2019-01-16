package h2d.uikit;

class Element {

	public var obj : h2d.Object;
	public var component : Component<Dynamic>;
	public var classes : Array<String> = [];
	public var parent : Element;
	public var children : Array<Element> = [];
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
		trace( Std.string(p) );
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