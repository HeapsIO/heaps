package h2d.comp;

class Checkbox extends Interactive {

	public var checked(default, set) : Bool;

	public function new(?parent) {
		super("checkbox", parent);
		checked = false;
	}

	function set_checked(b) {
		toggleClass(":checked", b);
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

	override function onClick() {
		checked = !checked;
		onChange(checked);
	}

	public dynamic function onChange( checked : Bool ) {
	}

}