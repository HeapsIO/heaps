package h2d;

private typedef GraphicsPoint = hxd.poly2tri.Point;

private class LinePoint {
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
	
	public function new() {
		reset();
	}

	override public function triCount() {
		if( indexes == null )
			return Std.int(index.length / 3);
		return Std.int(indexes.count / 3);
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
	
	override function alloc( engine : h3d.Engine ) {
		if( tmp == null ) reset();
		buffer = engine.mem.allocVector(tmp, 8, 4);
		indexes = engine.mem.allocIndex(index);
	}
	
	public function reset() {
		tmp = new hxd.FloatBuffer();
		index = new hxd.IndexBuffer();
		if( buffer != null ) {
			buffer.dispose();
			indexes.dispose();
		}
		buffer = null;
		indexes = null;
	}
	
}

class Graphics extends Drawable {

	var content : GraphicsContent;
	var pts : Array<GraphicsPoint>;
	var linePts : Array<LinePoint>;
	var pindex : Int;
	var prev : Array<Array<GraphicsPoint>>;
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
	
	public var tile : h2d.Tile;
	
	public function new(?parent) {
		super(parent);
		content = new GraphicsContent();
		shader.hasVertexColor = true;
		tile = h2d.Tile.fromColor(0xFFFFFFFF);
		clear();
	}
	
	public function clear() {
		content.reset();
		pts = [];
		prev = [];
		linePts = [];
		pindex = 0;
		lineSize = 0;
	}

	function isConvex( points : Array<GraphicsPoint> ) {
		for( i in 0...points.length ) {
			var p1 = points[i];
			var p2 = points[(i + 1) % points.length];
			var p3 = points[(i + 2) % points.length];
			if( (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x) > 0 )
				return false;
		}
		return true;
	}
	
	function flushLine() {
		if( linePts.length == 0 )
			return;
		var last = linePts.length - 1;
		var prev = linePts[last];
		var p = linePts[0];
		var start = pindex;
		for( i in 0...linePts.length ) {
			var next = linePts[(i + 1) % linePts.length];
			var nx1 = prev.y - p.y;
			var ny1 = p.x - prev.x;
			var ns1 = h3d.FMath.isqrt(nx1 * nx1 + ny1 * ny1);
			var nx2 = p.y - next.y;
			var ny2 = next.x - p.x;
			var ns2 = h3d.FMath.isqrt(nx2 * nx2 + ny2 * ny2);
			
			var nx = (nx1 * ns1 + nx2 * ns2) * lineSize * 0.5;
			var ny = (ny1 * ns1 + ny2 * ns2) * lineSize * 0.5;
			
			content.add(p.x + nx, p.y + ny, 0, 0, p.r, p.g, p.b, p.a);
			content.add(p.x - nx, p.y - ny, 0, 0, p.r, p.g, p.b, p.a);
			
			var pnext = i == last ? start : pindex + 2;
			
			content.addIndex(pindex);
			content.addIndex(pindex + 1);
			content.addIndex(pnext);

			content.addIndex(pindex + 1);
			content.addIndex(pnext);
			content.addIndex(pnext + 1);
			
			pindex += 2;
			
			prev = p;
			p = next;
		}
		linePts = [];
		content.dispose();
	}
	
	function flushFill() {
		if( pts.length > 0 ) {
			prev.push(pts);
			pts = [];
		}
		if( prev.length == 0 )
			return;
			
		if( prev.length == 1 && isConvex(prev[0]) ) {
			var p0 = prev[0][0].id;
			for( i in 1...prev[0].length - 1 ) {
				content.addIndex(p0);
				content.addIndex(p0 + i);
				content.addIndex(p0 + i + 1);
			}
		} else {
			var ctx = new hxd.poly2tri.SweepContext();
			for( p in prev )
				ctx.addPolyline(p);
				
			var p = new hxd.poly2tri.Sweep(ctx);
			p.triangulate();
			
			for( t in ctx.triangles )
				for( p in t.points )
					content.addIndex(p.id);
		}
				
		prev = [];
		content.dispose();
	}
	
	function flush() {
		flushFill();
		flushLine();
	}
	
	public function beginFill( color : Int = 0, alpha = 1.  ) {
		flush();
		setColor(color,alpha);
		doFill = true;
	}
	
	public function lineStyle( size : Float = 0, color = 0, alpha = 1. ) {
		flush();
		this.lineSize = size;
		lineA = alpha;
		lineR = ((color >> 16) & 0xFF) / 255.;
		lineG = ((color >> 8) & 0xFF) / 255.;
		lineB = (color & 0xFF) / 255.;
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
		addPoint(x, y);
		addPoint(x + w, y);
		addPoint(x + w, y + h);
		addPoint(x, y + h);
	}
	
	public function drawCircle( cx : Float, cy : Float, ray : Float, nsegments = 0 ) {
		if( nsegments == 0 )
			nsegments = Math.ceil(ray * 3.14 * 2 / 4);
		if( nsegments < 3 ) nsegments = 3;
		var angle = Math.PI * 2 / (nsegments + 1);
		for( i in 0...nsegments ) {
			var a = i * angle;
			addPoint(cx + Math.cos(a) * ray, cy + Math.sin(a) * ray);
		}
	}
	
	public function addHole() {
		if( pts.length > 0 ) {
			prev.push(pts);
			pts = [];
		}
	}
	
	public inline function addPoint( x : Float, y : Float ) {
		addPointFull(x, y, curR, curG, curB, curA);
	}

	public function addPointFull( x : Float, y : Float, r : Float, g : Float, b : Float, a : Float, u : Float = 0., v : Float = 0. ) {
		if( doFill ) {
			var p = new GraphicsPoint(x, y);
			p.id = pindex++;
			pts.push(p);
			content.add(x, y, u, v, r, g, b, a);
		}
		if( lineSize > 0 )
			linePts.push(new LinePoint(x, y, lineR, lineG, lineB, lineA));
	}
	
	override function draw(ctx:RenderContext) {
		flush();
		setupShader(ctx.engine, tile, 0);
		content.render(ctx.engine);
	}

}
