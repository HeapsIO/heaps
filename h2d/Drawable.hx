package h2d;

/**
	A base class for all 2D objects that will draw something on the screen.

	Unlike Object base class, all properties of Drawable only apply to the current object and are not inherited by its children.
**/
class Drawable extends Object {

	/**
		The color multiplier for the drawable. Can be used to adjust individually each of the four channels R,G,B,A (default [1,1,1,1])
	**/
	public var color(default,default) : h3d.Vector;

	/**
		By enabling smoothing, scaling the object up or down will use hardware bilinear filtering resulting in a less crisp aspect.

		By default smooth is `null` in which case `Scene.defaultSmooth` value is used.
	**/
	public var smooth : Null<Bool>;

	/**
		Enables texture uv wrap for this Drawable, causing tiles with uv exceeding the texture size to repeat instead of clamping on edges.

		Note that `tileWrap` does not use the `Tile` region as a wrapping area but instead uses underlying `h3d.mat.Texture` size.
		This is due to implementation specifics, as it just sets the `Texture.wrap` to either `Repeat` or `Clamp`.
		Because of that, proper Tile tiling can be expected only when the tile covers an entire Texture area.
	**/
	public var tileWrap(default, set) : Bool;

	/**
		Setting a colorKey color value will discard all pixels that have this exact color in the tile.
	**/
	public var colorKey(default, set) : Null<Int>;

	/**
		Setting a colorMatrix will apply a color transformation. See also `adjustColor`.
	**/
	public var colorMatrix(get, set) : Null<h3d.Matrix>;

	/**
		Setting colorAdd will add the amount of color of each channel R,G,B,A to the object pixels.
	**/
	public var colorAdd(get, set) : Null<h3d.Vector>;

	var shaders : hxsl.ShaderList;

	/**
		Create a new Drawable instance with given parent.
		@param parent An optional parent `h2d.Object` instance to which Drawable adds itself if set.
	**/
	function new(parent : h2d.Object) {
		super(parent);
		color = new h3d.Vector(1, 1, 1, 1);
	}

	function set_tileWrap(b) {
		return tileWrap = b;
	}

	function get_colorAdd() {
		var s = getShader(h3d.shader.ColorAdd);
		return s == null ? null : s.color;
	}

	function set_colorAdd( c : h3d.Vector ) {
		var s = getShader(h3d.shader.ColorAdd);
		if( s == null ) {
			if( c != null ) {
				s = addShader(new h3d.shader.ColorAdd());
				s.color = c;
			}
		} else {
			if( c == null )
				removeShader(s);
			else
				s.color = c;
		}
		return c;
	}

	override function drawFiltered(ctx:RenderContext, tile:Tile) {
		var old = shaders;
		shaders = null;
		super.drawFiltered(ctx, tile);
		shaders = old;
	}

	function set_colorKey(v:Null<Int>) {
		var s = getShader(h3d.shader.ColorKey);
		if( s == null ) {
			if( v != null )
				s = addShader(new h3d.shader.ColorKey(0xFF000000 | v));
		} else {
			if( v == null )
				removeShader(s);
			else
				s.colorKey.setColor(0xFF000000 | v);
		}
		return colorKey = v;
	}

	/**
		Set the `Drawable.colorMatrix` value by specifying which effects to apply.
		Calling `adjustColor()` without arguments will reset the colorMatrix to `null`.
	**/
	public function adjustColor( ?col : h3d.Matrix.ColorAdjust ) : Void {
		if( col == null )
			colorMatrix = null;
		else {
			var m = colorMatrix;
			if( m == null ) {
				m = new h3d.Matrix();
				colorMatrix = m;
			}
			m.identity();
			m.adjustColor(col);
		}
	}

	function get_colorMatrix() {
		var s = getShader(h3d.shader.ColorMatrix);
		return s == null ? null : s.matrix;
	}

	function set_colorMatrix(m:h3d.Matrix) {
		var s = getShader(h3d.shader.ColorMatrix);
		if( s == null ) {
			if( m != null ) {
				s = addShader(new h3d.shader.ColorMatrix());
				s.matrix = m;
			}
		} else {
			if( m == null )
				removeShader(s);
			else
				s.matrix = m;
		}
		return m;
	}

	/**
		Returns the built shader code, can be used for debugging shader assembly
		@param toHxsl Whether return an HXSL shader or the native shading language of the backend.
	**/
	public function getDebugShaderCode( toHxsl = true ) {
		var shader = @:privateAccess {
			var ctx = getScene().ctx;
			ctx.manager.compileShaders(new hxsl.ShaderList(ctx.baseShader,shaders));
		}
		if( toHxsl ) {
			var toString = hxsl.Printer.shaderToString.bind(_, true);
			return "// vertex:\n" + toString(shader.vertex.data) + "\n\nfragment:\n" + toString(shader.fragment.data);
		} else {
			return h3d.Engine.getCurrent().driver.getNativeShaderCode(shader);
		}
	}

	/**
		Returns the first shader of the given shader class among the drawable shaders.
		@param stype The class of the shader to look up.
	**/
	public function getShader< T:hxsl.Shader >( stype : Class<T> ) : T {
		if (shaders != null) for( s in shaders ) {
			var s = hxd.impl.Api.downcast(s, stype);
			if( s != null )
				return s;
		}
		return null;
	}

	/**
		Returns an iterator of all drawable shaders
	**/
	public inline function getShaders() {
		return shaders.iterator();
	}

	/**
		Add a shader to the drawable shaders.

		Keep in mind, that as stated before, drawable children do not inherit Drawable properties, which includes shaders.
	**/
	public function addShader<T:hxsl.Shader>( s : T ) : T {
		if( s == null ) throw "Can't add null shader";
		shaders = hxsl.ShaderList.addSort(s, shaders);
		return s;
	}

	/**
		Remove a shader from the drawable shaders, returns true if found or false if it was not part of our shaders.
	**/
	public function removeShader( s : hxsl.Shader ) {
		var prev = null, cur = shaders;
		while( cur != null ) {
			if( cur.s == s ) {
				if( prev == null )
					shaders = cur.next;
				else
					prev.next = cur.next;
				return true;
			}
			prev = cur;
			cur = cur.next;
		}
		return false;
	}

	override function emitTile( ctx : RenderContext, tile : Tile ) {
		if( tile == null )
			tile = new Tile(null, 0, 0, 5, 5);
		if( !ctx.hasBuffering() ) {
			if( !ctx.drawTile(this, tile) ) return;
			return;
		}
		if( !ctx.beginDrawBatch(this, tile.getTexture()) ) return;

		var alpha = color.a * ctx.globalAlpha;
		var ax = absX + tile.dx * matA + tile.dy * matC;
		var ay = absY + tile.dx * matB + tile.dy * matD;
		var buf = ctx.buffer;
		var pos = ctx.bufPos;
		buf.grow(pos + 4 * 8);

		inline function emit(v:Float) buf[pos++] = v;

		emit(ax);
		emit(ay);
		emit(tile.u);
		emit(tile.v);
		emit(color.r);
		emit(color.g);
		emit(color.b);
		emit(alpha);


		var tw = tile.width;
		var th = tile.height;
		var dx1 = tw * matA;
		var dy1 = tw * matB;
		var dx2 = th * matC;
		var dy2 = th * matD;

		emit(ax + dx1);
		emit(ay + dy1);
		emit(tile.u2);
		emit(tile.v);
		emit(color.r);
		emit(color.g);
		emit(color.b);
		emit(alpha);

		emit(ax + dx2);
		emit(ay + dy2);
		emit(tile.u);
		emit(tile.v2);
		emit(color.r);
		emit(color.g);
		emit(color.b);
		emit(alpha);

		emit(ax + dx1 + dx2);
		emit(ay + dy1 + dy2);
		emit(tile.u2);
		emit(tile.v2);
		emit(color.r);
		emit(color.g);
		emit(color.b);
		emit(alpha);

		ctx.bufPos = pos;
	}

}
