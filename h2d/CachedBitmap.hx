package h2d;

class CachedBitmap extends Sprite {

	var tex : h3d.mat.Texture;
	public var width(default, set) : Int;
	public var height(default, set) : Int;
	public var freezed : Bool;
	public var colorMatrix : Null<h3d.Matrix>;
	public var colorAdd : Null<h3d.Color>;
	public var skew : Float;
	
	var renderDone : Bool;
	var realWidth : Int;
	var realHeight : Int;
	var tile : Tile;
	
	public function new( ?parent, width = -1, height = -1 ) {
		super(parent);
		this.width = width;
		this.height = height;
		skew = 0.;
	}
	
	override function onDelete() {
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
		super.onDelete();
	}
	
	function set_width(w) {
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
		width = w;
		return w;
	}

	function set_height(h) {
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
		height = h;
		return h;
	}

	override function draw( engine : h3d.Engine ) {
		if( colorMatrix == null && colorAdd == null && skew == 0. ) {
			Tools.drawTile(engine, this, tile, new h3d.Color(1, 1, 1, 1), blendMode);
			return;
		}
		var core = Tools.getCoreObjects();
		var b = core.cachedBitmapObj;
		Tools.setBlendMode(b.material,blendMode);
		var tmp = core.tmpVector;
		tmp.x = tile.width;
		tmp.y = tile.height;
		tmp.z = 1;
		b.shader.size = tmp;
		tmp.x = matA;
		tmp.y = matC;
		tmp.z = absX + tile.dx * matA + tile.dy * matC;
		b.shader.mat1 = tmp;
		tmp.x = matB;
		tmp.y = matD;
		tmp.z = absY + tile.dx * matB + tile.dy * matD;
		b.shader.mat2 = tmp;
		tmp.x = tile.u2 - tile.u;
		tmp.y = tile.v2 - tile.v;
		b.shader.uvScale = tmp;
		b.shader.mcolor = colorMatrix == null ? h3d.Matrix.I() : colorMatrix;
		if( colorAdd == null ) {
			tmp.x = 0;
			tmp.y = 0;
			tmp.z = 0;
			tmp.w = 0;
		} else {
			tmp.x = colorAdd.r;
			tmp.y = colorAdd.g;
			tmp.z = colorAdd.b;
			tmp.w = colorAdd.a;
		}
		b.shader.acolor = tmp;
		b.shader.skew = skew;
		
		b.shader.tex = tile.getTexture();
		b.render(engine);
	}
	
	override function render( engine : h3d.Engine ) {
		updatePos();
		if( tex != null && ((width < 0 && tex.width < engine.width) || (height < 0 && tex.height < engine.height)) ) {
			tex.dispose();
			tex = null;
		}
		if( tex == null ) {
			var tw = 1, th = 1;
			realWidth = width < 0 ? engine.width : width;
			realHeight = height < 0 ? engine.height : height;
			while( tw < realWidth ) tw <<= 1;
			while( th < realHeight ) th <<= 1;
			tex = engine.mem.allocTargetTexture(tw, th);
			renderDone = false;
			tile = new Tile(tex,0, 0, realWidth, realHeight);
		}
		if( !freezed || !renderDone ) {
			var oldA = matA, oldB = matB, oldC = matC, oldD = matD, oldX = absX, oldY = absY;
			
			// init matrix without rotation
			matA = 1;
			matB = 0;
			matC = 0;
			matD = 1;
			absX = 0;
			absY = 0;
			
			// adds a pixels-to-viewport transform
			var w = 2 / tex.width;
			var h = -2 / tex.height;
			absX = absX * w - 1;
			absY = absY * h + 1;
			matA *= w;
			matB *= h;
			matC *= w;
			matD *= h;
			
			engine.setTarget(tex);
			engine.setRenderZone(0, 0, realWidth, realHeight);
			for( c in childs )
				c.render(engine);
			engine.setTarget(null);
			engine.setRenderZone();
			
			// restore
			matA = oldA;
			matB = oldB;
			matC = oldC;
			matD = oldD;
			absX = oldX;
			absY = oldY;
			
			renderDone = true;
		}

		draw(engine);
		posChanged = false;
	}
	
}