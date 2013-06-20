package h2d.comp;

class Checkbox extends Component {
	
	var input : h2d.Interactive;
	public var checked(default, set) : Bool;
	
	public function new(?parent) {
		super("checkbox", parent);
		input = new h2d.Interactive(0, 0, this);
		var active = false;
		input.onPush = function(_) {
			active = true;
		};
		input.onOut = function(_) {
			active = false;
		};
		input.onRelease = function(_) {
			if( active ) {
				checked = !checked;
				onChange(checked);
			}
		};
		checked = false;
	}
	
	function set_checked(b) {
		setClass(":checked", b);
		return checked = b;
	}
	
	override function resize( ctx : Context ) {
		super.resize(ctx);
		if( !ctx.measure ) {
			input.width = width - (style.marginLeft + style.marginRight);
			input.height = height - (style.marginTop + style.marginBottom);
			if( checked ) {
				var m = style.borderSize + style.tickSpacing;
				bg.fillRect(style.tickColor, m, m, input.width - m * 2, input.height - m * 2);
			}
		}
	}
	
	public dynamic function onChange( checked : Bool ) {
	}
	
}