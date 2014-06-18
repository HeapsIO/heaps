package h2d.comp;

class Value extends Interactive {

	var text : Input;
	public var minValue : Float = -1e10;
	public var maxValue : Float = 1e10;
	public var value(default, set) : Float;
	public var increment : Float;

	public function new(?parent) {
		super("value", parent);
		text = new Input(this);
		text.input.cursor = Move;
		text.onChange = function(v) {
			var v = Std.parseFloat(v);
			if( !Math.isNaN(v) ) {
				var old = text;
				text = null;
				value = v;
				text = old;
				onChange(value);
			}
		};
		text.input.onPush = function(e1) {
			text.active = true;
			if( text.hasClass(":focus") )
				return;
			var startVal = value;
			var startX = e1.relX;
			text.input.startDrag(function(e) {
				if( e.kind == ERelease )
					text.input.stopDrag();
				else {
					var dx = Math.round(e.relX - startX);
					var v = startVal + dx * increment;
					if( v < minValue ) v = minValue;
					if( v > maxValue ) v = maxValue;
					value = v;
					onChange(value);
				}
			});
		};
		text.onFocus = function() {
			text.input.stopDrag();
			text.input.cursor = TextInput;
		};
		text.onBlur = function() {
			value = value;
			text.input.cursor = Move;
		};
		value = 0;
		increment = 0.1;
	}

	function set_value(v:Float) {
		if( text != null ) text.value = ""+hxd.Math.fmt(v);
		return value = v;
	}

	override function resize( ctx : Context ) {
		if( ctx.measure ) {
			text.resize(ctx);
			contentWidth = text.width;
			contentHeight = text.height;
		}
		super.resize(ctx);
	}

	public dynamic function onChange( value : Float ) {
	}

}