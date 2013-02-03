package h2d;
import flash.display.BitmapData;
import h3d.Engine;
import h3d.impl.AllocPos;
import h3d.impl.TextureManager;
import h3d.mat.Texture;

class TileManager  {
	
	var e:Engine;
	
	public var tm(default, null):TextureManager;
	
	public function new(engine:Engine) {
		e = engine;
		tm = new TextureManager(engine);
		
		bmpCache = new Map<BitmapData, Tile>();
		colorCache = new IntHash<Tile>();
	}
	
	public function makeTexture(?bmp:BitmapData, ?bmpRef:Class<BitmapData>, ?mbmp:h3d.mat.Bitmap, ?allocPos : AllocPos):Texture 
		return tm.makeTexture(bmp, bmpRef, mbmp, allocPos)
		
	var bmpCache:Map<BitmapData, Tile>;
	var colorCache:IntHash<Tile>;
	
	public function fromBitmap( bmp : BitmapData, ?allocPos : h3d.impl.AllocPos ):Tile {
		var t = bmpCache.exists(bmp);
		if (t != null) return t;
		
		t = Tile.fromBitmap(bmp, allocPos);
		bmpCache.set(bmp, t);
		return t;
	}
	
	public function autoCut( bmp : flash.display.BitmapData, width : Int, ?height : Int, ?allocPos : h3d.impl.AllocPos ) {
		var res = Tile.autoCut(bmp, width, height, allocPos);
		bmpCache.set(bmp, res.main);
		
		return res;
	}
	
	public function fromColor( color : Int, ?allocPos : h3d.impl.AllocPos ):Tile {
		if (colorCache.exists(color)) return colorCache.get(color);
		
		var bmp = new BitmapData(1, 1, true, color);
		var res = fromBitmap(bmp, allocPos);
		colorCache.set(color, res);
		return res;
	}
	
	public function disposeTile(t:Tile)
	{
		t.dispose();
		bmpCache.removeValue(t);
		for (k in colorCache.keys())
			if (colorCache.get(k) == t) {
				colorCache.remove(k);
				break;
			}
	}
	
	@:access(h3d.impl.MemoryManager)
	@:access(h3d.mat.Texture)
	public function rebuildTextures()
	{
		tm.rebuildTextures();
		
		var t;
		for (bmp in bmpCache.keys()) {
			try {
				bmp.width;
				t = bmpCache.get(bmp).innerTex;
				e.mem.updateTexture(t);
				t.mem = e.mem;
				var inner = Tile.fromBitmap(bmp).innerTex;
				t.t = inner.t;
				e.mem.deleteTexture(inner, false);
			} catch (e:Dynamic) {}
		}
		
		for (c in colorCache.keys())
		{
			t = colorCache.get(c).innerTex;
			e.mem.updateTexture(t);
			t.mem = e.mem;
			t.upload(new BitmapData(1, 1, true, c));
		}
	}
	
	// empty all caches
	public function free()
	{
		tm.free();
		bmpCache.free();
		colorCache = new IntHash<Tile>();
	}

}