package hxd.inspect;

class TreeNode extends Node {

	public var icon(default, set) : String;
	public var openIcon(default, set) : Null<String>;
	var jchild : vdom.JQuery;

	override function initContent() {
		j = getJRoot().query("<li>");
		j.html('<i/><div class="content"></div>');
		j.children("i").click(function(_) {
			if( jchild != null ) {
				j.toggleClass("expand");
				if( openIcon != null ) syncIcon();
				jchild.slideToggle(50);
			}
		});
		j.children(".content").click(function(_) click());
	}

	public function click() {
		getJRoot().find(".selected").removeClass("selected");
		j.addClass("selected");
		onSelect();
	}

	override function getJRoot() {
		return parent == null ? super.getJRoot() : parent.getJRoot();
	}

	override function removeChild(n:Node) {
		super.removeChild(n);
		n.j.detach();
		if( jchild != null && jchild.get().numChildren == 0 ) {
			j.toggleClass("expand",false);
			jchild.remove();
			jchild = null;
		}
	}

	override function addChild(n:Node) {
		super.addChild(n);
		if( jchild == null ) {
			j.toggleClass("expand",true);
			jchild = j.query("<ul>");
			jchild.addClass("elt");
			jchild.appendTo(j);
			if( openIcon != null ) syncIcon();
		}
		n.j.appendTo(jchild);
	}

	override function getPathName() {
		return name.split(".").join(" ");
	}

	public dynamic function onSelect() {
	}

	override function set_name(v) {
		j.children(".content").text(v);
		return name = v;
	}

	function syncIcon() {
		j.children("i").attr("class", "fa fa-"+(openIcon == null || !j.hasClass("expand") ? icon : openIcon));
	}

	function set_icon(v) {
		icon = v;
		syncIcon();
		return v;
	}

	function set_openIcon(v) {
		openIcon = v;
		syncIcon();
		return v;
	}

}
