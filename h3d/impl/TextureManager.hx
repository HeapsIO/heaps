package h3d.impl;

import flash.display.BitmapData;
import h3d.Engine;
import h3d.mat.Bitmap;
import h3d.mat.Texture;
import h3d.impl.Shaders;
import hxsl.Shader;

class Map < K, V > {
	
	var ks:Array<K>;
	var vs:Array<V>;
	
	public function new() {
		free();
	}
	
	public function exists(k:K):Null<V> {
		var pos = Lambda.indexOf(ks, k);
		if (pos == -1) return null;
		else return vs[pos];
	}
	
	inline public function get(k:K):V return vs[Lambda.indexOf(ks, k)]
	
	public function set(k:K, v:V)
	{
		var pos = Lambda.indexOf(ks, k);
		if (pos == -1) { ks.push(k); vs.push(v); }
		else vs[pos] = v;
	}
	
	public function remove(k:K):Bool
	{
		var pos = Lambda.indexOf(ks, k);
		if (pos == -1) return false;
		ks.splice(pos, 1);
		vs.splice(pos, 1);
		return true;
	}
	
	public function removeValue(v:V):Bool
	{
		var pos = Lambda.indexOf(vs, v);
		if (pos == -1) return false;
		ks.splice(pos, 1);
		vs.splice(pos, 1);
		return true;
	}
	
	inline public function keys() return ks.iterator()
	
	inline public function iterator() return vs.iterator()
	
	public function free()
	{
		ks = [];
		vs = [];
	}
	
}

class TextureManager {

	var e:Engine;
	
	public function new(engine:Engine)
	{
		e = engine;
		
		bmpCache = new Map<BitmapData, Texture>();
		bmpRefCache = new Map<Class<BitmapData>, Texture>();
		mbmpCache = new Map<Bitmap, Texture>();
	}
	
	var bmpCache : Map<BitmapData, Texture>;
	var bmpRefCache : Map<Class<BitmapData>, Texture>;
	var mbmpCache : Map<Bitmap, Texture>;
	
	public function makeTexture(?bmp:BitmapData, ?bmpRef:Class<BitmapData>, ?mbmp:Bitmap, ?allocPos : AllocPos):Texture {
		var res:Texture;
		if (bmp != null) {
			res = bmpCache.exists(bmp);
			if (res == null) res = e.mem.makeTexture(bmp, allocPos);
			bmpCache.set(bmp, res);
		}
		else if (mbmp != null) {
			res = mbmpCache.exists(mbmp);
			if (res == null) res = e.mem.makeTexture(mbmp, allocPos);
			mbmpCache.set(mbmp, res);
		}
		else {
			res = bmpRefCache.exists(bmpRef);
			if (res == null) res = e.mem.makeTexture(Type.createInstance(bmpRef, [0, 0]), allocPos);
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
		bmpCache.free();
		bmpRefCache.free();
		mbmpCache.free();
	}

}