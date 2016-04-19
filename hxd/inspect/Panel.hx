package hxd.inspect;

enum DockDirection {
	Left;
	Right;
	Up;
	Down;
	Fill;
}

class Panel extends Node {

	var inspect : Inspector;
	var panel : cdb.jq.JQuery;
	var saveDock : { align : DockDirection, size : Float, into : Panel };
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
	}

	public function dock( align : DockDirection, ?size : Float, ?into : Panel ) {
		undock();
		saveDock = { align : align, size : size, into : into };
		panel = j.query("<panel>");
		panel.appendTo(into == null || into.panel == null ? @:privateAccess inspect.jroot : into.panel);
		if( caption != null ) panel.attr("caption", caption);
		panel.attr("docksize", "" + size);
		panel.attr("dock", "" + align);
		panel.bind("paneldock", function(e) {
			if( e.target == null ) {
				visible = false;
				onClose();
				return;
			}
		});
		visible = true;
		j.appendTo(panel);
	}

	public dynamic function onClose() {
	}

	override function dispose() {
		undock();
		super.dispose();
	}

	public function undock() {
		if( panel == null ) return;
		j.detach();
		panel.removeAttr("dock");
		panel.dispose();
		panel = null;
		visible = false;
	}

	function set_caption(c) {
		if( panel != null ) panel.attr("caption", c);
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

	public function show() {
		if( visible ) return;
		var old = saveDock;
		if( saveDock != null && saveDock.into != null && saveDock.into.visible )
			dock(saveDock.align, saveDock.size, saveDock.into);
		else {
			dock(Fill);
			saveDock = old;
		}
	}

	public function sync() {
	}

}