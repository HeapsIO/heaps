package h2d.comp;

class Color extends Component {

	var input : h2d.Interactive;
	public var value(default, set) : Int;

	public function new(?parent) {
		super("color", parent);
		input = new h2d.Interactive(0, 0, bg);
		var active = false;
		input.onPush = function(_) {
			active = true;
		};
		input.onOver = function(_) {
			addClass(":hover");
		};
		input.onOut = function(_) {
			active = false;
			removeClass(":hover");
		};
		input.onRelease = function(_) {
			if( active ) selectColor();
		};
		value = 0;
	}

	function set_value(v) {
		needRebuild = true;
		return value = v;
	}

	override function resize( ctx : Context ) {
		super.resize(ctx);
		if( !ctx.measure ) {
			input.width = width - (style.marginLeft + style.marginRight);
			input.height = height - (style.marginTop + style.marginBottom);
			bg.fillRectColor(extLeft() - style.marginLeft, extTop() - style.marginTop, contentWidth, contentHeight, 0xFF000000 | value);
		}
	}

	function selectColor() {
		var p : Component = this;
		while( p.parentComponent != null )
			p = p.parentComponent;
		var b = new Box(p);
		b.toggleClass("modal", true);
		var pick = new ColorPicker(b);
		pick.color = value;
		pick.addStyleString("dock:full");
		pick.onChange = function(c) {
			value = c;
			onChange(c);
		};
		pick.onClose = function() {
			b.remove();
		};
	}

	public dynamic function onChange( color : Int ) {
	}

}