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

	public var connected(default, null) = true;
	public var name(get, never) : String;
	public var index : Int = -1;
	public var xAxis : Float = 0.;
	public var yAxis : Float = 0.;
	public var buttons : Array<Bool> = [];
	public var values : Array<Float> = [];

	function new() {
	}

	function get_name() {
		if( index < 0 ) return "Dummy GamePad";
		#if flash
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
				p.d = e.device;
				trace(p.d.name, p.d.id);
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
			var count = flash.ui.GameInput.numDevices; // necessary to trigger added
		}
		#else
		#end
	}

}