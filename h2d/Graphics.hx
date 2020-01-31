package h2d;
import hxd.Math;

private typedef GraphicsPoint = hxd.poly2tri.Point;

class GPoint {
	public var x : Float;
	public var y : Float;
	public var r : Float;
	public var g : Float;
	public var b : Float;
	public var a : Float;

	public function new() {
	}

	public function load(x, y, r, g, b, a ){
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
	var bufferDirty : Bool;
	var indexDirty : Bool;
	var allocPos : h3d.impl.AllocPos;

	public function new(allocPos) {
		buffers = [];
		this.allocPos = allocPos;
	}

	public inline function addIndex(i) {
		index.push(i);
		indexDirty = true;
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
		bufferDirty = true;
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
		buffer = h3d.Buffer.ofFloats(tmp, 8, [RawFormat], allocPos);
		indexes = h3d.Indexes.alloc(index);
		for( b in buffers ) {
			if( b.vbuf == null || b.vbuf.isDisposed() ) b.vbuf = h3d.Buffer.ofFloats(b.buf, 8, [RawFormat]);
			if( b.ibuf == null || b.ibuf.isDisposed() ) b.ibuf = h3d.Indexes.alloc(b.idx);
		}
		bufferDirty = false;
		indexDirty = false;
	}

	override function render( engine : h3d.Engine ) {
		if (index.length <= 0) return ;
		flush();
		for( b in buffers )
			engine.renderIndexed(b.vbuf, b.ibuf);
		super.render(engine);
	}

	public inline function flush() {
		if( buffer == null || buffer.isDisposed() ) {
			alloc(h3d.Engine.getCurrent());
		} else {
			if ( bufferDirty ) {
				buffer.dispose();
				buffer = h3d.Buffer.ofFloats(tmp, 8, [RawFormat]);
				bufferDirty = false;
			}
			if ( indexDirty ) {
				indexes.dispose();
				indexes = h3d.Indexes.alloc(index);
				indexDirty = false;
			}
		}
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
	public var bevel = 0.25; //0 = not beveled, 1 = always beveled

	public function new(?parent,?allocPos:h3d.impl.AllocPos) {
		super(parent);
		content = new GraphicsContent(allocPos);
		tile = h2d.Tile.fromColor(0xFFFFFF);
		clear();
	}

	override function onRemove() {
		super.onRemove();
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

	override function getBoundsRec( relativeTo, out, forSize ) {
		super.getBoundsRec(relativeTo, out, forSize);
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
			var gp = new GPoint();
			gp.load(prev.x * 2 - prevLast.x, prev.y * 2 - prevLast.y, 0, 0, 0, 0);
			pts.push(gp);
			var pNext = pts[1];
			if( pNext == null ) pNext = p;
			var gp = new GPoint();
			gp.load(p.x * 2 - pNext.x, p.y * 2 - pNext.y, 0, 0, 0, 0);
			prev = gp;
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


			// *HACK* we should instead properly detect limits when the angle is too small
			if(size < 0.1) size = 0.1;


			var d = lineSize * 0.5 / size;
			nx *= d;
			ny *= d;

			if(size > bevel) {
				content.add(p.x + nx, p.y + ny, 0, 0, p.r, p.g, p.b, p.a);
				content.add(p.x - nx, p.y - ny, 0, 0, p.r, p.g, p.b, p.a);

				var pnext = i == last ? start : pindex + 2;

				if( i < count - 1 || closed ) {
					content.addIndex(pindex);
					content.addIndex(pindex + 1);
					content.addIndex(pnext);

					content.addIndex(pindex + 1);
					content.addIndex(pnext);
					content.addIndex(pnext + 1);
				}
				pindex += 2;
			}
			else {
				//bevel
				var n0x = next.x - p.x;
				var n0y = next.y - p.y;
				var sign = n0x * nx + n0y * ny;

				var nnx = -ny;
				var nny = nx;

				var size = nnx * nx1 * ns1 + nny * ny1 * ns1;
				var d = lineSize * 0.5 / size;
				nnx *= d;
				nny *= d;

				var pnext = i == last ? start : pindex + 3;

				if(sign > 0) {
					content.add(p.x + nx, p.y + ny, 0, 0, p.r, p.g, p.b, p.a);
					content.add(p.x - nnx, p.y - nny, 0, 0, p.r, p.g, p.b, p.a);
					content.add(p.x + nnx, p.y + nny, 0, 0, p.r, p.g, p.b, p.a);

					content.addIndex(pindex);
					content.addIndex(pnext);
					content.addIndex(pindex + 2);

					content.addIndex(pindex + 2);
					content.addIndex(pnext);
					content.addIndex(pnext + 1);
				}
				else {
					content.add(p.x + nnx, p.y + nny, 0, 0, p.r, p.g, p.b, p.a);
					content.add(p.x - nx, p.y - ny, 0, 0, p.r, p.g, p.b, p.a);
					content.add(p.x - nnx, p.y - nny, 0, 0, p.r, p.g, p.b, p.a);

					content.addIndex(pindex + 1);
					content.addIndex(pnext);
					content.addIndex(pindex + 2);

					content.addIndex(pindex + 1);
					content.addIndex(pnext);
					content.addIndex(pnext + 1);
				}

				content.addIndex(pindex);
				content.addIndex(pindex + 1);
				content.addIndex(pindex + 2);

				pindex += 3;
			}

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

	function flush() {
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

	/**
		Position a virtual tile at the given position and scale. Every draw will display a part of this tile relative
		to these coordinates.
	**/
	public function beginTileFill( ?dx : Float, ?dy : Float, ?scaleX : Float, ?scaleY : Float, ?tile : h2d.Tile ) {
		beginFill(0xFFFFFF);
		if( dx == null ) dx = 0;
		if( dy == null ) dy = 0;
		if( tile != null ) {
			if( this.tile != null && tile.getTexture() != this.tile.getTexture() ) {
				var tex = this.tile.getTexture();
				if( tex.width != 1 || tex.height != 1 )
					throw "All tiles must be of the same texture";
				this.tile = tile;
			}
			if( this.tile == null  )
				this.tile = tile;
		} else
			tile = this.tile;
		if( tile == null )
			throw "Tile not specified";
		if( scaleX == null ) scaleX = 1;
		if( scaleY == null ) scaleY = 1;
		dx -= tile.x;
		dy -= tile.y;

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

	public function drawTile( x : Float, y : Float, tile : h2d.Tile ) {
		beginTileFill(x, y, tile);
		drawRect(x, y, tile.width, tile.height);
		endFill();
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
		lineTo(x, y);
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
		lineTo(x, y);
		lineTo(x + w, y);
		lineTo(x + w, y + h);
		lineTo(x, y + h);
		lineTo(x, y);
		flush();
	}

	public function drawRoundedRect( x : Float, y : Float, w : Float, h : Float, radius : Float, nsegments = 0 ) {
		if (radius <= 0) {
			return drawRect(x, y, w, h);
		}
		x += radius;
		y += radius;
		w -= radius * 2;
		h -= radius * 2;
		flush();
		if( nsegments == 0 )
			nsegments = Math.ceil(Math.abs(radius * hxd.Math.degToRad(90) / 4));
		if( nsegments < 3 ) nsegments = 3;
		var angle = hxd.Math.degToRad(90) / (nsegments - 1);
		inline function corner(x, y, angleStart) {
		for ( i in 0...nsegments) {
			var a = i * angle + hxd.Math.degToRad(angleStart);
			lineTo(x + Math.cos(a) * radius, y + Math.sin(a) * radius);
		}
		}
		lineTo(x, y - radius);
		lineTo(x + w, y - radius);
		corner(x + w, y, 270);
		lineTo(x + w + radius, y + h);
		corner(x + w, y + h, 0);
		lineTo(x, y + h + radius);
		corner(x, y + h, 90);
		lineTo(x - radius, y);
		corner(x, y, 180);
		flush();
	}

	public function drawCircle( cx : Float, cy : Float, radius : Float, nsegments = 0 ) {
		flush();
		if( nsegments == 0 )
			nsegments = Math.ceil(Math.abs(radius * 3.14 * 2 / 4));
		if( nsegments < 3 ) nsegments = 3;
		var angle = Math.PI * 2 / nsegments;
		for( i in 0...nsegments + 1 ) {
			var a = i * angle;
			lineTo(cx + Math.cos(a) * radius, cy + Math.sin(a) * radius);
		}
		flush();
	}

	public function drawEllipse( cx : Float, cy : Float, radiusX : Float, radiusY : Float, rotationAngle : Float = 0, nsegments = 0 ) {
		flush();
		if( nsegments == 0 )
			nsegments = Math.ceil(Math.abs(radiusY * 3.14 * 2 / 4));
		if( nsegments < 3 ) nsegments = 3;
		var angle = Math.PI * 2 / nsegments;
		var x1, y1;
		for( i in 0...nsegments + 1 ) {
			var a = i * angle;
			x1 = Math.cos(a) * Math.cos(rotationAngle) * radiusX - Math.sin(a) * Math.sin(rotationAngle) * radiusY;
			y1 = Math.cos(rotationAngle) * Math.sin(a) * radiusY + Math.cos(a) * Math.sin(rotationAngle) * radiusX;
			lineTo(cx + x1, cy + y1);
		}
		flush();
	}

	public function drawPie( cx : Float, cy : Float, radius : Float, angleStart:Float, angleLength:Float, nsegments = 0 ) {
		if(Math.abs(angleLength) >= Math.PI * 2) {
			return drawCircle(cx, cy, radius, nsegments);
		}
		flush();
		lineTo(cx, cy);
		if( nsegments == 0 )
			nsegments = Math.ceil(Math.abs(radius * angleLength / 4));
		if( nsegments < 3 ) nsegments = 3;
		var angle = angleLength / (nsegments - 1);
		for( i in 0...nsegments ) {
			var a = i * angle + angleStart;
			lineTo(cx + Math.cos(a) * radius, cy + Math.sin(a) * radius);
		}
		lineTo(cx, cy);
		flush();
	}
	
	public function drawRectanglePie( cx : Float, cy : Float, width : Float, height : Float, angleStart:Float, angleLength:Float, nsegments = 0 ) {
		if(Math.abs(angleLength) >= Math.PI*2) {
			return drawRect(cx-(width/2), cy-(height/2), width, height);
		}
		flush();
		lineTo(cx, cy);
		if( nsegments == 0 )
			nsegments = Math.ceil(Math.abs(Math.max(width, height) * angleLength / 4));
		if( nsegments < 3 ) nsegments = 3;
		var angle = angleLength / (nsegments - 1);
		var square2 = Math.sqrt(2);
		for( i in 0...nsegments ) {
			var a = i * angle + angleStart;

			var _width = Math.cos(a) * (width/2+1) * square2;
			var _height = Math.sin(a) * (height/2+1) * square2;

			_width = Math.abs(_width) >= width/2 ? (Math.cos(a) < 0 ? width/2*-1 : width/2) : _width;
			_height = Math.abs(_height) >= height/2 ? (Math.sin(a) < 0 ? height/2*-1 : height/2) : _height;

			lineTo(cx + _width, cy + _height);
		}
		lineTo(cx, cy);
		flush();
	}

	/**
	 * Draws a quadratic Bezier curve using the current line style from the current drawing position to (cx, cy) and using the control point that (bx, by) specifies.
	 * IvanK Lib port ( http://lib.ivank.net )
	 */
	public function curveTo( bx : Float, by : Float, cx : Float, cy : Float) {
		var ax = tmpPoints.length == 0 ? 0 :tmpPoints[ tmpPoints.length - 1 ].x;
		var ay = tmpPoints.length == 0 ? 0 :tmpPoints[ tmpPoints.length - 1 ].y;
		var t = 2 / 3;
		cubicCurveTo(ax + t * (bx - ax), ay + t * (by - ay), cx + t * (bx - cx), cy + t * (by - cy), cx, cy);
	}

	/**
	 * Draws a cubic Bezier curve from the current drawing position to the specified anchor point.
	 * IvanK Lib port ( http://lib.ivank.net )
	 * @param bx control X for start point
	 * @param by control Y for start point
	 * @param cx control X for end point
	 * @param cy control Y for end point
	 * @param dx end X
	 * @param dy end Y
	 * @param nsegments = 40 
	 */
	public function cubicCurveTo( bx : Float, by : Float, cx : Float, cy : Float, dx : Float, dy : Float, nsegments = 40) {
		var ax = tmpPoints.length == 0 ? 0 : tmpPoints[tmpPoints.length - 1].x;
		var ay = tmpPoints.length == 0 ? 0 : tmpPoints[tmpPoints.length - 1].y;
		var tobx = bx - ax, toby = by - ay;
		var tocx = cx - bx, tocy = cy - by;
		var todx = dx - cx, tody = dy - cy;
		var step = 1 / nsegments;

		for (i in 1...nsegments) {
			var d = i * step;
			var px = ax + d * tobx, py = ay + d * toby;
			var qx = bx + d * tocx, qy = by + d * tocy;
			var rx = cx + d * todx, ry = cy + d * tody;
			var toqx = qx - px, toqy = qy - py;
			var torx = rx - qx, tory = ry - qy;

			var sx = px + d * toqx, sy = py + d * toqy;
			var tx = qx + d * torx, ty = qy + d * tory;
			var totx = tx - sx, toty = ty - sy;
			lineTo(sx + d * totx, sy + d * toty);
		}
		lineTo(dx, dy);
	}

	public inline function lineTo( x : Float, y : Float ) {
		addVertex(x, y, curR, curG, curB, curA, x * ma + y * mc + mx, x * mb + y * md + my);
	}

	public function addVertex( x : Float, y : Float, r : Float, g : Float, b : Float, a : Float, u : Float = 0., v : Float = 0. ) {
		if( x < xMin ) xMin = x;
		if( y < yMin ) yMin = y;
		if( x > xMax ) xMax = x;
		if( y > yMax ) yMax = y;
		if( doFill )
			content.add(x, y, u, v, r, g, b, a);
		var gp = new GPoint();
		gp.load(x, y, lineR, lineG, lineB, lineA);
		tmpPoints.push(gp);
	}

	override function draw(ctx:RenderContext) {
		if( !ctx.beginDrawObject(this, tile.getTexture()) ) return;
		content.render(ctx.engine);
	}

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
		flush();
		content.flush();
	}
}
