package hxd;

#if hl
#if hlsdl
import sdl.Event;
import sdl.GameController;
#elseif (usesys && !hlmesa)
import haxe.GameController;
#elseif hldx
import dx.GameController;
#else
private typedef Event = {
}
private class GameController {
	public static var NUM_AXES = 0;
	public static var NUM_BUTTONS = 0;
	public static var CONFIG : Dynamic = {};
	public var name : String;
	public var index : Int;
	public function getButtons() return 0;
	public function getAxis(i:Int) return 0;
	public function update() {}
	public function rumble( strength : Float, time : Float ) {}
	public static function init() {}
	public static function detect(_) {}
}
#end
#end

typedef PadConfig = {
	analogX : Int,
	analogY : Int,
	ranalogX : Int,
	ranalogY : Int,
	A : Int,
	B : Int,
	X : Int,
	Y : Int,
	LB : Int,
	RB : Int,
	LT : Int,
	RT : Int,
	back : Int,
	start : Int,
	analogClick : Int,
	ranalogClick : Int,
	dpadUp : Int,
	dpadDown : Int,
	dpadLeft : Int,
	dpadRight : Int,
	names : Array<String>,
}

class Pad {

	#if flash
	public static var CONFIG_XBOX = {
		analogX : 0,
		analogY : 1,
		ranalogX : 2,
		ranalogY : 3,
		A : 4,
		B : 5,
		X : 6,
		Y : 7,
		LB : 8,
		RB : 9,
		LT : 10,
		RT : 11,
		back : 12,
		start : 13,
		analogClick : 14,
		ranalogClick : 15,
		dpadUp : 16,
		dpadDown : 17,
		dpadLeft : 18,
		dpadRight : 19,
		names : ["LX","LY","RX","RY","A","B","X","Y","LB","RB","LT","RT","Back","Start","LCLK","RCLK","DUp","DDown","DLeft","DRight"],
	};
	#end

	#if hlsdl
	/**
		Works with both DualShock and XBox controllers
	**/
	public static var CONFIG_SDL = {
		analogX : 0,
		analogY : 1,
		ranalogX : 2,
		ranalogY : 3,
		A : 6,
		B : 7,
		X : 8,
		Y : 9,
		LB : 15,
		RB : 16,
		LT : 4,
		RT : 5,
		back : 10,
		start : 12,
		analogClick : 13,
		ranalogClick : 14,
		dpadUp : 17,
		dpadDown : 18,
		dpadLeft : 19,
		dpadRight : 20,
		names : ["LX","LY","RX","RY","LT","RT","A","B","X","Y","Back",null,"Start","LCLK","RCLK","LB","RB","DUp","DDown","DLeft","DRight"],
	};
	#end

	#if js
	/**
		Standard mapping
	**/
	public static var CONFIG_JS_STD = {
		A : 0,
		B : 1,
		X : 2,
		Y : 3,
		LB : 4,
		RB : 5,
		LT : 6,
		RT : 7,
		back : 8,
		start : 9,
		analogClick : 10,
		ranalogClick : 11,
		dpadUp : 12,
		dpadDown : 13,
		dpadLeft : 14,
		dpadRight : 15,
		analogX : 17,
		analogY : 18,
		ranalogX : 19,
		ranalogY : 20,
		names : ["A","B","X","Y","LB","RB","LT","RT","Select","Start","LCLK","RCLK","DUp","DDown","DLeft","DRight","LX","LY","RX","RY"],
	};
	#end

	#if hl
	public static var ANALOG_BUTTON_THRESHOLDS = { press: 0.3, release: 0.25 };
	#end

	public static var DEFAULT_CONFIG : PadConfig =
		#if hlsdl CONFIG_SDL
		#elseif flash CONFIG_XBOX
		#elseif (hldx || usesys) GameController.CONFIG
		#elseif js  CONFIG_JS_STD
		#else ({}:Dynamic) #end;

	public var connected(default, null) = true;
	public var name(get, never) : String;
	public var index : Int = -1;
	public var xAxis : Float = 0.;
	public var yAxis : Float = 0.;
	public var buttons : Array<Bool> = [];
	public var values : Array<Float> = [];
	var prevButtons : Array<Bool> = [];

	public dynamic function onDisconnect(){
	}

	public function isDown( button : Int ) {
		return buttons[button];
	}

	public function isPressed( button : Int ) {
		return buttons[button] && !prevButtons[button];
	}

	public function isReleased( button : Int ) {
		return !buttons[button] && prevButtons[button];
	}

	public function rumble( strength : Float, time_s : Float ){
		#if hlsdl
		d.rumble( strength, Std.int(time_s*1000.) );
		#elseif (hldx || usesys)
		d.rumble( strength, time_s );
		#end
	}

	function new() {
	}

	function get_name() {
		if( index < 0 ) return "Dummy GamePad";
		#if (flash || hldx || hlsdl || usesys)
		return d.name;
		#elseif js
		return d.id;
		#else
		return "GamePad";
		#end
	}

	/**
		Creates a new dummy unconnected game pad, which can be used instead of checking for null everytime. Use wait() to get real physical game pad access.
	**/
	public static function createDummy() {
		var p = new Pad();
		p.connected = false;
		return p;
	}

	static var waitPad : Pad -> Void;
	static var initDone = false;

	#if flash
	var d : flash.ui.GameInputDevice;
	static var inst : flash.ui.GameInput;
	static var pads : Array<hxd.Pad> = [];
	#elseif js
	var d : js.html.Gamepad;
	static var pads : Map<Int, hxd.Pad> = new Map();
	#elseif (hldx || hlsdl || usesys)
	var d : GameController;
	static var pads : Map<Int, hxd.Pad> = new Map();
	#end

	/**
		Wait until a gamepad gets connected. On some platforms, this might require the user to press a button until it activates
	**/
	public static function wait( onPad : Pad -> Void ) {
		waitPad = onPad;
		#if flash
		if( !initDone ) {
			initDone = true;
			inst = new flash.ui.GameInput();
			inst.addEventListener(flash.events.GameInputEvent.DEVICE_ADDED, function(e:flash.events.GameInputEvent) {
				var p = new Pad();
				pads.push( p );
				p.d = e.device;
				//trace(p.d.name, p.d.id);
				for( i in 0...flash.ui.GameInput.numDevices )
					if( p.d == flash.ui.GameInput.getDeviceAt(i) )
						p.index = i;
				p.d.enabled = true;
				var axisCount = 0;
				var axisX = 0, axisY = 1;
				for( i in 0...p.d.numControls ) {
					var c = p.d.getControlAt(i);
					var cid = c.id;
					var valID = p.values.length;
					var min = c.minValue, max = c.maxValue;
					p.values.push(0.);
					if( StringTools.startsWith(c.id, "AXIS_") ) {
						var axisID = axisCount++;
						c.addEventListener(flash.events.Event.CHANGE, function(_) {
							var v = (c.value - min) * 2 / (max - min) - 1;
							//if( Math.abs(p.values[valID] - v) > 0.1 ) trace(valID, v);
							p.values[valID] = v;
							if( axisID == axisX )
								p.xAxis = v;
							else if( axisID == axisY )
								p.yAxis = -v;
						});
					} else if( StringTools.startsWith(c.id, "BUTTON_") ) {
						c.addEventListener(flash.events.Event.CHANGE, function(_) {
							var v = (c.value - min) / (max - min);
							//if( Math.abs(p.values[valID] - v) > 0.1 ) trace(valID, v);
							p.values[valID] = v;
							p.buttons[valID] = v > 0.5;
						});
					}
				}

				if( waitPad != null ) waitPad(p);
			});
			inst.addEventListener(flash.events.GameInputEvent.DEVICE_REMOVED, function(e:flash.events.GameInputEvent) {
				for( p in pads )
					if( p.d.id == e.device.id ){
						pads.remove( p );
						p.d.enabled = false;
						p.connected = false;
						p.onDisconnect();
						break;
					}
			});
			inst.addEventListener(flash.events.GameInputEvent.DEVICE_UNUSABLE, function(e:flash.events.GameInputEvent) {
				for( p in pads )
					if( p.d.id == e.device.id ){
						pads.remove( p );
						p.d.enabled = false;
						p.connected = false;
						p.onDisconnect();
						break;
					}
			});
			flash.Lib.current.addEventListener(flash.events.Event.EXIT_FRAME, function(_){
				for( p in pads )
					for( i in 0...p.buttons.length )
						p.prevButtons[i] = p.buttons[i];
			});
			var count = flash.ui.GameInput.numDevices; // necessary to trigger added
		}
		#elseif hlsdl
		if( !initDone ) {
			initDone = true;
			var c = @:privateAccess GameController.gctrlCount();
			for( idx in 0...c )
				initPad( idx );
			haxe.MainLoop.add(syncPads);
		}
		#elseif (hldx || usesys)
		if( !initDone ){
			initDone = true;
			GameController.init();
			haxe.MainLoop.add(syncPads);
		}
		#elseif js
		if( !initDone ) {
			initDone = true;
			js.Browser.window.addEventListener("gamepadconnected", function(p) {
				var pad = new hxd.Pad();
				pad.d = p.gamepad;
				pad.index = pad.d.index;
				pads.set(pad.d.index, pad);
				waitPad(pad);
			});
			js.Browser.window.addEventListener("gamepaddisconnected", function(p) {
				var pad = pads.get(p.gamepad.index);
				if( pad == null ) return;
				pads.remove(p.gamepad.index);
				pad.connected = false;
				pad.onDisconnect();
			});
			haxe.MainLoop.add(syncPads);
		}
		#end
	}

	#if hl
	inline function _setButton( btnId : Int, down : Bool ){
		buttons[ btnId ] = down;
		values[ btnId ] = down ? 1 : 0;
	}

	function _detectAnalogButton(index: Int, v: Float) {
		if(v > ANALOG_BUTTON_THRESHOLDS.press && v > values[index]) {
			buttons[ index ] = true;
		}
		if(v < ANALOG_BUTTON_THRESHOLDS.release && v < values[index]) {
			buttons[ index ] = false;
		}
	}
	#end

	#if hlsdl

	inline function _setAxis( axisId : Int, value : Int ){
		var v = value / 0x7FFF;

		_detectAnalogButton(axisId, v);

		// Invert Y axis
		if( axisId == 1 || axisId == 3 )
			values[ axisId ] = -v;
		else
			values[ axisId ] = v;

		if( axisId == 0 )
			xAxis = v;
		else if( axisId == 1 )
			yAxis = v;
	}

	static function initPad( index ){
		var sp = new GameController( index );
		if( @:privateAccess sp.ptr == null )
			return;
		var p = new hxd.Pad();
		p.index = sp.id;
		p.d = sp;
		pads.set( p.index, p );
		for( axis in 0...6 )
			p._setAxis( axis, sp.getAxis(axis) );
		for( button in 0...15 )
			p._setButton( button + 6, sp.getButton(button) );
		waitPad( p );
	}

	static function onEvent( e : Event ){
		var p = pads.get( e.controller );
		switch( e.type ){
			case GControllerAdded:
				if( initDone ){
					if( p != null ){
						pads.remove( p.index );
						p.d.close();
						p.connected = false;
						p.onDisconnect();
					}
					initPad(e.controller);
				}
			case GControllerRemoved:
				if( p != null ){
					pads.remove( p.index );
					p.d.close();
					p.connected = false;
					p.onDisconnect();
				}
			case GControllerDown:
				if( p != null && e.button > -1 )
					p._setButton( e.button + 6, true );
			case GControllerUp:
				if( p != null && e.button > -1 )
					p._setButton( e.button + 6, false );
			case GControllerAxis:
				if( p != null && e.button > -1 && e.button < 6 )
					p._setAxis( e.button, e.value );
			default:
		}
	}

	static function syncPads(){
		for( p in pads )
			for( i in 0...p.buttons.length )
				p.prevButtons[i] = p.buttons[i];
	}

	#elseif (hldx || usesys)

	static function syncPads(){
		GameController.detect(onDetect);
		for( p in pads ){
			p.d.update();
			var k = p.d.getButtons();
			for( i in 0...GameController.NUM_BUTTONS ){
				p.prevButtons[i] = p.buttons[i];
				p._setButton(i, k & (1 << i) != 0);
			}

			for( i in 0...GameController.NUM_AXES ){
				var ii = GameController.NUM_BUTTONS + i;
				var v = p.d.getAxis(i);
				p.prevButtons[ii] = p.buttons[ii];
				p._detectAnalogButton(ii, v);
				p.values[ii] = v;
				if( ii == GameController.CONFIG.analogX )
					p.xAxis = v;
				else if( ii == GameController.CONFIG.analogY )
					p.yAxis = -v;
			}
		}
	}

	static function onDetect( d : GameController, active : Bool ){
		if( active ){
			var p = new hxd.Pad();
			p.d = d;
			p.index = p.d.index;
			pads.set(p.index, p);
			waitPad(p);
		}else{
			for( p in pads ){
				if( p.d == d ){
					pads.remove(p.index);
					p.connected = false;
					p.onDisconnect();
					break;
				}
			}
		}
	}

	#elseif js

	static function syncPads() {
		try js.Browser.navigator.getGamepads() catch( e : Dynamic ) {};
		for( p in pads ) {
			for( i in 0...p.d.buttons.length ) {
				p.prevButtons[i] = p.buttons[i];
				p.buttons[i] = p.d.buttons[i].pressed;
				p.values[i] = p.d.buttons[i].value;
			}
			for( i in 0...p.d.axes.length >> 1 ) {
				var x = p.d.axes[i << 1];
				var y = p.d.axes[(i << 1) + 1]; // y neg !;
				p.values[(i << 1) + p.d.buttons.length] = x;
				p.values[(i << 1) + p.d.buttons.length + 1] = -y;
				if( i == 0 ) {
					p.xAxis = x;
					p.yAxis = y;
				}
			}
		}
	}

	#end

}