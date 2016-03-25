package h3d.mat;

class BigTextureElement {
	public var t : BigTexture;
	public var q : QuadTree;
	public var du : Float;
	public var dv : Float;
	public var su : Float;
	public var sv : Float;
	public function new(t, q, du, dv, su, sv) {
		this.t = t;
		this.q = q;
		this.du = du;
		this.dv = dv;
		this.su = su;
		this.sv = sv;
	}

	public function set(tex : hxd.res.Image) {
		t.set(tex, this);
	}
}

private class QuadTree {
	public var x : Int;
	public var y : Int;
	public var width : Int;
	public var height : Int;
	public var used : Bool;
	public var texture : hxd.res.Image;
	public var alphaChannel : hxd.res.Image;
	public var tr : QuadTree;
	public var tl : QuadTree;
	public var br : QuadTree;
	public var bl : QuadTree;
	public var loadingColor : Bool;
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
	var pending : Array<{ t : hxd.res.Image, q : QuadTree, alpha : Bool, skip : Bool }>;
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
			allPixels = hxd.Pixels.alloc(size, size, h3d.mat.Texture.nativeFormat);
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
		et.q.texture = t;
		upload(t, et.q, false);
		t.watch(rebuild);
	}

	public function setAlpha( t : hxd.res.Image, et : BigTextureElement ) {
		et.q.alphaChannel = t;
		upload(t, et.q, true);
		t.watch(rebuild);
	}

	function rebuild() {
		function rebuildRec( q : QuadTree ) {
			if( q == null ) return;
			if( q.texture != null )
				upload(q.texture, q, false);
			if( q.alphaChannel != null )
				upload(q.alphaChannel, q, true);
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
		upload(t, q, false);
		if( isUploaded ) {
			isUploaded = false;
			rebuild();
		}
		q.texture = t;
		t.watch(rebuild);
		return new BigTextureElement(this, q, q.x / size, q.y / size, tsize.width / size, tsize.height / size);
	}

	function uploadPixels( pixels : hxd.Pixels, x : Int, y : Int, alphaChannel ) {
		initPixels();
		var bpp = hxd.Pixels.bytesPerPixel(allPixels.format);
		if( alphaChannel ) {
			var alphaPos = hxd.Pixels.getChannelOffset(allPixels.format, 3);
			var srcRedPos = hxd.Pixels.getChannelOffset(pixels.format, 0);
			var srcBpp = hxd.Pixels.bytesPerPixel(pixels.format);
			for( dy in 0...pixels.height ) {
				var w = (x + (y + dy) * size) * bpp + alphaPos;
				var r = dy * pixels.width * srcBpp + srcRedPos;
				for( dx in 0...pixels.width ) {
					allPixels.bytes.set(w, pixels.bytes.get(r));
					w += bpp;
					r += srcBpp;
				}
			}
		} else {
			pixels.convert(allPixels.format);
			for( dy in 0...pixels.height )
				allPixels.bytes.blit((x + (y + dy) * size) * bpp, pixels.bytes, dy * pixels.width * bpp, pixels.width * bpp);
		}
		pixels.dispose();
		modified = true;
	}

	function upload( t : hxd.res.Image, q : QuadTree, alphaChannel ) {
		switch( t.getFormat() ) {
		case Png, Gif:
			uploadPixels(t.getPixels(), q.x, q.y, alphaChannel);
		case Jpg:
			loadCount++;
			var o = { t : t, q : q, alpha : alphaChannel, skip : false };
			pending.push(o);
			function load() {
				if( alphaChannel ) {
					if( o.skip )
						return;
					// wait for the color to be set before overwriting alpha
					if( q.loadingColor ) {
						haxe.Timer.delay(load, 10);
						return;
					}
				} else
					q.loadingColor = true;
				t.entry.loadBitmap(function(bmp) {
					if( o.skip ) return;
					if( !alphaChannel ) q.loadingColor = false;
					lastEvent = haxe.Timer.stamp();
					pending.remove(o);
					#if heaps
					var bmp = bmp.toBitmap();
					var pixels = bmp.getPixels();
					bmp.dispose();
					#else
					var pixels = bmp.getPixels();
					#end
					uploadPixels(pixels, q.x, q.y, alphaChannel);
					loadCount--;
					if( isDone )
						done();
					else
						flush();
				});
			}
			load();
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
			upload(o.t, o.q, o.alpha);
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
