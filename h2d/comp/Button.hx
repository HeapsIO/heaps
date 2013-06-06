package h2d.comp;

class Button extends Component {
	
	var input : h2d.Interactive;
	var bg : Fill;
	var tf : h2d.Text;
	
	public var text(default, set) : String;
	
	public function new(text, ?parent) {
		super("button",parent);
		bg = new Fill(this);
		input = new h2d.Interactive(0, 0, bg);
		var active = false, out = false;
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
			if( active ) onClick();
		};
		tf = new h2d.Text(null, bg);
		this.text = text;
	}

	function get_text() {
		return tf.text;
	}
	
	function set_text(t) {
		needRebuild = true;
		return text = t;
	}
	
	override function rebuild() {
		evalStyle();
		tf.font = getFont();
		tf.textColor = style.color;
		tf.text = text;
		tf.filter = true;
		bg.x = style.offsetX;
		bg.y = style.offsetY;
		innerWidth = tf.textWidth + style.paddingLeft + style.paddingRight + style.borderSize * 2;
		innerHeight = tf.textHeight + style.paddingTop + style.paddingBottom + style.borderSize * 2;
		if( style.width != null ) innerWidth = style.width;
		if( style.height != null ) innerHeight = style.height;
		tf.x = style.paddingLeft + style.borderSize;
		tf.y = style.paddingTop + style.borderSize;
		input.width = innerWidth;
		input.height = innerHeight;
		bg.reset();
		bg.lineRect(style.borderColor, 0, 0, innerWidth, innerHeight, style.borderSize);
		bg.fillRect(style.backgroundColor, style.borderSize, style.borderSize, innerWidth - style.borderSize * 2, innerHeight - style.borderSize * 2);
	}
	
	public dynamic function onClick() {
	}
	
}