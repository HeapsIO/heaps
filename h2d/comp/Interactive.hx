package h2d.comp;

class Interactive extends Component {
	
	var input : h2d.Interactive;
	
	function new(kind,?parent) {
		super(kind,parent);
		input = new h2d.Interactive(0, 0, bg);
		var active = false;
		input.onPush = function(_) {
			active = true;
			onMouseDown();
		};
		input.onOver = function(_) {
			addClass(":hover");
			onMouseOver();
		};
		input.onOut = function(_) {
			active = false;
			removeClass(":hover");
			onMouseOut();
		};
		input.onRelease = function(_) {
			if( active ) onClick();
			onMouseUp();
		};
	}
	
	override function resize( ctx : Context ) {
		super.resize(ctx);
		if( !ctx.measure ) {
			input.width = width - (style.marginLeft + style.marginRight);
			input.height = height - (style.marginTop + style.marginBottom);
		}
	}
	
	public dynamic function onMouseOver() {
	}

	public dynamic function onMouseOut() {
	}
	
	public dynamic function onMouseDown() {
	}

	public dynamic function onMouseUp() {
	}
	
	public dynamic function onClick() {
	}
	
	
}