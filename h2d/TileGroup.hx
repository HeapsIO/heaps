package h2d;

import h2d.RenderContext;
import h2d.impl.BatchDrawState;

/**
	TileGroup internal class for batched quad geometry rendering.
**/
@:dox(hide)
class TileLayerContent extends h3d.prim.Primitive {

	var tmp : hxd.FloatBuffer;
	/**
		Content bounds left edge.
	**/
	public var xMin : Float;
	/**
		Content bounds top edge.
	**/
	public var yMin : Float;
	/**
		Content bounds right edge.
	**/
	public var xMax : Float;
	/**
		Content bounds bottom edge.
	**/
	public var yMax : Float;
	
	public var useAllocatorLimit = 1024;

	var state : BatchDrawState;

	public function new() {
		state = new BatchDrawState();
		clear();
	}

	/**
		Remove all data from Content instance.
	**/
	public function clear() {
		tmp = new hxd.FloatBuffer();
		if( buffer != null ) {
			if(buffer.vertices * 8 < useAllocatorLimit) hxd.impl.Allocator.get().disposeBuffer(buffer);
			else buffer.dispose();
		}
		buffer = null;
		xMin = hxd.Math.POSITIVE_INFINITY;
		yMin = hxd.Math.POSITIVE_INFINITY;
		xMax = hxd.Math.NEGATIVE_INFINITY;
		yMax = hxd.Math.NEGATIVE_INFINITY;
		state.clear();
	}

	public function isEmpty() {
		return triCount() == 0;
	}

	override public function triCount() {
		return if( buffer == null ) tmp.length >> 4 else buffer.totalVertices() >> 1;
	}

	/**
		Adds tinted Tile at specified position.
		@param x X position of the tile relative to drawn Object.
		@param y Y position of the tile relative to drawn Object.
		@param color An RGBA vector used for tinting.
		@param t The Tile to draw.
	**/
	public inline function addColor( x : Float, y : Float, color : h3d.Vector, t : Tile ) {
		add(x, y, color.r, color.g, color.b, color.a, t);
	}

	/**
		Adds tinted Tile at specified position.
		@param x X position of the tile relative to drawn Object.
		@param y Y position of the tile relative to drawn Object.
		@param r Red tint value (0...1 range)
		@param g Green tint value (0...1 range)
		@param b Blue tint value (0...1 range)
		@param a Alpha of the drawn Tile
		@param t The Tile to draw.
	**/
	public function add( x : Float, y : Float, r : Float, g : Float, b : Float, a : Float, t : Tile ) {
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

		state.setTile(t);
		state.add(4);
	}

	/**
		Adds tinted Tile at specified position with provided transform.
		@param x X position of the tile relative to drawn Object.
		@param y Y position of the tile relative to drawn Object.
		@param sx X-axis scaling factor of the Tile.
		@param sy Y-axis scaling factor of the Tile.
		@param r Rotation (in radians) of the Tile.
		@param c An RGBA vector used for tinting.
		@param t The Tile to draw.
	**/
	public function addTransform( x : Float, y : Float, sx : Float, sy : Float, r : Float, c : h3d.Vector, t : Tile ) {

		var ca = Math.cos(r), sa = Math.sin(r);
		var hx = t.width, hy = t.height;

		inline function updateBounds( x, y ) {
			if( x < xMin ) xMin = x;
			if( y < yMin ) yMin = y;
			if( x > xMax ) xMax = x;
			if( y > yMax ) yMax = y;
		}

		var dx = t.dx * sx, dy = t.dy * sy;
		var px = dx * ca - dy * sa + x;
		var py = dy * ca + dx * sa + y;

		tmp.push(px);
		tmp.push(py);
		tmp.push(t.u);
		tmp.push(t.v);
		tmp.push(c.r);
		tmp.push(c.g);
		tmp.push(c.b);
		tmp.push(c.a);
		updateBounds(px, py);

		var dx = (t.dx + hx) * sx, dy = t.dy * sy;
		var px = dx * ca - dy * sa + x;
		var py = dy * ca + dx * sa + y;

		tmp.push(px);
		tmp.push(py);
		tmp.push(t.u2);
		tmp.push(t.v);
		tmp.push(c.r);
		tmp.push(c.g);
		tmp.push(c.b);
		tmp.push(c.a);
		updateBounds(px, py);

		var dx = t.dx * sx, dy = (t.dy + hy) * sy;
		var px = dx * ca - dy * sa + x;
		var py = dy * ca + dx * sa + y;

		tmp.push(px);
		tmp.push(py);
		tmp.push(t.u);
		tmp.push(t.v2);
		tmp.push(c.r);
		tmp.push(c.g);
		tmp.push(c.b);
		tmp.push(c.a);
		updateBounds(px, py);

		var dx = (t.dx + hx) * sx, dy = (t.dy + hy) * sy;
		var px = dx * ca - dy * sa + x;
		var py = dy * ca + dx * sa + y;

		tmp.push(px);
		tmp.push(py);
		tmp.push(t.u2);
		tmp.push(t.v2);
		tmp.push(c.r);
		tmp.push(c.g);
		tmp.push(c.b);
		tmp.push(c.a);
		updateBounds(px, py);

		state.setTile(t);
		state.add(4);
	}

	/**
		Intended for internal usage. Adds single vertex to the buffer with no 0 uv.

		Usage warning: When adding geometry trough addPoint, they should be added in groups of 4 that form a quad,
		and then `updateState(null, quads * 2)` should be called to ensure proper batch rendering.

		Points are added in the following order: top-left, top-right, bottom-left, bottom-right.
	**/
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

	/**
		Adds simple tinted rectangle at specified position. UV covers entire bound texture.
		@param x X position of the rectangle relative to drawn Object.
		@param y Y position of the rectangle relative to drawn Object.
		@param w Width of the rectangle in pixels.
		@param h Height of the rectangle in pixels.
		@param color An ARGB color integer used for tinting.
	**/
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

		state.add(4);
	}

	/**
		Adds simple rectangular gradient at specified position. UV covers entire bound texture.
		@param x X position of the rectangle relative to drawn Object.
		@param y Y position of the rectangle relative to drawn Object.
		@param w Width of the rectangle in pixels.
		@param h Height of the rectangle in pixels.
		@param ctl Tint color of the top-left corner.
		@param ctr Tint color of the top-right corner.
		@param cbl Tint color of the bottom-left corner.
		@param cbr Tint color of the bottom-right corner.
	**/
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
		tmp.push(1);
		insertColor(cbr);

		if( x < xMin ) xMin = x;
		if( y < yMin ) yMin = y;
		x += w;
		y += h;
		if( x > xMax ) xMax = x;
		if( y > yMax ) yMax = y;

		state.add(4);
	}

	/**
		Adds a filled arc at specified position.
		@param x X position of the arc center.
		@param y Y position of the arc center.
		@param ray Radius of the arc.
		@param c ARGB color of the arc.
		@param start Starting angle (in radians) of the arc.
		@param end Ending angle (in radians) of the arc.
	**/
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
		var count = 0;
		while ( i < nsegments ) {
			var a = start + i * angle;
			_x = x + Math.cos(a) * ray;
			_y = y + Math.sin(a) * ray;
			if (prevX != Math.NEGATIVE_INFINITY) {
				addPoint(x, y, c);
				addPoint(_x, _y, c);
				addPoint(prevX, prevY, c);
				addPoint(prevX, prevY, c);
				count += 4;
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
		state.add(count + 4);
	}

	/**
		Adds a filled circle at specified position.
		@param x X position of the circle center.
		@param y Y position of the circle center.
		@param radius Radius of the circle.
		@param c ARGB color of the circle.
	**/
	public inline function fillCircle( x : Float, y : Float, radius : Float, c : Int) {
		var nsegments = Math.ceil(radius * 3.14 * 2 / 2);
		if( nsegments < 3 ) nsegments = 3;
		var angle = Math.PI * 2 / nsegments;
		var prevX = Math.NEGATIVE_INFINITY;
		var prevY = Math.NEGATIVE_INFINITY;
		var firstX = Math.NEGATIVE_INFINITY;
		var firstY = Math.NEGATIVE_INFINITY;
		var curX = 0., curY = 0.;
		var count = 0;
		for( i in 0...nsegments) {
			var a = i * angle;
			curX = x + Math.cos(a) * radius;
			curY = y + Math.sin(a) * radius;
			if (prevX != Math.NEGATIVE_INFINITY) {
				addPoint(x, y, c);
				addPoint(curX, curY, c);
				addPoint(prevX, prevY, c);
				addPoint(x, y, c);
				count += 4;
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
		state.add(count + 4);
	}

	/**
		Adds a circle at specified position.
		@param x X position of the circle center.
		@param y Y position of the circle center.
		@param ray Radius of the circle outer edge.
		@param size Radius of the circle inner edge.
		@param c ARGB color of the arc.
	**/
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
		var count = 0;
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
				count += 4;
			}
			prevX = _x;
			prevY = _y;
			prevX1 = _x1;
			prevY1 = _y1;
		}
		state.add(count);
	}

	/**
		Adds a arc at specified position.
		@param x X position of the arc center.
		@param y Y position of the arc center.
		@param ray Radius of the arc outer edge.
		@param size Radius of the arc inner edge.
		@param start Starting angle (in radians) of the arc.
		@param end Ending angle (in radians) of the arc.
		@param c ARGB color of the arc.
	**/
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
		var count = 0;
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
				count += 4;
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
		state.add(count + 4);
	}

	override public function alloc(engine:h3d.Engine) {
		if( tmp == null ) clear();
		if( tmp.length > 0 ) {
			buffer = tmp.length < useAllocatorLimit
				? hxd.impl.Allocator.get().ofFloats(tmp, 8, RawQuads)
				: h3d.Buffer.ofFloats(tmp, 8, [Quads, RawFormat]);
		}
	}

	override function dispose() {
		if( buffer != null ) {
			if(buffer.vertices * 8 < useAllocatorLimit) hxd.impl.Allocator.get().disposeBuffer(buffer);
			else buffer.dispose();
			buffer = null;
		}
		super.dispose();
	}

	/**
		Flushes added quads to the rendering buffer.
		Only flushes if rendering buffer is disposed, and to ensure new data is added, call `dispose()` first.
	**/
	public inline function flush() {
		if( buffer == null || buffer.isDisposed() ) alloc(h3d.Engine.getCurrent());
	}

	/**
		Renders the Content quads.
		@param min Initial triangle offset of buffer to draw.
		@param len Amount of triangle to draw. (`-1` to render until the end of buffer)
	**/
	public inline function doRender(ctx : RenderContext, min, len) {
		flush();
		state.drawQuads(ctx, buffer, min, len);
	}

}

/**
	A static Tile batch renderer.

	TileGroup follows an upload-once policy and does not allow modification of the already added geometry.
	To add new geometry it's mandatory to call `TileGroup.invalidate`. In case existing geometry has to be modified -
	entire group have to be cleared with `TileGroup.clear` and repopulated from ground up.

	Usage note: While TileGroup allows for multiple unique textures, each texture swap causes a new drawcall,
	and due to that it's recommended to minimize the amount of used textures per TileGroup instance,
	ideally limiting to only one texture.
**/
class TileGroup extends Drawable {

	var content : TileLayerContent;
	var curColor : h3d.Vector;

	/**
		The reference tile used as a Texture source to draw.
	**/
	public var tile : Tile;
	/**
		If set, only tiles indexed above or equal to `rangeMin` will be drawn.
	**/
	public var rangeMin : Int;
	/**
		If set, only tiles indexed below `rangeMax` will be drawn.
	**/
	public var rangeMax : Int;

	/**
		Create new TileGroup instance using Texture based on provided Tile.
		@param t The Tile which is used as a source for a Texture to be rendered.
		@param parent An optional parent `h2d.Object` instance to which TileGroup adds itself if set.
	**/
	public function new(?t : Tile, ?parent : h2d.Object) {
		super(parent);
		tile = t;
		rangeMin = rangeMax = -1;
		curColor = new h3d.Vector(1, 1, 1, 1);
		content = new TileLayerContent();
	}

	override function getBoundsRec( relativeTo : Object, out : h2d.col.Bounds, forSize : Bool ) {
		super.getBoundsRec(relativeTo, out, forSize);
		addBounds(relativeTo, out, content.xMin, content.yMin, content.xMax - content.xMin, content.yMax - content.yMin);
	}

	/**
		Clears all TileGroup contents and disposes allocated GPU memory.
	**/
	public function clear() : Void {
		content.clear();
	}

	/**
		When new data is added, it's not automatically flushed to the GPU memory if it was already allocated
		(when TileGroup is either rendered or received `Object.sync` call),
		in which case call `invalidate()` to force a refresh of the GPU data.
	**/
	public function invalidate() : Void {
		content.dispose();
	}

	/**
		Returns the number of tiles added to the group.
	**/
	public function count() : Int {
		return content.triCount() >> 1;
	}

	override function onRemove() {
		content.dispose();
		super.onRemove();
	}

	/**
		Sets the default tinting color when adding new Tiles.
	**/
	public function setDefaultColor( rgb : Int, alpha = 1.0 ) {
		curColor.x = ((rgb >> 16) & 0xFF) / 255;
		curColor.y = ((rgb >> 8) & 0xFF) / 255;
		curColor.z = (rgb & 0xFF) / 255;
		curColor.w = alpha;
	}

	/**
		Adds a Tile at specified position. Tile is tinted by the current default color.
		@param x X position of the tile relative to the TileGroup.
		@param y Y position of the tile relative to the TileGroup.
		@param t The Tile to draw.
	**/
	public inline function add(x : Float, y : Float, t : h2d.Tile) {
		content.add(x, y, curColor.x, curColor.y, curColor.z, curColor.w, t);
	}

	/**
		Adds a tinted Tile at specified position.
		@param x X position of the tile relative to the TileGroup.
		@param y Y position of the tile relative to the TileGroup.
		@param r Red tint value (0...1 range).
		@param g Green tint value (0...1 range).
		@param b Blue tint value (0...1 range).
		@param a Alpha of the drawn Tile.
		@param t The Tile to draw.
	**/
	public inline function addColor( x : Float, y : Float, r : Float, g : Float, b : Float, a : Float, t : Tile) {
		content.add(x, y, r, g, b, a, t);
	}

	/**
		Adds a Tile at specified position. Tile is tinted by the current default color RGB value and provided alpha.
		@param x X position of the tile relative to the TileGroup.
		@param y Y position of the tile relative to the TileGroup.
		@param a Alpha of the drawn Tile.
		@param t The Tile to draw.
	**/
	public inline function addAlpha(x : Float, y : Float, a : Float, t : h2d.Tile) {
		content.add(x, y, curColor.x, curColor.y, curColor.z, a, t);
	}

	/**
		Adds a Tile at specified position with provided transform. Tile is tinted by the current default color.
		@param x X position of the tile relative to the TileGroup.
		@param y Y position of the tile relative to the TileGroup.
		@param sx X-axis scaling factor of the Tile.
		@param sy Y-axis scaling factor of the Tile.
		@param r Rotation (in radians) of the Tile.
		@param t The Tile to draw.
	**/
	public inline function addTransform(x : Float, y : Float, sx : Float, sy : Float, r : Float, t : Tile) {
		content.addTransform(x, y, sx, sy, r, curColor, t);
	}

	override function draw(ctx:RenderContext) {
		drawWith(ctx,this);
	}

	override function sync( ctx : RenderContext ) {
		super.sync(ctx);
		// On some mobile GPU, uploading while rendering does create a lot of stall.
		// Let's make sure to force the upload before starting while we are still
		// syncing our 2d scene.
		if( visible ) content.flush();
	}

	/**
		Render the TileGroup contents using the referenced Drawable position, shaders and other parameters.

		An advanced rendering approach, that allows to render TileGroup contents relative to another object
		and used primarily by `Text` and `HtmlText`.

		@param ctx The render context with which to render the TileGroup.
		@param obj The Drawable which will be used as a source of the rendering parameters.
	**/
	@:allow(h2d)
	@:dox(show)
	function drawWith( ctx:RenderContext, obj : Drawable ) {
		var max = content.triCount();
		if( max == 0 )
			return;
		if( !ctx.beginDrawBatchState(obj) ) return;
		var min = rangeMin < 0 ? 0 : rangeMin * 2;
		if( rangeMax > 0 && rangeMax < max * 2 ) max = rangeMax * 2;
		content.doRender(ctx, min, max - min);
	}

}
