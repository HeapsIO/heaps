package h2d.comp;

class Label extends Component {
	
	var tf : h2d.Text;
	
	public var text(default, set) : String;
	
	public function new(text, ?parent) {
		super("label",parent);
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
		}
		super.resize(r);
	}
	
}