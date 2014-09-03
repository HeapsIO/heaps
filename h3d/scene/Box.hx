package h3d.scene;

class Box extends Graphics {

	public var color : Int;

	public function new( ?color = 0xFFFF0000, ?depth = true, ?parent) {
		super(parent);
		this.color = color;
		if( !depth ) material.mainPass.depth(true, Always);

		var dx = new h3d.col.Point(1, 0, 0);
		var dy = new h3d.col.Point(0, 1, 0);
		var dz = new h3d.col.Point(0, 0, 1);
		var p = new h3d.col.Point(-0.5,-0.5,-0.5);

		lineStyle(1, color);
		drawLine(p, p.add(dx));
		drawLine(p, p.add(dy));
		drawLine(p, p.add(dz));
		drawLine(p.add(dx), p.add(dx).add(dz));
		drawLine(p.add(dy), p.add(dy).add(dz));
		drawLine(p.add(dx), p.add(dx).add(dy));
		drawLine(p.add(dy), p.add(dx).add(dy));
		drawLine(p.add(dx).add(dy), p.add(dx).add(dy).add(dz));
		p = p.add(dz);
		drawLine(p, p.add(dx));
		drawLine(p, p.add(dy));
		drawLine(p.add(dx), p.add(dx).add(dy));
		drawLine(p.add(dy), p.add(dx).add(dy));
		drawLine(p.add(dy), p.add(dx).add(dy));
	}

	public static function ofBounds( bounds : h3d.col.Bounds, ?parent : Object ) {
		var b = new Box();
		if( parent != null ) parent.addChild(b);
		b.x = (bounds.xMin + bounds.xMax) * 0.5;
		b.y = (bounds.yMin + bounds.yMax) * 0.5;
		b.z = (bounds.zMin + bounds.zMax) * 0.5;
		b.scaleX = bounds.xMax - bounds.xMin;
		b.scaleY = bounds.yMax - bounds.yMin;
		b.scaleZ = bounds.zMax - bounds.zMin;
		return b;
	}

}