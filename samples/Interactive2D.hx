import h2d.col.RoundRect;
import h2d.col.Circle;
import h2d.col.Triangle;
import h2d.col.Point;
import h2d.col.Polygon;
import h2d.col.PolygonCollider;

class Interactive2D extends SampleApp {

	var hover : Bool;
	var shouldRotate : Bool;
	var interactive : h2d.Interactive;
	var graphics : h2d.Graphics;
	var polygonShape : PolygonCollider;
	var triangleShape : Triangle;
	var circleShape : Circle;
	var rectShape : RoundRect;

	static inline var rectY : Int = 32;
	static inline var rectWidth : Int = 64; // *2
	static inline var rectHeight : Int = 32;

	public function new() {
		super();
	}


	override private function init()
	{
		super.init();

		var poly : Polygon = new Polygon([
			new Point(64, 16), 
			new Point(96, 0), 
			new Point(127, 0), 
			new Point(127, 32), 
			new Point(111, 63), 
			new Point(127, 95), 
			new Point(127, 127), 
			new Point(96, 127), 
			new Point(64, 111), 
			new Point(32, 127), 
			new Point(1, 127), 
			new Point(1, 95), 
			new Point(17, 63), 
			new Point(1, 32), 
			new Point(1, 0), 
			new Point(32, 0), 
			new Point(64, 16), 
		]);
		// Polygon collider can be used both for single polygon or for multiple polygons at once.
		polygonShape = poly.getCollider();
		triangleShape = new Triangle(new Point(64, 0), new Point(128, 128), new Point(0, 128));
		circleShape = new Circle(64, 64, 64);
		rectShape = new RoundRect(rectWidth, rectY+rectHeight, rectWidth*2, rectHeight*2, 0);

		interactive = new h2d.Interactive(128, 128, s2d);
		graphics = new h2d.Graphics(interactive);

		interactive.onOver = function( e : hxd.Event ) {
			hover = true;
			redrawGraphics();
		}
		interactive.onOut = function( e : hxd.Event ) {
			hover = false;
			redrawGraphics();
		}

		addCheck("isEllipse", function() return interactive.isEllipse, function(v) interactive.isEllipse = v);
		addCheck("Rotate", function() return shouldRotate, function(v) {
			shouldRotate = v;
			if (!v) setRotation(0);
		});
		addChoice("Shape", ["Polygon", "Triangle", "Circle", "RoundRect", "None"], setShape, 0);
		setShape(0);
	}

	function setRotation( v : Float ) {
		interactive.rotation = v;
		var cos = Math.cos(v);
		var sin = Math.sin(v);
		var hw = -interactive.width * .5;
		var hh = -interactive.height * .5;
		interactive.x = s2d.width  * .5 + (cos * hw - sin * hh);
		interactive.y = s2d.height * .5 + (sin * hw + cos * hh);
	}

	function redrawGraphics() {
		graphics.clear();
		graphics.beginFill(hover ? 0xff0000 : 0xf8931f);
		if (interactive.shape == polygonShape) {
			for (polygon in polygonShape.polygons) {
				var it = polygon.iterator();
				var pt = it.next();
				graphics.moveTo(pt.x, pt.y);

				while (it.hasNext()) {
					pt = it.next();
					graphics.lineTo(pt.x, pt.y);
				}
			}
		} else if (interactive.shape == triangleShape) {
			graphics.moveTo(triangleShape.a.x, triangleShape.a.y);
			graphics.lineTo(triangleShape.b.x, triangleShape.b.y);
			graphics.lineTo(triangleShape.c.x, triangleShape.c.y);
		} else if (interactive.shape == circleShape) {
			graphics.drawCircle(circleShape.x, circleShape.y, circleShape.ray);
		} else if (interactive.shape == rectShape) {
				var size = rectWidth - rectHeight;
				var k = 10;
				for( i in 0...k+1 ) {
					var a = Math.PI * i / k - Math.PI / 2;
					graphics.lineTo(size + rectWidth + rectHeight * Math.cos(a), rectY + rectHeight + rectHeight * Math.sin(a));
				}
				for( i in 0...k+1 ) {
					var a = Math.PI * i / k + Math.PI / 2;
					graphics.lineTo(-size + rectWidth + rectHeight * Math.cos(a), rectY + rectHeight + rectHeight * Math.sin(a));
				}
		} else {
			graphics.drawRect(0, 0, interactive.width, interactive.height);
		}

		graphics.endFill();
	}

	function setShape( index : Int ) {

		switch (index) {
			case 0: interactive.shape = polygonShape;
			case 1: interactive.shape = triangleShape;
			case 2: interactive.shape = circleShape;
			case 3: interactive.shape = rectShape;
			case 4: interactive.shape = null;
		}

		redrawGraphics();
		setRotation(interactive.rotation);
	}

	override private function update(dt:Float)
	{
		super.update(dt);
		if (shouldRotate) setRotation(interactive.rotation + dt * .1);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Interactive2D();
	}

}