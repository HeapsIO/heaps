package h3d.scene;

class Graphics extends Mesh {

	var curX : Float = 0.;
	var curY : Float = 0.;
	var curZ : Float = 0.;

	public function new(?parent) {
		super(null, null, parent);
	}

	public function clear() {
	}

	public function selectColor(color : Int) {
	}

	public function lineSize( v : Float ) {
	}

	public function lineStyle( size, color ) {
		lineSize(size);
		selectColor(color);
	}

	public inline function drawLine( p1 : h3d.col.Point, p2 : h3d.col.Point ) {
		moveTo(p1.x, p1.y, p1.z);
		lineTo(p2.x, p2.y, p2.z);
	}

	public function moveTo( x : Float, y : Float, z : Float ) {
		curX = 0;
		curY = 0;
		curZ = 0;
	}

	public function lineTo( x : Float, y : Float, z : Float ) {
		throw "TODO";
	}

}