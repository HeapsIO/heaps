package hxd.inspect;

class Node {

	public var name(default,set) : String;
	public var parent(default, set) : Node;
	public var props : Void -> Array<Property>;
	public var j : cdb.jq.JQuery;
	var childs : Array<Node>;

	public function new( name, ?parent ) {
		childs = [];
		initContent();
		this.name = name;
		this.parent = parent;
	}

	function getJRoot() {
		return @:privateAccess Inspector.current.jroot;
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

	public function getPathName() {
		return name;
	}

	public function getFullPath() {
		var n = getPathName();
		if( parent == null )
			return n;
		return parent.getFullPath() + "." + n;
	}

	function dispose() {
		if( j != null ) j.dispose();
	}

	public function remove() {
		parent = null;
		dispose();
		for( c in childs )
			c.remove();
	}

	function set_name(v) {
		return name = v;
	}

}
