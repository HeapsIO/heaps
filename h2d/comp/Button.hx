package h2d.comp;

class Button extends Component {
	
	var input : h2d.Interactive;
	var tf : h2d.Text;
	
	public var text(default, set) : String;
	
	public function new(text, ?parent) {
		super("button",parent);
		input = new h2d.Interactive(0, 0, bg);
		var active = false, out = false;
		input.onPush = function(_) {
			active = true;
			onMouseDown();
		};
		input.onOver = function(_) {
			addClass(":hover");
		};
		input.onOut = function(_) {
			active = false;
			removeClass(":hover");
		};
		input.onRelease = function(_) {
			if( active ) onClick();
			onMouseUp();
		};
		tf = new h2d.Text(null, this);
		this.text = text;
	}

	function get_text() {
		return tf.text;
	}
	
	function set_text(t) {
		needRebuild = true;
		return text = t;
	}
	
	override function resize( r : CssDefs.Resize ) {
		if( r.measure ) {
			tf.font = getFont();
			tf.textColor = style.color;
			tf.text = text;
			tf.filter = true;
			contentWidth = tf.textWidth;
			contentHeight = tf.textHeight;
			super.resize(r);
		} else {
			super.resize(r);
			input.width = width - (style.marginLeft + style.marginRight);
			input.height = height - (style.marginTop + style.marginBottom);
		}
	}
		
	public dynamic function onMouseDown() {
	}

	public dynamic function onMouseUp() {
	}
	
	public dynamic function onClick() {
	}
	
}