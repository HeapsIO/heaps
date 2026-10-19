package hxd.res;

typedef StreamStats = {
	var count : Int;
	var residentBytes : Float;
	var fullBytes : Float;
	var visible : Int;
	var visibleBytes : Float;
	var hidden : Int;
	var hiddenBytes : Float;
	var freeable : Int;
	var freeableBytes : Float;
	var freeableWaiting : Int;
	var excessBytes : Float;
	var maxVisibleSize : Int;
	var status : String;
	var gpuUsed : Float;
	var gpuBudget : Float;
	var heapsTextureBytes : Float;
	var heapsBufferBytes : Float;
	var readsQueued : Int;
	var readsInFlight : Int;
	var completedWaiting : Int;
}

typedef TextureMemory = {
	var count : Int;
	var bytes : Float;
	var categories : Array<{ name : String, count : Int, bytes : Float }>;
	var largest : Array<{ name : String, bytes : Float, size : String, format : String, mips : String, category : String }>;
}

typedef StreamFrameStats = {
	var completions : Int;
	var completionTime : Float;
	var unloads : Int;
}

typedef StreamCompletion = {
	var name : String;
	var fromMip : Int;
	var toMip : Int;
	var bytes : Int;
	var mainTime : Float;
	var allocTime : Float;
	var waitTime : Float;
	var frame : Int;
}

@:access(hxd.res.TextureStream)
@:access(hxd.res.Image)
@:access(h3d.mat.Texture)
@:allow(hxd.res.TextureStream)
class TextureStreamDebug {

	public static var PROFILING = false;
	public static var frameStats(default, null) : StreamFrameStats = { completions : 0, completionTime : 0., unloads : 0 };
	public static var recentCompletions(default, null) : Array<StreamCompletion> = [];

	static inline var RECENT_COMPLETIONS = 12;

	static function beginFrame() {
		frameStats.completions = 0;
		frameStats.completionTime = 0;
		frameStats.unloads = 0;
	}

	static function recordCompletion( s : TextureStream, fromMip : Int, start : Float, end : Float ) {
		frameStats.completions++;
		frameStats.completionTime += end - start;
		recentCompletions.push({ name : s.image.entry.path, fromMip : fromMip, toMip : s.texture.residentMip, bytes : s.readSize,
			mainTime : end - start, allocTime : s.allocTime, waitTime : s.completedTime > 0 ? start - s.completedTime : 0, frame : hxd.Timer.frameCount });
		if( recentCompletions.length > RECENT_COMPLETIONS ) recentCompletions.shift();
	}

	public static function getStats() : StreamStats {
		var frame = hxd.Timer.frameCount;
		var st : StreamStats = {
			count : 0, residentBytes : TextureStream.residentBytes, fullBytes : 0., visible : 0, visibleBytes : 0., hidden : 0, hiddenBytes : 0.,
			freeable : 0, freeableBytes : 0., freeableWaiting : 0, excessBytes : TextureStream.excessBytes,
			maxVisibleSize : TextureStream.maxVisibleSize, status : TextureStream.status, gpuUsed : -1., gpuBudget : -1., heapsTextureBytes : -1., heapsBufferBytes : -1.,
			readsQueued : TextureStream.queue.length, readsInFlight : TextureStream.readsInFlight, completedWaiting : TextureStream.completed.length,
		};
		for( s in TextureStream.streams ) {
			var t = s.texture;
			if( t.t == null || !s.mipStreaming ) continue;
			st.count++;
			var bytes = s.getResidentBytes();
			st.fullBytes += s.getMipPos(s.inf.mipLevels) - s.getMipPos(0);
			if( s.isVisible(frame) ) {
				st.visible++;
				st.visibleBytes += bytes;
				continue;
			}
			st.hidden++;
			st.hiddenBytes += bytes;
			var min = s.getMinMip();
			if( t.residentMip < min ) {
				st.freeable++;
				st.freeableBytes += s.getMipPos(min) - s.getMipPos(t.residentMip);
				if( t.visibleFrame >= frame - TextureStream.HIDDEN_FRAMES ) st.freeableWaiting++;
			}
		}
		var engine = h3d.Engine.getCurrent();
		var use = engine == null ? null : engine.driver.getMemoryUsage();
		if( use != null ) {
			st.gpuUsed = use.allocated;
			st.gpuBudget = use.total;
		}
		var mem = engine == null ? null : engine.mem.stats();
		if( mem != null ) {
			st.heapsTextureBytes = mem.textureMemory;
			st.heapsBufferBytes = mem.bufferMemory;
		}
		return st;
	}

	public static function getTextureCategory( t : h3d.mat.Texture ) {
		if( t.isDepth() ) return "depth";
		if( t.flags.has(Target) ) return "render target";
		if( t.flags.has(Streamed) ) return "streamed";
		if( t.flags.has(IsArray) || t.flags.has(Cube) || t.flags.has(Is3D) ) return "array/cube/3D";
		if( !t.flags.has(MipMapped) || t.mipLevels <= 1 ) return "no mips";
		return "other";
	}

	@:access(h3d.impl.MemoryManager)
	public static function getNotStreamedMemory( top : Int ) : TextureMemory {
		var res : TextureMemory = { count : 0, bytes : 0., categories : [], largest : [] };
		var engine = h3d.Engine.getCurrent();
		if( engine == null ) return res;
		var mem = engine.mem;
		var all = [];
		for( t in mem.textures ) {
			if( t.t == null ) continue;
			var category = getTextureCategory(t);
			if( category == "streamed" ) continue;
			var bytes : Float = mem.memSize(t);
			all.push({ t : t, bytes : bytes, category : category });
			res.count++;
			res.bytes += bytes;
			var c = null;
			for( e in res.categories )
				if( e.name == category ) c = e;
			if( c == null ) res.categories.push(c = { name : category, count : 0, bytes : 0. });
			c.count++;
			c.bytes += bytes;
		}
		res.categories.sort((a, b) -> Reflect.compare(b.bytes, a.bytes));
		all.sort((a, b) -> Reflect.compare(b.bytes, a.bytes));
		for( i in 0...hxd.Math.imin(top, all.length) ) {
			var t = all[i].t;
			res.largest.push({
				name : t.name == null ? "Texture#" + t.id : t.name,
				bytes : all[i].bytes,
				size : t.width + "x" + t.height + (t.layerCount > 1 ? "x" + t.layerCount : ""),
				format : "" + t.format,
				mips : t.mipLevels > 1 ? '${t.residentMip}..${t.mipLevels - 1}' : "-",
				category : all[i].category,
			});
		}
		return res;
	}

}
