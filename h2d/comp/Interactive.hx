package h2d.comp;

class Interactive extends Component {

	var input : h2d.Interactive;
	var active : Bool;
	var activeRight : Bool;

	function new(kind,?parent) {
		super(kind,parent);
		input = new h2d.Interactive(0, 0, bg);
		input.enableRightButton = true;
		active = false;
		activeRight = false;
		input.onPush = function(e) {
			switch( e.button ) {
			case 0:
				active = true;
				onMouseDown();
			case 1:
				activeRight = true;
			}
		};
		input.onOver = function(_) {
			addClass(":hover");
			onMouseOver();
		};
		input.onOut = function(_) {
			active = false;
			activeRight = false;
			removeClass(":hover");
			onMouseOut();
		};
		input.onRelease = function(e) {
			switch( e.button ) {
			case 0:
				if( active ) {
					active = false;
					onClick();
				}
				onMouseUp();
			case 1:
				if( activeRight ) {
					activeRight = false;
					onRightClick();
				}
			}
		};
	}

	override function resize( ctx : Context ) {
		super.resize(ctx);
		if( !ctx.measure ) {
			input.width = width - (style.marginLeft + style.marginRight);
			input.height = height - (style.marginTop + style.marginBottom);
			input.visible = !hasClass(":disabled");
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

	public dynamic function onRightClick() {
	}

}