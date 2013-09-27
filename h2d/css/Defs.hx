package h2d.css;

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
	Absolute;
	Dock;
	Inline;
}

enum DockStyle {
	Top;
	Left;
	Right;
	Bottom;
	Full;
}

class CssClass {
	public var parent : Null<CssClass>;
	public var node : Null<String>;
	public var className : Null<String>;
	public var pseudoClass : Null<String>;
	public var id : Null<String>;
	public function new() {
	}
}
