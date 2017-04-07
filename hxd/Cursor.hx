package hxd;

enum Cursor {
	Default;
	Button;
	Move;
	TextInput;
	Hide;
	Custom( custom : CustomCursor );
}

@:allow(hxd.System)
class CustomCursor {

	var frames : Array<hxd.BitmapData>;
	var speed : Float;
	var offsetX : Int;
	var offsetY : Int;
	#if hlsdl
	var alloc : sdl.Cursor;
	#elseif flash
	static var UID = 0;
	var name : String;
	var alloc : flash.ui.MouseCursorData;
	#end

	public function new( frames, speed, offsetX, offsetY ) {
		this.frames = frames;
		this.speed = speed;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		#if flash
		name = "custom_" + UID++;
		#end
	}

	public function dispose() {
		for( f in frames )
			f.dispose();
		frames = [];
		#if hlsdl
		if( alloc != null ) {
			alloc.free();
			alloc = null;
		}
		#elseif flash
		if( alloc != null ) {
			flash.ui.Mouse.unregisterCursor(name);
			alloc = null;
		}
		#end
	}

}
