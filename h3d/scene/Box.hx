package h3d.scene;

class Box extends Graphics {
	
	public var color : Int;
	
	public function new( ?color = 0xFFFF0000, ?depth = true, ?parent) {
		super(parent);
		this.color = color;
		if( !depth ) material.mainPass.depth(true,Always);
	}
	
	override function sync( ctx : RenderContext ) {
		super.sync(ctx);
		
		var dx = new h3d.col.Point(absPos._11, absPos._12, absPos._13);
		var dy = new h3d.col.Point(absPos._21, absPos._22, absPos._23);
		var dz = new h3d.col.Point(absPos._31, absPos._32, absPos._33);
		
		var p = absPos.pos().toPoint();
		
		p.x -= (dx.x + dy.x + dz.x) * 0.5;
		p.y -= (dx.y + dy.y + dz.y) * 0.5;
		p.z -= (dx.z + dy.z + dz.z) * 0.5;
		
		clear();
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
	
	
}