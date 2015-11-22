package h3d.mat;

class BigTextureElement {
	public var t : BigTexture;
	public var du : Float;
	public var dv : Float;
	public var su : Float;
	public var sv : Float;
	public function new(t, du, dv, su, sv) {
		this.t = t;
		this.du = du;
		this.dv = dv;
		this.su = su;
		this.sv = sv;
	}
}

private class QuadTree {
	public var x : Int;
	public var y : Int;
	public var width : Int;
	public var height : Int;
	public var used : Bool;
	public var texture : hxd.res.Image;
	public var tr : QuadTree;
	public var tl : QuadTree;
	public var br : QuadTree;
	public var bl : QuadTree;
	public function new(x, y, w, h) {
		this.x = x;
		this.y = y;
		this.width = w;
		this.height = h;
	}
}

class BigTexture {

	public var id : Int;
	public var tex : h3d.mat.Texture;

	var loadCount : Int;
	var size : Int;
	var space : QuadTree;
	var allPixels : hxd.Pixels;
	var modified : Bool = true;
	var isDone : Bool;
	var isUploaded : Bool;
	var pending : Array<{ t : hxd.res.Image, x : Int, y : Int, w : Int, h : Int, skip : Bool }>;
	var waitTimer : haxe.Timer;
	var lastEvent : Float;

	public function new(id, size, bgColor = 0xFF8080FF, ?allocPos : h3d.impl.AllocPos ) {
		this.id = id;
		this.size = size;
		space = new QuadTree(0,0,size,size);
		tex = new h3d.mat.Texture(1, 1, allocPos);
		tex.clear(bgColor);
		pending = [];
	}

	public function dispose() {
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
		if( allPixels != null ) {
			allPixels.dispose();
			allPixels = null;
		}
		pending = [];
		if( waitTimer != null ) {
			waitTimer.stop();
			waitTimer = null;
		}
		isDone = false;
		space = null;
	}

	function initPixels() {
		if( allPixels == null )
			allPixels = hxd.Pixels.alloc(size, size, BGRA);
	}

	function findBest( q : QuadTree, w : Int, h : Int ) {
		if( q == null || q.width < w || q.height < h ) return null;
		if( !q.used ) return q;
		var b = findBest(q.tr, w, h);
		var b2 = findBest(q.tl, w, h);
		if( b == null || (b2 != null && b2.width * b2.height < b.width * b.height) ) b = b2;
		var b2 = findBest(q.bl, w, h);
		if( b == null || (b2 != null && b2.width * b2.height < b.width * b.height) ) b = b2;
		var b2 = findBest(q.br, w, h);
		if( b == null || (b2 != null && b2.width * b2.height < b.width * b.height) ) b = b2;
		return b;
	}

	function split( q : QuadTree, sw : Int, sh : Int, rw : Int, rh : Int ) {
		if( q.width < sw || q.height < sh ) {
			q.used = true;
			if( q.width == rw && q.height == rh )
				return q;
			q.tl = new QuadTree(q.x, q.y, rw, rh);
			q.tl.used = true;
			q.tr = new QuadTree(q.x + rw, q.y, q.width - rw, rh);
			q.bl = new QuadTree(q.x, q.y + rh, rw, q.height - rh);
			q.br = new QuadTree(q.x + rw, q.y + rh, q.width - rw, q.height - rh);
			return q.tl;
		}
		q.used = true;
		var qw = q.width >> 1;
		var qh = q.height >> 1;
		q.tl = new QuadTree(q.x, q.y, qw, qh);
		q.tr = new QuadTree(q.x + qw, q.y, qw, qh);
		q.bl = new QuadTree(q.x, q.y + qh, qw, qh);
		q.br = new QuadTree(q.x + qw, q.y + qh, qw, qh);
		return split(q.tl, sw, sh, rw, rh);
	}

	function allocPos( w : Int, h : Int ) {
		var q = findBest(space, w, h);
		if( q == null )
			return null;
		var w2 = 1, h2 = 1;
		while( w > w2 ) w2 <<= 1;
		while( h > h2 ) h2 <<= 1;
		return split(q, w2<<1, h2<<1, w, h);
	}

	public function set( t : hxd.res.Image, et : BigTextureElement ) {
		var tsize = t.getSize();
		upload(t, Math.round(et.du * size), Math.round(et.dv * size), tsize.width, tsize.height);
		// todo : update q.texture & setup watch
	}

	function rebuild() {
		function rebuildRec( q : QuadTree ) {
			if( q == null ) return;
			if( q.texture != null ) {
				var tsize = q.texture.getSize();
				upload(q.texture, q.x, q.y, tsize.width, tsize.height);
			}
			rebuildRec(q.tl);
			rebuildRec(q.tr);
			rebuildRec(q.bl);
			rebuildRec(q.br);
		}
		rebuildRec(space);
		flush();
	}

	public function add( t : hxd.res.Image ) {
		var tsize = t.getSize();
		var q = allocPos(tsize.width,tsize.height);
		if( q == null )
			return null;
		var x = q.x, y = q.y;
		upload(t, x, y, tsize.width, tsize.height);
		if( isUploaded ) {
			isUploaded = false;
			rebuild();
		}
		q.texture = t;
		t.watch(rebuild);
		return new BigTextureElement(this,x / size, y / size, tsize.width / size, tsize.height / size);
	}

	function upload( t : hxd.res.Image, x : Int, y : Int, width : Int, height : Int ) {
		switch( t.getFormat() ) {
		case Png, Gif:
			initPixels();
			var pixels = t.getPixels();
			pixels.convert(allPixels.format);
			for( dy in 0...height )
				allPixels.bytes.blit((x + (y + dy) * size) * 4, pixels.bytes, dy * width * 4, width * 4);
			pixels.dispose();
			modified = true;
		case Jpg:
			loadCount++;
			var o = { t : t, x : x, y : y, w : width, h : height, skip : false };
			pending.push(o);
			t.entry.loadBitmap(function(bmp) {
				if( o.skip ) return;
				lastEvent = haxe.Timer.stamp();
				pending.remove(o);
				initPixels();
				#if heaps
				var bmp = bmp.toBitmap();
				var pixels = bmp.getPixels();
				bmp.dispose();
				#else
				var pixels = bmp.getPixels();
				#end
				pixels.convert(allPixels.format);
				for( dy in 0...height )
					allPixels.bytes.blit((x + (y + dy) * size) * 4, pixels.bytes, dy * width * 4, width * 4);
				modified = true;
				pixels.dispose();
				loadCount--;
				if( isDone )
					done();
				else
					flush();
			});
		}
	}

	function retry() {
		if( isUploaded ) {
			waitTimer.stop();
			waitTimer = null;
			return;
		}
		if( haxe.Timer.stamp() - lastEvent < 4 )
			return;
		lastEvent = haxe.Timer.stamp();
		var old = pending;
		loadCount -= pending.length;
		pending = [];
		for( o in old ) {
			o.skip = true;
			upload(o.t, o.x, o.y, o.w, o.h);
		}
	}

	public function flush() {
		if( !modified || allPixels == null || loadCount > 0 )
			return;
		if( tex.width != size ) tex.resize(size, size);
		tex.uploadPixels(allPixels);
		modified = false;
		isUploaded = true;
	}

	public function done() {
		isDone = true;
		if( loadCount > 0 ) {
			#if flash
			// flash seems to sometime fail to load texture
			if( waitTimer == null ) {
				lastEvent = haxe.Timer.stamp();
				waitTimer = new haxe.Timer(1000);
				waitTimer.run = retry;
			}
			#end
			return;
		}
		flush();
		if( allPixels != null ) {
			allPixels.dispose();
			allPixels = null;
		}
	}

}
