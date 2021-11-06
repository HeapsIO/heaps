package h3d.mat;

@:access(h3d.mat.BigTexture)
class BigTextureElement {
	public var t : BigTexture;
	var q : QuadTree;
	public var du : Float;
	public var dv : Float;
	public var su : Float;
	public var sv : Float;

	public var width(get, never) : Int;
	function get_width() { return q.width; }
	public var height(get, never) : Int;
	function get_height() { return q.height; }

	public function new(t, q, du, dv, su, sv) {
		this.t = t;
		this.q = q;
		this.du = du;
		this.dv = dv;
		this.su = su;
		this.sv = sv;
	}

	public function set(tex : hxd.res.Image) {
		if( q.texture == tex )
			return;
		q.texture = tex;
		t.isDone = false;
		if( tex != null ) tex.watch(t.rebuild);
	}

	public function setAlpha(tex : hxd.res.Image) {
		if( q.alphaChannel == tex )
			return;
		q.alphaChannel = tex;
		t.isDone = false;
		if( tex != null ) tex.watch(t.rebuild);
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
	var isDone : Bool;
	var pending : Array<{ t : hxd.res.Image, q : QuadTree, alpha : Bool, skip : Bool }>;
	var waitTimer : haxe.Timer;
	var lastEvent : Float;
	var bgColor : Int;

	public function new(id, size, bgColor = 0xFF8080FF ) {
		this.id = id;
		this.size = size;
		this.bgColor = bgColor;
		space = new QuadTree(0,0,size,size);
		tex = new h3d.mat.Texture(1, 1);
		tex.preventAutoDispose();
		tex.flags.set(Serialize);
		tex.clear(bgColor);
		tex.realloc = rebuild;
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

	function rebuild() {
		var old = space;
		var oldT = tex;
		tex = null;
		dispose();
		tex = oldT;
		space = old;
		done();
	}

	public function add( t : hxd.res.Image ) {
		var tsize = t.getSize();
		var q = allocPos(tsize.width,tsize.height);
		#if !hl
		if( t.getFormat() == Dds )
			throw "BigTexture does not support DDS on this platform for "+t.entry.path;
		#end
		if( q == null )
			return null;
		var e = new BigTextureElement(this, q, q.x / size, q.y / size, tsize.width / size, tsize.height / size);
		e.set(t);
		return e;
	}

	public function addEmpty( width : Int, height : Int ) {
		var q = allocPos(width, height);
		if( q == null )
			return null;
		var e = new BigTextureElement(this, q, q.x / size, q.y / size, width / size, height / size);
		return e;
	}

	function uploadPixels( pixels : hxd.Pixels, x : Int, y : Int, alphaChannel ) {
		var bpp = @:privateAccess allPixels.bytesPerPixel;
		if( alphaChannel ) {
			var alphaPos = hxd.Pixels.getChannelOffset(allPixels.format, A);
			var srcRedPos = hxd.Pixels.getChannelOffset(pixels.format, R);
			var srcBpp = @:privateAccess pixels.bytesPerPixel;
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
	}

	function upload( t : hxd.res.Image, q : QuadTree, alphaChannel ) {
		if( !t.getFormat().useAsyncDecode )
			uploadPixels(t.getPixels(), q.x, q.y, alphaChannel);
		else {
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
					var bmp = bmp.toBitmap();
					var pixels = bmp.getPixels();
					bmp.dispose();
					uploadPixels(pixels, q.x, q.y, alphaChannel);
					loadCount--;
					flush();
				});
			}
			load();
		}

	}

	function retry( pixels ) {
		if( allPixels != pixels ) {
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

	function flush() {
		if( allPixels == null || loadCount > 0 )
			return;
		onPixelsReady(allPixels);
		if( tex.width != size ) tex.resize(size, size);
		tex.uploadPixels(allPixels);
		allPixels.dispose();
		allPixels = null;
		if( waitTimer != null ) {
			waitTimer.stop();
			waitTimer = null;
		}
	}

	dynamic function onPixelsReady( pixels : hxd.Pixels ) {
	}

	public function done() {
		if( isDone )
			return;
		isDone = true;
		if( allPixels == null ) {
			allPixels = hxd.Pixels.alloc(size, size, h3d.mat.Texture.nativeFormat);
			if(bgColor != 0)
				allPixels.clear(bgColor);
		}
		// start loading all
		function loadRec(q:QuadTree) {
			if( q == null )
				return;
			if( q.texture != null )
				upload(q.texture, q, false);
			if( q.alphaChannel != null )
				upload(q.alphaChannel, q, true);
			loadRec(q.tl);
			loadRec(q.tr);
			loadRec(q.bl);
			loadRec(q.br);
		}
		loadRec(space);
		if( loadCount > 0 ) {
			#if flash
			// flash seems to sometime fail to load texture
			if( waitTimer == null ) {
				lastEvent = haxe.Timer.stamp();
				waitTimer = new haxe.Timer(1000);
				waitTimer.run = retry.bind(allPixels);
			}
			#end
			return;
		}
		flush();
	}

}
