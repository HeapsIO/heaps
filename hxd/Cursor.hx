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

	static var cursorOverrides:Map<Cursor, Cursor> = new Map();

	/**
		Allows to override default cursors by custom ones.
		Custom and Hide cursor cannot be overriden.
		Passing `null` to as `by` will remove cursor override.
	**/
	public static function setCursorOverride(cur:Cursor, by:CustomCursor):Void {
		switch( cur ) {
			case Custom(_), Hide:
				// Ignore, can't override.
			default:
				if ( by == null )
					cursorOverrides.remove(cur);
				else
					cursorOverrides.set(cur, Custom(by));
		}
	}

	var frames : Array<hxd.BitmapData>;
	var speed : Float;
	var offsetX : Int;
	var offsetY : Int;
	#if macro
	var alloc : Array<Dynamic>;
	#elseif hlsdl
	var alloc : Array<sdl.Cursor>;
	#elseif hldx
	var alloc : Array<dx.Cursor>;
	#elseif flash
	static var UID = 0;
	var name : String;
	var alloc : flash.ui.MouseCursorData;
	#elseif js
	var alloc : Array<String>;
	#else
	var alloc : Dynamic;
	#end

	// Heaps-side cursor animation for target that do not support native animated cursors.
	#if (hlsdl || hldx || js)
	var frameDelay : Float;
	var frameTime : Float;
	var frameIndex : Int;
	#end

	public function new( frames, speed, offsetX, offsetY ) {
		this.frames = frames;
		this.speed = speed;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		#if flash
		name = "custom_" + UID++;
		#end
		#if (hlsdl || hldx || js)
		frameDelay = 1 / speed;
		frameTime = 0;
		frameIndex = 0;
		#end
	}

	#if (hlsdl || hldx || js)
	public function reset() : Void {
		frameTime = 0;
		frameIndex = 0;
	}

	public function update( dt : Float ) : Int {
		var newTime : Float = frameTime + dt;
		var delay : Float = frameDelay;
		var index : Int = frameIndex;
		while( newTime >= delay ) {
			newTime -= delay;
			index++;
		}
		frameTime = newTime;

		if ( index >= frames.length ) index %= frames.length;
		if ( index != frameIndex ) {
			frameIndex = index;
			return index;
		}
		return -1;
	}
	#end

	public function dispose() {
		for( f in frames )
			f.dispose();
		frames = [];
		if( alloc != null ) {
			#if hlsdl
			for (cur in alloc) {
				cur.free();
			}
			#elseif flash
			flash.ui.Mouse.unregisterCursor(name);
			#elseif hldx
			for (cur in alloc) {
				cur.destroy();
			}
			#elseif js
			// alloc set to null below.
			#else
			throw "TODO";
			#end
			alloc = null;
		}
	}

}
