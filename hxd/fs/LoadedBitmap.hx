package hxd.fs;

typedef LoadedBitmapData = #if flash flash.display.BitmapData #elseif js js.html.Image #else Dynamic #end

abstract LoadedBitmap(LoadedBitmapData) {

	public inline function new(data) {
		this = data;
	}

	public function toBitmap() : hxd.BitmapData {
		#if flash
		return hxd.BitmapData.fromNative(this);
		#elseif js
		var bmp = new hxd.BitmapData(this.width, this.height);
		@:privateAccess bmp.ctx.drawImage(this, 0, 0);
		return bmp;
		#else
		throw "TODO";
		return null;
		#end
	}

	public inline function toNative() : LoadedBitmapData {
		return this;
	}

}