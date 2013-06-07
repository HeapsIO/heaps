package h2d.comp;

enum Unit {
	Pix( v : Float );
	Percent( v : Float );
	EM( v : Float );
}

enum FillStyle {
	Transparent;
	Color( c : Int );
	Gradient( a : Int, b : Int, c : Int, d : Int );
}

enum Layout {
	Horizontal;
	Vertical;
}

typedef CssClass = {
	var parent : Null<CssClass>;
	var node : Null<String>;
	var className : Null<String>;
	var pseudoClass : Null<String>;
	var id : Null<String>;
}

class Resize {
	// measure props
	public var measure : Bool;
	public var maxWidth : Float;
	public var maxHeight : Float;
	// arrange props
	public var xPos : Null<Float>;
	public var yPos : Null<Float>;
	
	public function new(w, h) {
		this.maxWidth = w;
		this.maxHeight = h;
		measure = true;
	}
}