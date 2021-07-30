package h3d.scene;
import hxd.Math;

private class GPoint {
	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var r : Float;
	public var g : Float;
	public var b : Float;
	public var a : Float;
	public function new(x, y, z, r, g, b, a) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}
}

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
	var lineShader : h3d.shader.LineShader;
	var tmpPoints : Array<GPoint>;

	/**
		Setting is3D to true will switch from a screen space line (constant size whatever the distance) to a world space line
	**/
	public var is3D(default, set) : Bool;

	public function new(?parent) {
		bprim = new h3d.prim.BigPrimitive(12);
		bprim.isStatic = false;
		super(bprim, null, parent);
		tmpPoints = [];
		lineShader = new h3d.shader.LineShader();
		lineShader.setPriority(-100);
		material.shadows = false;
		material.mainPass.enableLights = false;
		material.mainPass.addShader(lineShader);
		var vcolor = new h3d.shader.VertexColorAlpha();
		vcolor.setPriority(-100);
		material.mainPass.addShader(vcolor);
		material.mainPass.culling = None;
	}

	override function getBoundsRec(b:h3d.col.Bounds):h3d.col.Bounds {
		return super.getBoundsRec(b);
	}

	override function onRemove() {
		super.onRemove();
		bprim.clear();
	}

	function set_is3D(v) {
		if( is3D == v )
			return v;
		if( v ) {
			material.mainPass.removeShader(lineShader);
		} else {
			material.mainPass.addShader(lineShader);
		}
		bprim.clear();
		tmpPoints = [];
		return is3D = v;
	}

	function flushLine() {
		var pts = tmpPoints;

		var last = pts.length - 1;
		var prev = pts[last];
		var p = pts[0];

		var closed = p.x == prev.x && p.y == prev.y && p.z == prev.z;
		var count = pts.length;
		if( !closed ) {
			var prevLast = pts[last - 1];
			if( prevLast == null ) prevLast = p;
			pts.push(new GPoint(prev.x * 2 - prevLast.x, prev.y * 2 - prevLast.y, prev.z * 2 - prevLast.z, 0, 0, 0, 0));
			var pNext = pts[1];
			if( pNext == null ) pNext = p;
			prev = new GPoint(p.x * 2 - pNext.x, p.y * 2 - pNext.y, p.z * 2 - pNext.z, 0, 0, 0, 0);
		} else if( p != prev ) {
			count--;
			last--;
			prev = pts[last];
		}

		var start = bprim.vertexCount();
		var pindex = start;
		var v = 0.;
		for( i in 0...count ) {
			var next = pts[(i + 1) % pts.length];

			// ATM we only tesselate in the XY plane using a Z up normal !

			var nx1 = prev.y - p.y;
			var ny1 = p.x - prev.x;
			var ns1 = Math.invSqrt(nx1 * nx1 + ny1 * ny1);

			var nx2 = p.y - next.y;
			var ny2 = next.x - p.x;
			var ns2 = Math.invSqrt(nx2 * nx2 + ny2 * ny2);

			var nx = nx1 * ns1 + nx2 * ns2;
			var ny = ny1 * ns1 + ny2 * ns2;
			var ns = Math.invSqrt(nx * nx + ny * ny);

			nx *= ns;
			ny *= ns;

			var size = nx * nx1 * ns1 + ny * ny1 * ns1; // N.N1
			var d = lineSize * 0.5 / size;
			nx *= d;
			ny *= d;

			inline function add(v:Float) {
				bprim.addVertexValue(v);
			}

			var hasIndex = i < count - 1 || closed;
			bprim.begin(2, hasIndex ? 6 : 0);

			add(p.x + nx);
			add(p.y + ny);
			add(p.z);

			add(0);
			add(0);
			add(1);

			add(0);
			add(v);

			add(p.r);
			add(p.g);
			add(p.b);
			add(p.a);

			add(p.x - nx);
			add(p.y - ny);
			add(p.z);

			add(0);
			add(0);
			add(1);

			add(1);
			add(v);

			add(p.r);
			add(p.g);
			add(p.b);
			add(p.a);

			v = 1 - v;

			if( hasIndex ) {
				var pnext = i == last ? start - pindex : 2;
				bprim.addIndex(0);
				bprim.addIndex(1);
				bprim.addIndex(pnext);

				bprim.addIndex(pnext);
				bprim.addIndex(1);
				bprim.addIndex(pnext + 1);
			}

			pindex += 2;

			prev = p;
			p = next;
		}
	}

	function flush() {
		if( tmpPoints.length == 0 )
			return;
		if( is3D ) {
			flushLine();
			tmpPoints = [];
		}
	}

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
		flush();
		bprim.flush();
	}

	override function draw( ctx : RenderContext ) {
		flush();
		bprim.flush();
		super.draw(ctx);
	}

	public function clear() {
		flush();
		bprim.clear();
	}

	public function lineStyle( size = 0., color = 0, alpha = 1. ) {
		flush();
		if( size > 0 && lineSize != size ) {
			lineSize = size;
			if( !is3D ) lineShader.width = lineSize;
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
		if( is3D ) {
			flush();
			lineTo(x, y, z);
		} else {
			curX = x;
			curY = y;
			curZ = z;
		}
	}

	inline function addVertex( x, y, z, r, g, b, a ) {
		tmpPoints.push(new GPoint(x, y, z, r, g, b, a));
	}

	public function lineTo( x : Float, y : Float, z : Float ) {
		if( is3D ) {
			bprim.addBounds(curX, curY, curZ);
			bprim.addBounds(x, y, z);
			addVertex(x, y, z, curR, curG, curB, curA);
			return;
		}

		bprim.begin(4,6);
		var nx = x - curX;
		var ny = y - curY;
		var nz = z - curZ;

		bprim.addBounds(curX, curY, curZ);
		bprim.addBounds(x, y, z);

		inline function push(v) {
			bprim.addVertexValue(v);
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

		bprim.addIndex(0);
		bprim.addIndex(1);
		bprim.addIndex(2);
		bprim.addIndex(2);
		bprim.addIndex(3);
		bprim.addIndex(1);

		curX = x;
		curY = y;
		curZ = z;
	}

}