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
}

typedef CssClass = {
	var parent : Null<CssClass>;
	var node : Null<String>;
	var className : Null<String>;
	var pseudoClass : Null<String>;
	var id : Null<String>;
}
