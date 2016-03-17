package hxd.inspect;

class TreeNode extends Node {

	public var icon(default, set) : String;
	var jchild : cdb.jq.JQuery;

	override function initContent() {
		j = getJRoot().query("<li>");
		j.html('<i/><div class="content"></div>');
		j.children("i").click(function(_) {
			if( jchild != null ) {
				j.toggleClass("expand");
				jchild.slideToggle(50);
			}
		});
		j.children(".content").click(function(_) {
			getJRoot().find(".selected").removeClass("selected");
			j.addClass("selected");
			onSelect();
		});
	}

	override function getJRoot() {
		return parent == null ? super.getJRoot() : parent.getJRoot();
	}

	override function removeChild(n:Node) {
		super.removeChild(n);
		n.j.detach();
		if( jchild.get().numChildren == 0 ) {
			jchild.remove();
			jchild = null;
		}
	}

	override function addChild(n:Node) {
		super.addChild(n);
		if( jchild == null ) {
			jchild = j.query("<ul>");
			jchild.addClass("elt");
			jchild.appendTo(j);
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

	function set_icon(v) {
		j.children("i").attr("class", "fa fa-"+v);
		return icon = v;
	}

}
