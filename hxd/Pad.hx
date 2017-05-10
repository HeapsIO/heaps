package hxd;

#if hl
#if hlsdl
import sdl.Event;
import sdl.GameController;
#elseif psgl
import psgl.GameController;
#else
private typedef Event = {
}
private class GameController {
	public var name : String;
}
#end
#end

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
		names : ["LX","LY","RX","RY","A","B","X","Y","LB","RB","LT","RT","Select","Start","LCLK","RCLK","DUp","DDown","DLeft","DRight"],
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
		names : ["LX","LY","RX","RY","LT","RT","A","B","X","Y","Select","Guide","Start","LCLK","RCLK","LB","RB","DUp","DDown","DLeft","DRight"],
	};
	#elseif psgl

	public static var CONFIG_PS4 = {

		// unused
		start : 0,
		back : 0,
		// ----

		analogX : 16,
		analogY : 17,
		ranalogX : 18,
		ranalogY : 19,

		A : 14,
		B : 13,
		X : 15,
		Y : 12,
		LB : 10,
		RB : 11,
		LT : 8,
		RT : 9,
		analogClick : 1,
		ranalogClick : 2,
		options : 3, // only on PS4
		dpadUp : 4,
		dpadDown : 6,
		dpadLeft : 7,
		dpadRight : 5,
		names : [null,null,"LCLK","RCLK","Option","DUp","DRight","DDown","DLeft","L2","R2","L1","R1","Triangle","Circle","Cross","Square","LX","LY","RX","RY","Touchpad"],
	};

	#end

	public static var DEFAULT_CONFIG =
		#if hlsdl CONFIG_SDL
		#elseif psgl CONFIG_PS4
		#elseif flash CONFIG_XBOX
		#else {} #end;

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

	function new() {
	}

	function get_name() {
		if( index < 0 ) return "Dummy GamePad";
		#if (flash || hl)
		return d.name;
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

	#if flash
	var d : flash.ui.GameInputDevice;
	static var waitPad : Pad -> Void;
	static var initDone = false;
	static var inst : flash.ui.GameInput;
	static var pads : Array<hxd.Pad> = [];
	#elseif hl
	var d : GameController;
	static var waitPad : Pad -> Void;
	static var initDone = false;
	static var pads : Map<Int, hxd.Pad> = new Map();
	#end

	/**
		Wait until a gamepad gets connected. On some platforms, this might require the user to press a button until it activates
	**/
	public static function wait( onPad : Pad -> Void ) {
		#if flash
		waitPad = onPad;
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
			var count = flash.ui.GameInput.numDevices; // necessary to trigger added
		}
		#elseif (hlsdl || psgl)
		waitPad = onPad;
		if( !initDone ) {
			initDone = true;
			#if psgl
			haxe.MainLoop.add(syncPads);
			#end
			var c = @:privateAccess GameController.gctrlCount();
			for( idx in 0...c )
				initPad( idx );
		}
		#end
	}

	#if hl
	inline function _setButton( btnId : Int, down : Bool ){
		buttons[ btnId ] = down;
		values[ btnId ] = down ? 1 : 0;
	}
	#end

	#if hlsdl

	inline function _setAxis( axisId : Int, value : Int ){
		var v = value / 0x7FFF;

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
			p._setButton( button, sp.getButton(button) );
		waitPad( p );
	}

	static function onEvent( e : Event ){
		var p = pads.get( e.controller );
		switch( e.type ){
			case GControllerAdded:
				if( initDone )
					initPad(e.controller);
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
	#elseif psgl

	function sync() {
		for( i in 0...buttons.length )
			prevButtons[i] = buttons[i];
		var s = d.getState();
		if( s == null )
			return;
		var k = s.buttons;
		for( i in 1...21 )
			_setButton(i, k & (1 << i) != 0);
		for( i in 0...4 )
			values[16 + i] = (s.getAxis(i) - 0.5) * 2;
		xAxis = values[16];
		yAxis = values[17];
		if( buttons[4] ) yAxis = -1;
		if( buttons[6] ) yAxis = 1;
		if( buttons[7] ) xAxis = -1;
		if( buttons[5] ) xAxis = 1;
		// L2 / R2
		values[8] = s.getAxis(5);
		values[9] = s.getAxis(6);
	}

	static function syncPads() {
		for( p in pads )
			p.sync();
	}

	static function initPad( index ) {
		var sp = new GameController( index );
		if( @:privateAccess sp.ptr < 0 )
			return;
		var p = new hxd.Pad();
		p.index = index;
		p.d = sp;
		p.sync();
		pads.set( p.index, p );
		waitPad( p );
	}

	#end

}