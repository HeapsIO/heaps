package hxd.fmt.grd;

class Gradient {
	public var name              : String;
	public var interpolation     : Float;
	public var colorStops        : Array<ColorStop>;
	public var transparencyStops : Array<TransparencyStop>;
	public var gradientStops     : Array<GradientStop>;

	public function new() {
		colorStops = [];
		transparencyStops = [];
		gradientStops = [];
	}
}

class ColorStop {
	public var color    : Color;
	public var location : Int;
	public var midpoint : Int;
	public var type     : ColorStopType;

	public function new() {}
}

enum ColorStopType {
	User;
	Background;
	Foreground;
}

class TransparencyStop  {
	public var opacity  : Float;
	public var location : Int;
	public var midpoint : Int;

	public function new() {}
}

enum Color {
	RGB(r:Float, g:Float, b:Float);
	HSB(h:Float, s:Float, b:Float);
}

class GradientStop {
	public var opacity   : Float;
	public var colorStop : ColorStop;

	public function new() {}
}

class Data extends haxe.ds.StringMap<Gradient> { }
