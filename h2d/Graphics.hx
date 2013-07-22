package h2d;

private typedef GraphicsPoint = hxd.poly2tri.Point;

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

	public inline function add( x : Float, y : Float, u : Float, v : Float, r : Float, g : Float, b : Float, a : Float  ) {
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
	var pindex : Int;
	var prev : Array<Array<GraphicsPoint>>;
	var curR : Float;
	var curG : Float;
	var curB : Float;
	var curA : Float;
	
	public var tile : h2d.Tile;
	
	public function new(?parent) {
		super(parent);
		content = new GraphicsContent();
		shader.hasVertexColor = true;
		tile = h2d.Tile.fromColor(0xFFFFFFFF);
		pts = [];
		prev = [];
	}
	
	public function clear() {
		content.reset();
		pts = [];
		prev = [];
		pindex = 0;
	}

	function flush() {
		if( pts.length > 0 ) {
			prev.push(pts);
			pts = [];
		}
		if( prev.length == 0 )
			return;
		var ctx = new hxd.poly2tri.SweepContext();
		for( p in prev )
			ctx.addPolyline(p);
			
		var p = new hxd.poly2tri.Sweep(ctx);
		p.triangulate();
		
		for( t in ctx.triangles )
			for( p in t.points )
				content.addIndex(p.id);
				
		prev = [];
	}
	
	public function beginFill( rgba : Int = 0 ) {
		flush();
		setColor(rgba);
	}
	
	public function endFill() {
		flush();
	}
	
	public inline function setColor( rgba : Int ) {
		curA = (rgba >>> 24) / 255.;
		curR = ((rgba >> 16) & 0xFF) / 255.;
		curG = ((rgba >> 8) & 0xFF) / 255.;
		curB = (rgba & 0xFF) / 255.;
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
		var p = new GraphicsPoint(x, y);
		p.id = pindex++;
		pts.push(p);
		content.add(x, y, u, v, r, g, b, a);
	}
	
	override function draw(ctx:RenderContext) {
		flush();
		setupShader(ctx.engine, tile, 0);
		content.render(ctx.engine);
	}

}
