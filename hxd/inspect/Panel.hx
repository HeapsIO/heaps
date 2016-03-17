package hxd.inspect;

class Panel extends Node {

	var inspect : Inspector;
	public var visible(default, null) : Bool;
	public var caption(default, set) : String;
	public var content : cdb.jq.JQuery;

	public function new( name, caption, ?panelGroup ) {
		super(name, panelGroup);
		this.caption = caption;
		@:privateAccess {
			inspect = Inspector.current;
			inspect.panels.push(this);
			inspect.rootNodes.push(this);
		}
		if( name == null ) onClose = remove;
	}

	public function dock( to : cdb.jq.JQuery, align : cdb.jq.Message.DockDirection, ?size : Float ) {
		j.dock(to.get(), align, size);
		j.bind("panelclose", function(_) onClose());
		visible = true;
	}

	function set_caption(c) {
		j.attr("caption", c);
		return caption = c;
	}

	override function getJRoot() {
		if( j == null ) return super.getJRoot();
		return j;
	}

	override function initContent() {
		var root = getJRoot();
		j = root.query('<div>');
		j.addClass("panel");
		content = j;
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
		trace("TODO:UNDOCK");
	}

	public function show() {
		trace("TODO:REDOCK");
		visible = true;
	}

	public function sync() {
	}

}