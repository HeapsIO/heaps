class Key {

	static var fl_initDone = false;
	static var kcodes = new Array<Null<Int>>();

	static var ktime = 0;

	public static function init() {
		var stage = flash.Lib.current.stage;
		if (fl_initDone) {
			stage.removeEventListener(flash.events.Event.ENTER_FRAME,onEnterFrame);
			stage.addEventListener(flash.events.Event.ENTER_FRAME,onEnterFrame);
			return;
		}
		fl_initDone = true;
		
		
		stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN,callback(onKey,true));
		stage.addEventListener(flash.events.KeyboardEvent.KEY_UP,callback(onKey,false));
		stage.addEventListener(flash.events.Event.DEACTIVATE,function(_) kcodes = new Array());
		stage.addEventListener(flash.events.Event.ENTER_FRAME,onEnterFrame);
	}
	
	static function onEnterFrame(_) {
		ktime++;
	}

	static function onKey( down, e : flash.events.KeyboardEvent ) {
		event(e.keyCode, down);
	}

	public static function event( code, down ) {
		kcodes[code] = down ? ktime : null;
		// release Ctrl when Alt pressed (AltGr generates Ctrl+Alt)
		if( code == 18 && !down )
			kcodes[17] = null;
	}


	public static function isDown(c) {
		return kcodes[c] != null;
	}

	public static function isToggled(c) {
		return kcodes[c] == ktime;
	}
	
	public static function stopAll() {
		kcodes = [];
	}

	public static function enableJSKeys(objName:String) {
		try {
			flash.external.ExternalInterface.addCallback("onKeyEvent",#if !flash9 null,#end event);
			var r : Null<Bool> = flash.external.ExternalInterface.call("function() { var fla = window.document['"+objName+"']; if( fla == null ) return false; document.onkeydown = function(e) { if( e == null ) e = window.event; fla.onKeyEvent(e.keyCode,true); }; document.onkeyup = function(e) { if( e == null ) e = window.event; fla.onKeyEvent(e.keyCode,false); }; return true; }");
			if( r == null ) r = false;
			return r;
		} catch( e : Dynamic ) {
			return false;
		}
	}

}
