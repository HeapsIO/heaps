package hxd.fs;

#if flash
typedef LoadedBitmapData = flash.display.BitmapData;
#elseif js
typedef LoadedBitmapData = js.html.Image;
#else
typedef LoadedBitmapData = hxd.BitmapData;
#end

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
		return this;
		#end
	}

	public inline function toNative() : LoadedBitmapData {
		return this;
	}

}