package hxd;

class Pad {

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


	public var connected(default, null) = true;
	public var name(get, never) : String;
	public var index : Int = -1;
	public var xAxis : Float = 0.;
	public var yAxis : Float = 0.;
	public var buttons : Array<Bool> = [];
	public var values : Array<Float> = [];
	
	public dynamic function onDisconnect(){
	}

	function new() {
	}

	function get_name() {
		if( index < 0 ) return "Dummy GamePad";
		#if (flash || hlsdl)
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
	#elseif hlsdl
	var d : sdl.GameController;
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
		#elseif hlsdl
		waitPad = onPad;
		if( !initDone ) {
			initDone = true;
			var c = @:privateAccess sdl.GameController.gctrlCount();
			for( idx in 0...c )
				initPad( idx );
		}
		#end
	}
	
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
	
	inline function _setButton( btnId : Int, down : Bool ){
		buttons[ btnId+6 ] = down;
		values[ btnId+6 ] = down ? 1 : 0;
	}
	
	static function initPad( index ){
		var sp = new sdl.GameController( index );
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
	
	static function onEvent( e : sdl.Event ){
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
					p._setButton( e.button, true );
			case GControllerUp:
				if( p != null && e.button > -1 )
					p._setButton( e.button, false );
			case GControllerAxis:
				if( p != null && e.button > -1 && e.button < 6 )
					p._setAxis( e.button, e.value );
			default:
		}
		
	}
	#end

}