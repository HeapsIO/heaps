package hxd.inspect;

class Node {

	public var name(default,set) : String;
	public var parent(default, set) : Node;
	public var props : Void -> Array<Property>;
	public var j : vdom.JQuery;
	var childs : Array<Node>;

	static var currentJRoot : vdom.JQuery = null;

	public function new( name, ?parent ) {
		childs = [];
		initContent();
		this.name = name;
		this.parent = parent;
	}

	public function isDisposed() {
		return j == null || j.length == 0;
	}

	function getJRoot() : vdom.JQuery {
		return currentJRoot;
	}

	function initContent() {
	}

	function removeChild(n:Node) {
		childs.remove(n);
	}

	function addChild(n:Node) {
		childs.push(n);
	}

	function set_parent(p:Node) {
		if( parent != null )
			parent.removeChild(this);
		if( p != null )
			p.addChild(this);
		return parent = p;
	}

	public function getChildByName( name : String ) {
		for( n in childs )
			if( n.getPathName() == name )
				return n;
		return null;
	}

	public function getPathName() {
		return name;
	}

	public function getFullPath() {
		var n = getPathName();
		if( parent == null )
			return n;
		return parent.getFullPath() + "." + n;
	}

	public function dispose() {
		parent = null;
		if( j != null ) j.dispose();
		for( c in childs )
			c.dispose();
	}

	function set_name(v) {
		return name = v;
	}

}
