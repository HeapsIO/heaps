package h3d.scene;

class Graphics extends Mesh {

	var bprim : h3d.prim.BigPrimitive;
	var curX : Float = 0.;
	var curY : Float = 0.;
	var curZ : Float = 0.;
	var curR : Float = 0.;
	var curG : Float;
	var curB : Float;
	var curA : Float;
	var lineSize = 0.;

	public function new(?parent) {
		bprim = new h3d.prim.BigPrimitive(12);
		super(bprim, null, parent);
		material.mainPass.addShader(new h3d.shader.LineShader());
		material.mainPass.addShader(new h3d.shader.VertexColorAlpha());
		material.mainPass.culling = None;
	}

	override function draw( ctx : RenderContext ) {
		bprim.flush();
		super.draw(ctx);
	}

	public function clear() {
		bprim.clear();
	}

	public function lineStyle( size = 0., color = 0, alpha = 1. ) {
		if( size > 0 && lineSize != size ) {
			lineSize = size;
			material.mainPass.getShader(h3d.shader.LineShader).width = lineSize;
		}
		setColor(color, alpha);
	}

	public function setColor( color : Int, alpha = 1. ) {
		curA = alpha;
		curR = ((color >> 16) & 0xFF) / 255.;
		curG = ((color >> 8) & 0xFF) / 255.;
		curB = (color & 0xFF) / 255.;
	}

	public inline function drawLine( p1 : h3d.col.Point, p2 : h3d.col.Point ) {
		moveTo(p1.x, p1.y, p1.z);
		lineTo(p2.x, p2.y, p2.z);
	}

	public function moveTo( x : Float, y : Float, z : Float ) {
		curX = x;
		curY = y;
		curZ = z;
	}

	public function lineTo( x : Float, y : Float, z : Float ) {
		bprim.begin(4);
		var start = bprim.currentVerticesCount();
		var nx = x - curX;
		var ny = y - curY;
		var nz = z - curZ;

		bprim.addBounds(curX, curY, curZ);
		bprim.addBounds(x, y, z);

		inline function push(v) {
			bprim.addVerticeValue(v);
		}

		inline function add(u, v) {
			push(curX);
			push(curY);
			push(curZ);

			push(nx);
			push(ny);
			push(nz);

			push(u);
			push(v);

			push(curR);
			push(curG);
			push(curB);
			push(curA);
		}

		add(0, 0);
		add(0, 1);
		add(1, 0);
		add(1, 1);

		bprim.addIndex(start);
		bprim.addIndex(start + 1);
		bprim.addIndex(start + 2);
		bprim.addIndex(start + 2);
		bprim.addIndex(start + 3);
		bprim.addIndex(start + 1);

		curX = x;
		curY = y;
		curZ = z;
	}

}