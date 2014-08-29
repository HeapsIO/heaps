package hxd.res;

typedef LoadedBitmapData = #if flash flash.display.BitmapData #elseif js js.html.Image #else Dynamic #end

abstract LoadedBitmap(LoadedBitmapData) {

	public inline function new(data) {
		this = data;
	}

	public function toBitmap() : hxd.BitmapData {
		#if flash
		return hxd.BitmapData.fromNative(this);
		#elseif js
		var canvas = js.Browser.document.createCanvasElement();
		canvas.width = this.width;
		canvas.height = this.height;
		var ctx = canvas.getContext2d();
		ctx.drawImage(this, 0, 0);
		return hxd.BitmapData.fromNative(ctx);
		#else
		throw "TODO";
		return null;
		#end
	}

	public inline function toNative() : LoadedBitmapData {
		return this;
	}

}