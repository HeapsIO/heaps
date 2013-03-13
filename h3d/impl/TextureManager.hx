package h3d.impl;

import flash.display.BitmapData;
import h3d.Engine;
import h3d.mat.Bitmap;
import h3d.mat.Texture;
import h3d.impl.Shaders;
import haxe.ds.ObjectMap;
import hxsl.Shader;

using Tools.MapTools;

class TextureManager {

	var e:Engine;
	
	public function new(engine:Engine)
	{
		e = engine;
		
		bmpCache = new Map();
		bmpRefCache = new ObjectMap();
		mbmpCache = new Map();
	}
	
	var bmpCache : Map<BitmapData, Texture>;
	var bmpRefCache : Map<Class<BitmapData>, Texture>;
	var mbmpCache : Map<Bitmap, Texture>;
	
	public function makeTexture(?bmp:BitmapData, ?bmpRef:Class<BitmapData>, ?mbmp:Bitmap, ?allocPos : AllocPos):Texture {
		var res:Texture;
		if (bmp != null) {
			res = bmpCache.exists(bmp) ? bmpCache.get(bmp) : e.mem.makeTexture(bmp, allocPos);
			bmpCache.set(bmp, res);
		}
		else if (mbmp != null) {
			res = mbmpCache.exists(mbmp) ? mbmpCache.get(mbmp) : e.mem.makeTexture(mbmp, allocPos);
			mbmpCache.set(mbmp, res);
		}
		else {
			res = bmpRefCache.exists(bmpRef) ? bmpRefCache.get(bmpRef) : e.mem.makeTexture(Type.createInstance(bmpRef, [0, 0]), allocPos);
			bmpRefCache.set(bmpRef, res);
		}
		return res;
	}
	
	@:access(h3d.impl.MemoryManager)
	public function rebuildTextures()
	{
		Shader.freeCache(PointShader);
		Shader.freeCache(LineShader);
		
		var t;
		for (bmp in bmpCache.keys()) {
			try {
				bmp.width;
				t = bmpCache.get(bmp);
				e.mem.updateTexture(t);
				t.mem = e.mem;
				t.upload(bmp);
			} catch (e:Dynamic) {}
		}
		
		for (mbmp in mbmpCache.keys()) {
			t = mbmpCache.get(mbmp);
			e.mem.updateTexture(t);
			t.mem = e.mem;
			t.uploadBytes(mbmp.bytes);
		}
		
		for (bmpRef in bmpRefCache.keys()) {
			t = bmpRefCache.get(bmpRef);
			e.mem.updateTexture(t);
			t.mem = e.mem;
			t.upload(Type.createInstance(bmpRef, [0, 0]));
		}
	}
	
	public function disposeTexture(t:Texture)
	{
		t.dispose();
		bmpCache.removeValue(t);
		mbmpCache.removeValue(t);
		bmpRefCache.removeValue(t);
	}
	
	// empty all caches
	public function free()
	{
		bmpCache = new Map();
		bmpRefCache = new ObjectMap();
		mbmpCache = new Map();
	}

}