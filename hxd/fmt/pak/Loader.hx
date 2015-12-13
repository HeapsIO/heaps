package hxd.fmt.pak;

class Loader extends h2d.Sprite {

	var onDone : Void -> Void;
	var cur : hxd.net.BinaryLoader;
	var resCount : Int;
	var fs : FileSystem;
	var s2d : h2d.Scene;
	var bg : h2d.Graphics;

	public function new(s2d:h2d.Scene, onDone) {
		super(s2d);
		this.s2d = s2d;
		this.bg = new h2d.Graphics(this);
		this.onDone = onDone;
		if( hxd.res.Loader.currentInstance == null )
			hxd.res.Loader.currentInstance = new hxd.res.Loader(new FileSystem());
		fs = Std.instance(hxd.res.Loader.currentInstance.fs, FileSystem);
		if( fs == null )
			throw "Can only use loader with PAK file system";
		hxd.System.setLoop(render);
	}

	function render() {
		s2d.checkEvents();
		h3d.Engine.getCurrent().render(s2d);
	}

	function updateBG( progress : Float ) {
		bg.clear();
		bg.beginFill(0x404040);
		bg.drawRect(0, 0, 100, 10);
		bg.beginFill(0x40C040);
		bg.drawRect(1, 1, Std.int(progress * 98), 10);
	}

	override function sync(ctx:h2d.RenderContext)  {
		super.sync(ctx);
		if( cur == null ) {

			bg.x = (s2d.width - 100) >> 1;
			bg.y = (s2d.height - 10) >> 1;
			updateBG(0);

			cur = new hxd.net.BinaryLoader("res" + (resCount == 0 ? "" : "" + resCount) + ".pak");
			cur.onLoaded = function(bytes) {
				try {
					fs.addPak(new FileSystem.FileInput(bytes));
					resCount++;
					cur = null;
				} catch( e : Dynamic ) {
					cur.onError(e);
				}
			};
			cur.onProgress = function(cur, max) {
				updateBG(cur / max);
			};
			cur.onError = function(e) {
				if( resCount == 0 )
					trace(e);
				else {
					remove();
					onDone();
				}
			};
			cur.load();
		}
	}


}