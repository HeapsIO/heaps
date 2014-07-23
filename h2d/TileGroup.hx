package h2d;

private class TileLayerContent extends h3d.prim.Primitive {

	var tmp : hxd.FloatBuffer;
	public var xMin : Float;
	public var yMin : Float;
	public var xMax : Float;
	public var yMax : Float;

	public function new() {
		reset();
	}

	public function reset() {
		tmp = new hxd.FloatBuffer();
		if( buffer != null ) buffer.dispose();
		buffer = null;
		xMin = hxd.Math.POSITIVE_INFINITY;
		yMin = hxd.Math.POSITIVE_INFINITY;
		xMax = hxd.Math.NEGATIVE_INFINITY;
		yMax = hxd.Math.NEGATIVE_INFINITY;
	}

	public function isEmpty() {
		return triCount() == 0;
	}

	override public function triCount() {
		return if( buffer == null ) tmp.length >> 4 else buffer.totalVertices() >> 1;
	}

	public inline function addColor( x : Int, y : Int, color : h3d.Vector, t : Tile ) {
		add(x, y, color.r, color.g, color.b, color.a, t);
	}

	public function add( x : Int, y : Int, r : Float, g : Float, b : Float, a : Float, t : Tile ) {
		var sx = x + t.dx;
		var sy = y + t.dy;
		tmp.push(sx);
		tmp.push(sy);
		tmp.push(t.u);
		tmp.push(t.v);
		tmp.push(r);
		tmp.push(g);
		tmp.push(b);
		tmp.push(a);
		tmp.push(sx + t.width);
		tmp.push(sy);
		tmp.push(t.u2);
		tmp.push(t.v);
		tmp.push(r);
		tmp.push(g);
		tmp.push(b);
		tmp.push(a);
		tmp.push(sx);
		tmp.push(sy + t.height);
		tmp.push(t.u);
		tmp.push(t.v2);
		tmp.push(r);
		tmp.push(g);
		tmp.push(b);
		tmp.push(a);
		tmp.push(sx + t.width);
		tmp.push(sy + t.height);
		tmp.push(t.u2);
		tmp.push(t.v2);
		tmp.push(r);
		tmp.push(g);
		tmp.push(b);
		tmp.push(a);

		var x = x + t.dx, y = y + t.dy;
		if( x < xMin ) xMin = x;
		if( y < yMin ) yMin = y;
		x += t.width;
		y += t.height;
		if( x > xMax ) xMax = x;
		if( y > yMax ) yMax = y;
	}

	public function addPoint( x : Float, y : Float, color : Int ) {
		tmp.push(x);
		tmp.push(y);
		tmp.push(0);
		tmp.push(0);
		insertColor(color);
		if( x < xMin ) xMin = x;
		if( y < yMin ) yMin = y;
		if( x > xMax ) xMax = x;
		if( y > yMax ) yMax = y;
	}

	inline function insertColor( c : Int ) {
		tmp.push(((c >> 16) & 0xFF) / 255.);
		tmp.push(((c >> 8) & 0xFF) / 255.);
		tmp.push((c & 0xFF) / 255.);
		tmp.push((c >>> 24) / 255.);
	}

	public inline function rectColor( x : Float, y : Float, w : Float, h : Float, color : Int ) {
		tmp.push(x);
		tmp.push(y);
		tmp.push(0);
		tmp.push(0);
		insertColor(color);
		tmp.push(x + w);
		tmp.push(y);
		tmp.push(1);
		tmp.push(0);
		insertColor(color);
		tmp.push(x);
		tmp.push(y + h);
		tmp.push(0);
		tmp.push(1);
		insertColor(color);
		tmp.push(x + w);
		tmp.push(y + h);
		tmp.push(1);
		tmp.push(1);
		insertColor(color);

		if( x < xMin ) xMin = x;
		if( y < yMin ) yMin = y;
		x += w;
		y += h;
		if( x > xMax ) xMax = x;
		if( y > yMax ) yMax = y;
	}

	public inline function rectGradient( x : Float, y : Float, w : Float, h : Float, ctl : Int, ctr : Int, cbl : Int, cbr : Int ) {
		tmp.push(x);
		tmp.push(y);
		tmp.push(0);
		tmp.push(0);
		insertColor(ctl);
		tmp.push(x + w);
		tmp.push(y);
		tmp.push(1);
		tmp.push(0);
		insertColor(ctr);
		tmp.push(x);
		tmp.push(y + h);
		tmp.push(0);
		tmp.push(1);
		insertColor(cbl);
		tmp.push(x + w);
		tmp.push(y + h);
		tmp.push(1);
		tmp.push(0);
		insertColor(cbr);

		if( x < xMin ) xMin = x;
		if( y < yMin ) yMin = y;
		x += w;
		y += h;
		if( x > xMax ) xMax = x;
		if( y > yMax ) yMax = y;
	}

    public inline function fillArc( x : Float, y : Float, ray : Float, c : Int, start: Float, end: Float) {
        if (end <= start) return;
        var arcLength = end - start;
        var nsegments = Math.ceil(ray * 3.14 * 2 / 4);
		if ( nsegments < 4 ) nsegments = 4;
		var angle = arcLength / nsegments;
        var prevX = Math.NEGATIVE_INFINITY;
        var prevY = Math.NEGATIVE_INFINITY;
        var _x = 0.;
        var _y = 0.;
        var i = 0;
		while ( i < nsegments ) {
			var a = start + i * angle;
            _x = x + Math.cos(a) * ray;
            _y = y + Math.sin(a) * ray;
            if (prevX != Math.NEGATIVE_INFINITY) {
                addPoint(x, y, c);
                addPoint(_x, _y, c);
                addPoint(prevX, prevY, c);
                addPoint(prevX, prevY, c);
            }
            prevX = _x;
            prevY = _y;
            i += 1;
		}
        var a = end;
        _x = x + Math.cos(a) * ray;
        _y = y + Math.sin(a) * ray;
        addPoint(x, y, c);
        addPoint(_x, _y, c);
        addPoint(prevX, prevY, c);
        addPoint(prevX, prevY, c);
    }

    public inline function fillCircle( x : Float, y : Float, radius : Float, c : Int) {
        var nsegments = Math.ceil(radius * 3.14 * 2 / 2);
        if( nsegments < 3 ) nsegments = 3;
        var angle = Math.PI * 2 / nsegments;
        var prevX = Math.NEGATIVE_INFINITY;
        var prevY = Math.NEGATIVE_INFINITY;
        var firstX = Math.NEGATIVE_INFINITY;
        var firstY = Math.NEGATIVE_INFINITY;
        var curX = 0., curY = 0.;
        for( i in 0...nsegments) {
            var a = i * angle;
            curX = x + Math.cos(a) * radius;
            curY = y + Math.sin(a) * radius;
            if (prevX != Math.NEGATIVE_INFINITY) {
                addPoint(x, y, c);
                addPoint(curX, curY, c);
                addPoint(prevX, prevY, c);
                addPoint(x, y, c);
            }
            if (firstX == Math.NEGATIVE_INFINITY) {
                firstX = curX;
                firstY = curY;
            }
            prevX = curX;
            prevY = curY;
        }
        addPoint(x, y, c);
        addPoint(curX, curY, c);
        addPoint(firstX, firstY, c);
        addPoint(x, y, c);
    }

    public inline function circle( x : Float, y : Float, ray : Float, size: Float, c : Int) {
        if (size > ray) return;
        var nsegments = Math.ceil(ray * 3.14 * 2 / 2);
		if ( nsegments < 3 ) nsegments = 3;
        var ray1 = ray - size;
		var angle = Math.PI * 2 / nsegments;
        var prevX = Math.NEGATIVE_INFINITY;
        var prevY = Math.NEGATIVE_INFINITY;
        var prevX1 = Math.NEGATIVE_INFINITY;
        var prevY1 = Math.NEGATIVE_INFINITY;
		for( i in 0...nsegments ) {
			var a = i * angle;
            var _x = x + Math.cos(a) * ray;
            var _y = y + Math.sin(a) * ray;
            var _x1 = x + Math.cos(a) * ray1;
            var _y1 = y + Math.sin(a) * ray1;
            if (prevX != Math.NEGATIVE_INFINITY) {
                addPoint(_x, _y, c);
                addPoint(prevX, prevY, c);
                addPoint(_x1, _y1, c);
                addPoint(prevX1, prevY1, c);
            }
            prevX = _x;
            prevY = _y;
            prevX1 = _x1;
            prevY1 = _y1;
		}
    }

    public inline function arc( x : Float, y : Float, ray : Float, size: Float, start: Float, end: Float, c : Int) {
        if (size > ray) return;
        if (end <= start) return;
        var arcLength = end - start;
        var nsegments = Math.ceil(ray * 3.14 * 2 / 4);
		if ( nsegments < 3 ) nsegments = 3;
        var ray1 = ray - size;
		var angle = arcLength / nsegments;
        var prevX = Math.NEGATIVE_INFINITY;
        var prevY = Math.NEGATIVE_INFINITY;
        var prevX1 = Math.NEGATIVE_INFINITY;
        var prevY1 = Math.NEGATIVE_INFINITY;
        var _x = 0.;
        var _y = 0.;
        var _x1 = 0.;
        var _y1 = 0.;
		for( i in 0...nsegments ) {
			var a = start + i * angle;
            _x = x + Math.cos(a) * ray;
            _y = y + Math.sin(a) * ray;
            _x1 = x + Math.cos(a) * ray1;
            _y1 = y + Math.sin(a) * ray1;
            if (prevX != Math.NEGATIVE_INFINITY) {
                addPoint(_x, _y, c);
                addPoint(prevX, prevY, c);
                addPoint(_x1, _y1, c);
                addPoint(prevX1, prevY1, c);
            }
            prevX = _x;
            prevY = _y;
            prevX1 = _x1;
            prevY1 = _y1;
		}
        var a = end;
        _x = x + Math.cos(a) * ray;
        _y = y + Math.sin(a) * ray;
        _x1 = x + Math.cos(a) * ray1;
        _y1 = y + Math.sin(a) * ray1;
        addPoint(_x, _y, c);
        addPoint(prevX, prevY, c);
        addPoint(_x1, _y1, c);
        addPoint(prevX1, prevY1, c);
    }

	override public function alloc(engine:h3d.Engine) {
		if( tmp == null ) reset();
		buffer = h3d.Buffer.ofFloats(tmp, 8, [Quads, RawFormat]);
	}

	public function doRender(engine, min, len) {
		if( buffer == null || buffer.isDisposed() ) alloc(engine);
		engine.renderQuadBuffer(buffer, min, len);
	}

}

class TileGroup extends Drawable {

	var content : TileLayerContent;
	var curColor : h3d.Vector;

	public var tile : Tile;
	public var rangeMin : Int;
	public var rangeMax : Int;

	public function new(t,?parent) {
		super(parent);
		tile = t;
		rangeMin = rangeMax = -1;
		curColor = new h3d.Vector(1, 1, 1, 1);
		content = new TileLayerContent();
	}

	override function getBoundsRec( relativeTo, out ) {
		super.getBoundsRec(relativeTo, out);
		addBounds(relativeTo, out, content.xMin, content.yMin, content.xMax - content.xMin, content.yMax - content.yMin);
	}

	public function reset() {
		content.reset();
	}

	/**
		Returns the number of tiles added to the group
	**/
	public function count() {
		return content.triCount() >> 1;
	}

	override function onDelete() {
		content.dispose();
		super.onDelete();
	}

	public function setDefaultColor( rgb : Int, alpha = 1.0 ) {
		curColor.x = ((rgb >> 16) & 0xFF) / 255;
		curColor.y = ((rgb >> 8) & 0xFF) / 255;
		curColor.z = (rgb & 0xFF) / 255;
		curColor.w = alpha;
	}

	public inline function add(x, y, t) {
		content.add(x, y, curColor.x, curColor.y, curColor.z, curColor.w, t);
	}

	public inline function addColor(x, y, r, g, b, a, t) {
		content.add(x, y, r, g, b, a, t);
	}

	override function draw(ctx:RenderContext) {
		drawWith(ctx,this);
	}

	@:allow(h2d)
	function drawWith( ctx:RenderContext, obj : Drawable ) {
		ctx.beginDrawObject(obj, tile.getTexture());
		var min = rangeMin < 0 ? 0 : rangeMin * 2;
		var max = content.triCount();
		if( rangeMax > 0 && rangeMax < max * 2 ) max = rangeMax * 2;
		content.doRender(ctx.engine, min, max - min);
	}

}
