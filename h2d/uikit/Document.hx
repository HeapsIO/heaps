package h2d.uikit;

class Document {

	public var elements : Array<Element> = [];
	public var style(default,null) : CssStyle;

	public function new() {
	}

	public function setStyle( s : CssStyle ) {
		if( s == null ) s = new CssStyle();
		style = s;
		for( e in elements )
			@:privateAccess s.applyStyle(e,true);
	}

	public function remove() {
		for( e in elements )
			e.remove();
	}

	public function addTo( obj : h2d.Object ) {
		for( e in elements )
			obj.addChild(e.obj);
	}

}