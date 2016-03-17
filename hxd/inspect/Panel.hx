package hxd.inspect;

class Panel extends Node {

	var inspect : SceneInspector;
	public var visible(default, null) : Bool;
	public var caption(default, set) : String;
	public var content : cdb.jq.JQuery;

	public function new( name, caption, ?panelGroup ) {
		super(name, panelGroup);
		this.caption = caption;
		@:privateAccess {
			inspect = SceneInspector.current;
			inspect.panels.push(this);
			inspect.rootNodes.push(this);
		}
		if( name == null ) onClose = remove;
	}

	public function dock( to : cdb.jq.JQuery, align : cdb.jq.Message.DockDirection, ?size : Float ) {
		j.dock(to.get(), align, size);
		visible = true;
	}

	function set_caption(c) {
		j.attr("caption", c);
		return caption = c;
	}

	override function initContent() {
		j = getJRoot().query('<div>');
		j.addClass("panel");
	}

	override function addChild(n:Node)	{
		super.addChild(n);
		n.j.appendTo(content);
	}

	override function removeChild(n:Node) {
		super.removeChild(n);
		n.j.detach();
	}

	override function set_parent(p:Node) {
		// no physical attachment
		if( parent != null )
			parent.childs.remove(this);
		if( p != null )
			p.childs.push(this);
		return parent = p;
	}

	public dynamic function onClose() {
		visible = false;
	}

	public function show() {
		trace("TODO");
		visible = true;
	}

	public function sync() {
	}

}