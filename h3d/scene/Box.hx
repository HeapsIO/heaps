package h3d.scene;

class Box extends Object {
	
	public var depth : Bool;
	public var color : Int;
	
	public function new( color = 0xFFFF0000, depth = true, ?parent) {
		super(parent);
		this.color = color;
		this.depth = depth;
	}
	
	override function draw( ctx : RenderContext ) {
		// this ugliness needs some optimization...
		
		var dx = new h3d.Vector(absPos._11, absPos._12, absPos._13);
		var dy = new h3d.Vector(absPos._21, absPos._22, absPos._23);
		var dz = new h3d.Vector(absPos._31, absPos._32, absPos._33);
		
		var p = absPos.pos();
		
		p.x -= (dx.x + dy.x + dz.x) * 0.5;
		p.y -= (dx.y + dy.y + dz.y) * 0.5;
		p.z -= (dx.z + dy.z + dz.z) * 0.5;
		
		ctx.engine.lineP(p, p.add(dx), color, depth);
		ctx.engine.lineP(p, p.add(dy), color, depth);
		ctx.engine.lineP(p, p.add(dz), color, depth);
		
		ctx.engine.lineP(p.add(dx), p.add(dx).add(dz), color, depth);
		ctx.engine.lineP(p.add(dy), p.add(dy).add(dz), color, depth);
		
		ctx.engine.lineP(p.add(dx), p.add(dx).add(dy), color, depth);
		ctx.engine.lineP(p.add(dy), p.add(dx).add(dy), color, depth);
		
		ctx.engine.lineP(p.add(dx).add(dy), p.add(dx).add(dy).add(dz), color, depth);
		
		p = p.add(dz);

		ctx.engine.lineP(p, p.add(dx), color, depth);
		ctx.engine.lineP(p, p.add(dy), color, depth);
		ctx.engine.lineP(p.add(dx), p.add(dx).add(dy), color, depth);
		ctx.engine.lineP(p.add(dy), p.add(dx).add(dy), color, depth);
		ctx.engine.lineP(p.add(dy), p.add(dx).add(dy), color, depth);
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