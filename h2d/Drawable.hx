package h2d;

typedef ColorAdjust = {
	?saturation : Float,
	?lightness : Float,
	?hue : Float,
	?contrast : Float,
	?gain : { color : Int, alpha : Float },
};

class Drawable extends Sprite {

	public var color(default,null) : h3d.Vector;
	public var blendMode : BlendMode;
	public var smooth : Null<Bool>;
	public var tileWrap(default, set) : Bool;
	public var colorKey(default, set) : Null<Int>;
	public var colorMatrix(get, set) : Null<h3d.Matrix>;
	public var colorAdd(get, set) : Null<h3d.Vector>;

	var shaders : hxsl.ShaderList;

	function new(parent : h2d.Sprite) {
		super(parent);
		blendMode = Alpha;
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

	public function adjustColor( ?col : ColorAdjust ) : Void {
		if( col == null )
			colorMatrix = null;
		else {
			var m = colorMatrix;
			if( m == null ) {
				m = new h3d.Matrix();
				colorMatrix = m;
			}
			m.identity();
			if( col.hue != null ) m.colorHue(col.hue);
			if( col.saturation != null ) m.colorSaturation(col.saturation);
			if( col.contrast != null ) m.colorContrast(col.contrast);
			if( col.lightness != null ) m.colorLightness(col.lightness);
			if( col.gain != null ) m.colorGain(col.gain.color, col.gain.alpha);
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

	public function getShader< T:hxsl.Shader >( stype : Class<T> ) : T {
		if (shaders != null) for( s in shaders ) {
			var s = Std.instance(s, stype);
			if( s != null )
				return s;
		}
		return null;
	}

	public inline function getShaders() {
		return shaders.iterator();
	}

	public function addShader<T:hxsl.Shader>( s : T ) : T {
		if( s == null ) throw "Can't add null shader";
		shaders = hxsl.ShaderList.addSort(s, shaders);
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
