package h2d.comp;

class Slider extends Component {
	
	var cursor : Button;
	var input : h2d.Interactive;
	public var minValue : Float = 0.;
	public var maxValue : Float = 1.;
	public var value(default, set) : Float;
	
	@:access(h2d.comp.Button)
	public function new(?parent) {
		super("slider", parent);
		cursor = new Button("", this);
		cursor.input.cancelEvents = true;
		cursor.onMouseDown = function() {
			
		};
		input = new h2d.Interactive(0, 0, this);
		input.onPush = function(e) {
			gotoValue(pixelToVal(e));
			input.startDrag(function(e) {
				if( e.kind == EMove )
					gotoValue(pixelToVal(e));
			});
		};
		input.onRelease = function(_) {
			input.stopDrag();
		}
		value = 0.;
	}
	
	function pixelToVal( e : hxd.Event ) {
		return (Std.int(e.relX - (style.borderSize + cursor.width * 0.5) ) / (input.width - (style.borderSize * 2 + cursor.width))) * (maxValue - minValue) + minValue;
	}
	
	function gotoValue( v : Float ) {
		if( v < minValue ) v = minValue;
		if( v > maxValue ) v = maxValue;
		if( v == value )
			return;
		var dv = Math.abs(value - v);
		if( style.maxIncrement != null && dv > style.maxIncrement ) {
			if( v > value )
				value += style.maxIncrement;
			else
				value -= style.maxIncrement;
		} else if( style.increment != null )
			value = Math.round(v / style.increment) * style.increment;
		else
			value = v;
		onChange(value);
	}
	
	function set_value(v:Float) {
		if( v < minValue ) v = minValue;
		if( v > maxValue ) v = maxValue;
		value = v;
		needRebuild = true;
		return v;
	}

	override function resize( ctx : Context ) {
		super.resize(ctx);
		if( !ctx.measure ) {
			input.width = width - (style.marginLeft + style.marginRight) + cursor.width;
			input.height = cursor.height - (cursor.style.marginTop + cursor.style.marginBottom);
			input.x = cursor.style.marginLeft - style.borderSize - cursor.width * 0.5;
			input.y = cursor.style.marginTop;
			cursor.style.offsetX = contentWidth * (value - minValue) / (maxValue - minValue) - cursor.width * 0.5;
		}
	}

	public dynamic function onChange( value : Float ) {
	}

}