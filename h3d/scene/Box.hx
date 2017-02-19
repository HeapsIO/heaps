package h3d.scene;

class Box extends Graphics {

	public var color : Int;
	public var bounds : h3d.col.Bounds;
	var prevXMin = 1e9;
	var prevYMin = 1e9;
	var prevZMin = 1e9;
	var prevXMax = -1e9;
	var prevYMax = -1e9;
	var prevZMax = -1e9;

	public function new( ?color = 0xFFFF0000, ?bounds : h3d.col.Bounds, ?depth = true, ?parent) {
		super(parent);
		this.color = color;
		this.bounds = bounds;
		if( !depth ) material.mainPass.depth(true, Always);
	}

	override function sync(ctx) {
		if( bounds == null ) {
			if( prevXMin == -0.5 && prevYMin == -0.5 && prevZMin == -0.5 && prevXMax == 0.5 && prevYMax == 0.5 && prevZMax == 0.5 )
				return;
			prevXMin = -0.5;
			prevYMin = -0.5;
			prevZMin = -0.5;
			prevXMax = 0.5;
			prevYMax = 0.5;
			prevZMax = 0.5;
		} else {
			if( prevXMin == bounds.xMin && prevYMin == bounds.yMin && prevZMin == bounds.zMin && prevXMax == bounds.xMax && prevYMax == bounds.yMax && prevZMax == bounds.zMax )
				return;
			prevXMin = bounds.xMin;
			prevYMin = bounds.yMin;
			prevZMin = bounds.zMin;
			prevXMax = bounds.xMax;
			prevYMax = bounds.yMax;
			prevZMax = bounds.zMax;
		}
		clear();
		lineStyle(1, color);
		moveTo(prevXMin, prevYMin, prevZMin);
		lineTo(prevXMax, prevYMin, prevZMin);
		lineTo(prevXMax, prevYMax, prevZMin);
		lineTo(prevXMin, prevYMax, prevZMin);
		lineTo(prevXMin, prevYMin, prevZMin);
		lineTo(prevXMin, prevYMin, prevZMax);
		lineTo(prevXMax, prevYMin, prevZMax);
		lineTo(prevXMax, prevYMax, prevZMax);
		lineTo(prevXMin, prevYMax, prevZMax);
		lineTo(prevXMin, prevYMin, prevZMax);

		moveTo(prevXMax, prevYMin, prevZMin);
		lineTo(prevXMax, prevYMin, prevZMax);
		moveTo(prevXMin, prevYMax, prevZMin);
		lineTo(prevXMin, prevYMax, prevZMax);
		moveTo(prevXMax, prevYMax, prevZMin);
		lineTo(prevXMax, prevYMax, prevZMax);

		super.sync(ctx);
	}

}