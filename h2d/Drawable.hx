package h2d;

class Drawable extends Sprite {

	public var color(default,null) : h3d.Vector;
	public var alpha(get, set) : Float;
	public var blendMode : BlendMode;
	public var filter : Bool;
	public var tileWrap : Bool;
	public var colorKey(default, set) : Null<Int>;
	public var colorMatrix(get, set) : Null<h3d.Matrix>;
	public var colorAdd(get, set) : Null<h3d.Vector>;

	var shaders : hxsl.ShaderList;

	function new(parent) {
		super(parent);
		blendMode = Alpha;
		color = new h3d.Vector(1, 1, 1, 1);
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

	function get_colorMatrix() {
		var s = getShader(h3d.shader.ColorMatrix);
		return s == null ? null : s.matrix;
	}

	function set_colorMatrix(m:h3d.Matrix) {
		var s = getShader(h3d.shader.ColorMatrix);
		if( s == null ) {
			if( m != null ) {
				s = addShader(new h3d.shader.ColorMatrix());
				s.matrix.loadFrom(m);
			}
		} else {
			if( m == null )
				removeShader(s);
			else
				s.matrix.loadFrom(m);
		}
		return m;
	}

	inline function get_alpha() {
		return color.a;
	}

	inline function set_alpha(v) {
		return color.a = v;
	}

	public function getDebugShaderCode( toHxsl = true ) {
		var shader = @:privateAccess {
			var ctx = getScene().ctx;
			ctx.manager.compileShaders(new hxsl.ShaderList(ctx.baseShader,shaders));
		}
		var toString = toHxsl ? function(d) return hxsl.Printer.shaderToString(d,true) : hxsl.GlslOut.toGlsl;
		return "VERTEX=\n" + toString(shader.vertex.data) + "\n\nFRAGMENT=\n" + toString(shader.fragment.data);
	}

	public function getShader< T:hxsl.Shader >( stype : Class<T> ) : T {
		if (shaders != null) for( s in shaders )
			if( Std.is(s, stype) )
				return cast s;
		return null;
	}

	public inline function getShaders() {
		return shaders.iterator();
	}

	public function addShader<T:hxsl.Shader>( s : T ) : T {
		if( s == null ) throw "Can't add null shader";
		shaders = new hxsl.ShaderList(s, shaders);
		return s;
	}

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

	function emitTile( ctx : RenderContext, tile : Tile ) {
		if( tile == null )
			tile = new Tile(null, 0, 0, 5, 5);
		ctx.beginDrawBatch(this, tile.getTexture());

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
		emit(color.a);


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
		emit(color.a);

		emit(ax + dx2);
		emit(ay + dy2);
		emit(tile.u);
		emit(tile.v2);
		emit(color.r);
		emit(color.g);
		emit(color.b);
		emit(color.a);

		emit(ax + dx1 + dx2);
		emit(ay + dy1 + dy2);
		emit(tile.u2);
		emit(tile.v2);
		emit(color.r);
		emit(color.g);
		emit(color.b);
		emit(color.a);

		ctx.bufPos = pos;
	}

}
