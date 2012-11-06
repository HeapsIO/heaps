package h2d;

private class BatchShader extends h3d.Shader {
	static var SRC = {
		var input : {
			pos : Float2,
			uva : Float3,
		};
		var tuva : Float3;
		function vertex( mat1 : Float3, mat2 : Float3 ) {
			var tmp : Float4;
			tmp.x = pos.xyw.dp3(mat1);
			tmp.y = pos.xyw.dp3(mat2);
			tmp.z = 0;
			tmp.w = 1;
			out = tmp;
			tuva = uva;
		}
		function fragment( tex : Texture ) {
			var c = tex.get(tuva.xy, nearest);
			c.a *= tuva.z;
			out = c;
		}
	}
}

@:allow(h2d.SpriteBatch)
class BatchElement {
	public var x : Float;
	public var y : Float;
	public var alpha : Float;
	public var t : TilePos;
	public var batch(default, null) : SpriteBatch;
	
	var prev : BatchElement;
	var next : BatchElement;
	
	function new(b,t) {
		x = 0; y = 0; alpha = 1;
		this.batch = b;
		this.t = t;
	}
	
	public inline function remove() {
		batch.delete(this);
	}
	
}

class SpriteBatch extends Sprite {

	public var tiles : Tiles;
	var first : BatchElement;
	var last : BatchElement;
	var tmpBuf : flash.Vector<Float>;
	var material : h3d.mat.Material;
	
	static var SHADER = null;
	
	public function new(t,?parent) {
		super(parent);
		tiles = t;
		if( SHADER == null )
			SHADER = new BatchShader();
		material = new h3d.mat.Material(SHADER);
		material.depth(false, Always);
		material.blend(SrcAlpha, OneMinusSrcAlpha);
	}
	
	public function alloc(t) {
		var e = new BatchElement(this, t);
		if( first == null )
			first = last = e;
		else {
			last.next = e;
			e.prev = last;
			last = e;
		}
		return e;
	}
	
	@:allow(h2d.BatchElement)
	function delete(e : BatchElement) {
		if( e.prev == null ) {
			if( first == e )
				first = e.next;
		} else
			e.prev.next = e.next;
		if( e.next == null ) {
			if( last == e )
				last = e.prev;
		} else
			e.next.prev = e.prev;
	}
	
	override function draw( engine : h3d.Engine ) {
		if( first == null )
			return;
		if( tmpBuf == null ) tmpBuf = new flash.Vector();
		var pos = 0;
		var e = first;
		var tmp = tmpBuf;
		while( e != null ) {
			var t = e.t;
			var sx = e.x + t.dx;
			var sy = e.y + t.dy;
			tmp[pos++] = sx;
			tmp[pos++] = sy;
			tmp[pos++] = t.u;
			tmp[pos++] = t.v;
			tmp[pos++] = e.alpha;
			tmp[pos++] = sx + t.w + 0.1;
			tmp[pos++] = sy;
			tmp[pos++] = t.u2;
			tmp[pos++] = t.v;
			tmp[pos++] = e.alpha;
			tmp[pos++] = sx;
			tmp[pos++] = sy + t.h + 0.1;
			tmp[pos++] = t.u;
			tmp[pos++] = t.v2;
			tmp[pos++] = e.alpha;
			tmp[pos++] = sx + t.w + 0.1;
			tmp[pos++] = sy + t.h + 0.1;
			tmp[pos++] = t.u2;
			tmp[pos++] = t.v2;
			tmp[pos++] = e.alpha;
			e = e.next;
		}
		var buffer = engine.mem.allocVector(tmpBuf, 5, 4);
		var shader = SHADER;
		shader.tex = tiles.getTexture(engine);
		shader.mat1 = new h3d.Vector(matA, matC, absX);
		shader.mat2 = new h3d.Vector(matB, matD, absY);
		engine.selectMaterial(material);
		engine.renderQuads(buffer);
		buffer.dispose();
	}
	
	public inline function isEmpty() {
		return first == null;
	}
	
}