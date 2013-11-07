package h2d.comp;

class Value extends Interactive {

	var text : Input;
	public var value(default, set) : Float;
	public var increment : Float;
	
	public function new(?parent) {
		super("value", parent);
		text = new Input(this);
		text.input.cursor = Move;
		text.onChange = function(v) {
			var v = Std.parseFloat(v);
			if( !Math.isNaN(v) ) {
				value = v;
				onChange(value);
			}
		};
		text.input.onPush = function(e1) {
			text.active = true;
			if( text.hasClass(":focus") )
				return;
			var startVal = value;
			text.input.startDrag(function(e) {
				if( e.kind == ERelease )
					text.input.stopDrag();
				else {
					var dx = Math.round(e.relX - e1.relX);
					value = startVal + dx * increment;
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
		text.value = ""+hxd.Math.fmt(v);
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