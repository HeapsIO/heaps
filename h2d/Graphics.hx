package h2d;
import hxd.Math;

private typedef GraphicsPoint = hxd.poly2tri.Point;

private class GPoint {
	public var x : Float;
	public var y : Float;
	public var r : Float;
	public var g : Float;
	public var b : Float;
	public var a : Float;
	public function new(x, y, r, g, b, a) {
		this.x = x;
		this.y = y;
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}
}

private class GraphicsContent extends h3d.prim.Primitive {

	var tmp : hxd.FloatBuffer;
	var index : hxd.IndexBuffer;

	var buffers : Array<{ buf : hxd.FloatBuffer, vbuf : h3d.Buffer, idx : hxd.IndexBuffer, ibuf : h3d.Indexes }>;

	public function new() {
		buffers = [];
	}

	public inline function addIndex(i) {
		index.push(i);
	}

	public inline function add( x : Float, y : Float, u : Float, v : Float, r : Float, g : Float, b : Float, a : Float ) {
		tmp.push(x);
		tmp.push(y);
		tmp.push(u);
		tmp.push(v);
		tmp.push(r);
		tmp.push(g);
		tmp.push(b);
		tmp.push(a);
	}

	public function next() {
		var nvect = tmp.length >> 3;
		if( nvect < 1 << 15 )
			return false;
		buffers.push( { buf : tmp, idx : index, vbuf : null, ibuf : null } );
		tmp = new hxd.FloatBuffer();
		index = new hxd.IndexBuffer();
		super.dispose();
		return true;
	}

	override function alloc( engine : h3d.Engine ) {
		if (index.length <= 0) return ;
		buffer = h3d.Buffer.ofFloats(tmp, 8, [RawFormat]);
		indexes = h3d.Indexes.alloc(index);
		for( b in buffers ) {
			if( b.vbuf == null || b.vbuf.isDisposed() ) b.vbuf = h3d.Buffer.ofFloats(b.buf, 8, [RawFormat]);
			if( b.ibuf == null || b.ibuf.isDisposed() ) b.ibuf = h3d.Indexes.alloc(b.idx);
		}
	}

	override function render( engine : h3d.Engine ) {
		if (index.length <= 0) return ;
		if( buffer == null || buffer.isDisposed() ) alloc(engine);
		for( b in buffers )
			engine.renderIndexed(b.vbuf, b.ibuf);
		super.render(engine);
	}

	override function dispose() {
		for( b in buffers ) {
			if( b.vbuf != null ) b.vbuf.dispose();
			if( b.ibuf != null ) b.ibuf.dispose();
			b.vbuf = null;
			b.ibuf = null;
		}
		super.dispose();
	}


	public function clear() {
		dispose();
		tmp = new hxd.FloatBuffer();
		index = new hxd.IndexBuffer();
		buffers = [];
	}

}

class Graphics extends Drawable {

	var content : GraphicsContent;
	var tmpPoints : Array<GPoint>;
	var pindex : Int;
	var curR : Float;
	var curG : Float;
	var curB : Float;
	var curA : Float;
	var lineSize : Float;
	var lineR : Float;
	var lineG : Float;
	var lineB : Float;
	var lineA : Float;
	var doFill : Bool;

	var xMin : Float;
	var yMin : Float;
	var xMax : Float;
	var yMax : Float;

	var ma : Float = 1.;
	var mb : Float = 0.;
	var mc : Float = 0.;
	var md : Float = 1.;
	var mx : Float = 0.;
	var my : Float = 0.;

	public var tile : h2d.Tile;

	public function new(?parent) {
		super(parent);
		content = new GraphicsContent();
		tile = h2d.Tile.fromColor(0xFFFFFF);
		clear();
	}

	override function onDelete() {
		super.onDelete();
		clear();
	}

	public function clear() {
		content.clear();
		tmpPoints = [];
		pindex = 0;
		lineSize = 0;
		xMin = Math.POSITIVE_INFINITY;
		yMin = Math.POSITIVE_INFINITY;
		yMax = Math.NEGATIVE_INFINITY;
		xMax = Math.NEGATIVE_INFINITY;
	}

	override function getBoundsRec( relativeTo, out ) {
		super.getBoundsRec(relativeTo, out);
		if( tile != null ) addBounds(relativeTo, out, xMin, yMin, xMax - xMin, yMax - yMin);
	}

	function isConvex( points : Array<GPoint> ) {
		var first = true, sign = false;
		for( i in 0...points.length ) {
			var p1 = points[i];
			var p2 = points[(i + 1) % points.length];
			var p3 = points[(i + 2) % points.length];
			var s = (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x) > 0;
			if( first ) {
				first = false;
				sign = s;
			} else if( sign != s )
				return false;
		}
		return true;
	}

	function flushLine( start ) {
		var pts = tmpPoints;
		var last = pts.length - 1;
		var prev = pts[last];
		var p = pts[0];

		var closed = p.x == prev.x && p.y == prev.y;
		var count = pts.length;
		if( !closed ) {
			var prevLast = pts[last - 1];
			if( prevLast == null ) prevLast = p;
			pts.push(new GPoint(prev.x * 2 - prevLast.x, prev.y * 2 - prevLast.y, 0, 0, 0, 0));
			var pNext = pts[1];
			if( pNext == null ) pNext = p;
			prev = new GPoint(p.x * 2 - pNext.x, p.y * 2 - pNext.y, 0, 0, 0, 0);
		} else if( p != prev ) {
			count--;
			last--;
			prev = pts[last];
		}

		for( i in 0...count ) {
			var next = pts[(i + 1) % pts.length];

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
			if( size < 0.1 ) size = 0.1;	//TODO : biseauter les angles quand size très faible
			var d = lineSize * 0.5 / size;
			nx *= d;
			ny *= d;

			content.add(p.x + nx, p.y + ny, 0, 0, p.r, p.g, p.b, p.a);
			content.add(p.x - nx, p.y - ny, 0, 0, p.r, p.g, p.b, p.a);

			var pnext = i == last ? start : pindex + 2;

			if( i < count-1 || closed ) {
				content.addIndex(pindex);
				content.addIndex(pindex + 1);
				content.addIndex(pnext);

				content.addIndex(pindex + 1);
				content.addIndex(pnext);
				content.addIndex(pnext + 1);
			}

			pindex += 2;

			prev = p;
			p = next;
		}
	}

	static var EARCUT = null;

	function flushFill( i0 ) {

		if( tmpPoints.length < 3 )
			return;

		var pts = tmpPoints;
		var p0 = pts[0];
		var p1 = pts[pts.length - 1];
		var last = null;
		// closed poly
		if( hxd.Math.abs(p0.x - p1.x) < 1e-9 && hxd.Math.abs(p0.y - p1.y) < 1e-9 )
			last = pts.pop();

		if( isConvex(pts) ) {
			for( i in 1...pts.length - 1 ) {
				content.addIndex(i0);
				content.addIndex(i0 + i);
				content.addIndex(i0 + i + 1);
			}
		} else {
			var ear = EARCUT;
			if( ear == null )
				EARCUT = ear = new hxd.earcut.Earcut();
			for( i in ear.triangulate(pts) )
				content.addIndex(i + i0);
		}

		if( last != null )
			pts.push(last);
	}

	public function flush() {
		if( tmpPoints.length == 0 )
			return;
		if( doFill ) {
			flushFill(pindex);
			pindex += tmpPoints.length;
			if( content.next() )
				pindex = 0;
		}
		if( lineSize > 0 ) {
			flushLine(pindex);
			if( content.next() )
				pindex = 0;
		}
		tmpPoints = [];
	}

	public function beginFill( color : Int = 0, alpha = 1.  ) {
		flush();
		setColor(color,alpha);
		doFill = true;
	}

	public function beginTileFill( ?dx : Float, ?dy : Float, ?scaleX : Float, ?scaleY : Float, ?tile : h2d.Tile ) {
		beginFill(0xFFFFFF);
		if( dx == null ) dx = 0;
		if( dy == null ) dy = 0;
		if( tile != null ) {
			if( this.tile != null && tile.getTexture() != this.tile.getTexture() ) {
				var tex = this.tile.getTexture();
				if( tex.width != 1 || tex.height != 1 )
					throw "All tiles must be of the same texture";
			}
			this.tile = tile;
		} else
			tile = this.tile;
		if( tile == null )
			throw "Tile not specified";
		if( scaleX == null ) scaleX = 1;
		if( scaleY == null ) scaleY = 1;

		var tex = tile.getTexture();
		var pixWidth = 1 / tex.width;
		var pixHeight = 1 / tex.height;
		ma = pixWidth / scaleX;
		mb = 0;
		mc = 0;
		md = pixHeight / scaleY;
		mx = -dx * ma;
		my = -dy * md;
	}

	public function lineStyle( size : Float = 0, color = 0, alpha = 1. ) {
		flush();
		this.lineSize = size;
		lineA = alpha;
		lineR = ((color >> 16) & 0xFF) / 255.;
		lineG = ((color >> 8) & 0xFF) / 255.;
		lineB = (color & 0xFF) / 255.;
	}

	public inline function moveTo(x,y) {
		flush();
		addPoint(x, y);
	}

	public inline function lineTo(x, y) {
		addPoint(x, y);
	}

	public function endFill() {
		flush();
		doFill = false;
	}

	public inline function setColor( color : Int, alpha : Float = 1. ) {
		curA = alpha;
		curR = ((color >> 16) & 0xFF) / 255.;
		curG = ((color >> 8) & 0xFF) / 255.;
		curB = (color & 0xFF) / 255.;
	}

	public function drawRect( x : Float, y : Float, w : Float, h : Float ) {
		flush();
		addPoint(x, y);
		addPoint(x + w, y);
		addPoint(x + w, y + h);
		addPoint(x, y + h);
		flush();
	}

	public function drawCircle( cx : Float, cy : Float, ray : Float, nsegments = 0 ) {
		flush();
		if( nsegments == 0 )
			nsegments = Math.ceil(ray * 3.14 * 2 / 4);
		if( nsegments < 3 ) nsegments = 3;
		var angle = Math.PI * 2 / nsegments;
		for( i in 0...nsegments + 1 ) {
			var a = i * angle;
			addPoint(cx + Math.cos(a) * ray, cy + Math.sin(a) * ray);
		}
		flush();
	}

	public function drawPie( cx : Float, cy : Float, ray : Float, angleStart:Float, angleLength:Float, nsegments = 0 ) {
		flush();
		addPoint(cx, cy);
		if( nsegments == 0 )
			nsegments = Math.ceil(ray * angleLength / 4);
		if( nsegments < 3 ) nsegments = 3;
		var angle = angleLength / (nsegments - 1);
		for( i in 0...nsegments ) {
			var a = i * angle + angleStart;
			addPoint(cx + Math.cos(a) * ray, cy + Math.sin(a) * ray);
		}
		addPoint(cx, cy);
		flush();
	}

	public inline function addPoint( x : Float, y : Float ) {
		addPointFull(x, y, curR, curG, curB, curA, x * ma + y * mc + mx, x * mb + y * md + my);
	}

	public function addPointFull( x : Float, y : Float, r : Float, g : Float, b : Float, a : Float, u : Float = 0., v : Float = 0. ) {
		if( x < xMin ) xMin = x;
		if( y < yMin ) yMin = y;
		if( x > xMax ) xMax = x;
		if( y > yMax ) yMax = y;
		if( doFill )
			content.add(x, y, u, v, r, g, b, a);
		tmpPoints.push(new GPoint(x, y, lineR, lineG, lineB, lineA));
	}

	override function draw(ctx:RenderContext) {
		flush();
		ctx.beginDrawObject(this, tile.getTexture());
		content.render(ctx.engine);
	}

}
