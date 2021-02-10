package hxd.fs;

@:dox(hide)
#if flash
typedef LoadedBitmapData = flash.display.BitmapData;
#elseif js
typedef LoadedBitmapData = js.html.Image;
#else
typedef LoadedBitmapData = hxd.BitmapData;
#end

/**
	The native image data wrapper. Produced by `FileEntry.loadBitmap`.

	For JS underlying type is `js.html.Image`, otherwise it's `hxd.BitmapData`.
**/
abstract LoadedBitmap(LoadedBitmapData) {

	/**
		Create a new LoadedBitmap wrapper.
	**/
	public inline function new(data) {
		this = data;
	}

	/**
		Returns the BitmapData containing the pixels of this native image.
	**/
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

	/**
		Returns the underlying type of this image.
	**/
	public inline function toNative() : LoadedBitmapData {
		return this;
	}

}