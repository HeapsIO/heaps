package h2d.comp;

class Button extends Component {
	
	var input : h2d.Interactive;
	var bg : h2d.TileColorGroup;
	var tf : h2d.Text;
	
	public var text(default, set) : String;
	
	public function new(text, ?parent) {
		super("button",parent);
		input = new h2d.Interactive(0, 0, this);
		var active = false, out = false;
		input.onPush = function(_) {
			active = true;
		};
		input.onOut = function(_) {
			active = false;
		};
		input.onRelease = function(_) {
			if( active ) onClick();
		};
		bg = new h2d.TileColorGroup(h2d.Tile.fromColor(0xFFFFFFFF), this);
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
	
	override function rebuild() {
		evalStyle();
		tf.font = getFont();
		tf.text = text;
		tf.filter = true;
		
		var ext = style.padding + style.borderSize;
		innerWidth = tf.textWidth + ext * 2;
		innerHeight = tf.textHeight + ext * 2;
		if( style.width != null ) innerWidth = style.width;
		if( style.height != null ) innerHeight = style.height;
		tf.x = (innerWidth - tf.textWidth) * 0.5;
		tf.y = (innerHeight - tf.textHeight) * 0.5;
		input.width = innerWidth;
		input.height = innerHeight;
		bg.reset();
		bg.rectColor(0, 0, innerWidth, innerHeight, style.borderColor | 0xFF000000);
		switch( style.backgroundColor ) {
		case Color(c):
			bg.rectColor(style.borderSize, style.borderSize, innerWidth - style.borderSize * 2, innerHeight - style.borderSize * 2, c);
		case Gradient(a, b, c, d):
			bg.rectGradient(style.borderSize, style.borderSize, innerWidth - style.borderSize * 2, innerHeight - style.borderSize * 2, a, b, c, d);
		}
	}
	
	public dynamic function onClick() {
	}
	
}