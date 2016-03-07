package hxd.fs;

#if (flash || openfl)
typedef LoadedBitmapData = flash.display.BitmapData;
#elseif lime
typedef LoadedBitmapData = lime.graphics.Image;
#elseif js 
typedef LoadedBitmapData = js.html.Image;
#else 
typedef LoadedBitmapData = Dynamic;
#end

abstract LoadedBitmap(LoadedBitmapData) {

	public inline function new(data) {
		this = data;
	}

	public function toBitmap() : hxd.BitmapData {
		#if (flash || openfl)
		return hxd.BitmapData.fromNative(this);
		#elseif lime
		var bmp = new hxd.BitmapData(this.width, this.height);
			//TODO  test this
			#if js @:privateAccess bmp.pixel = this.src;
			#else @:privateAccess bmp.data = this;
			#end
		return bmp;
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