package h2d.comp;
import hxd.Key;

@:access(h2d.comp.Input.scene)
class Input extends Interactive {

	var tf : h2d.Text;
	var cursor : h2d.Bitmap;
	var cursorPos(default, set) : Int;
	public var smooth = true;
	public var value(default, set) : String;

	public function new(?parent) {
		super("input",parent);
		tf = new h2d.Text(null, this);
		input.cursor = TextInput;
		cursor = new h2d.Bitmap(null, bg);
		cursor.visible = false;
		var ctrlDown = false;
		input.onFocus = function(_) {
			ctrlDown = false;
			addClass(":focus");
			cursor.visible = true;
			onFocus();
		};
		input.onFocusLost = function(_) {
			removeClass(":focus");
			cursor.visible = false;
			onBlur();
		};
		input.onKeyDown = function(e:hxd.Event) {
			if( input.hasFocus() ) {
				// BACK
				switch( e.keyCode ) {
				case Key.LEFT:
					if( cursorPos > 0 )
						cursorPos--;
				case Key.RIGHT:
					if( cursorPos < value.length )
						cursorPos++;
				case Key.HOME:
					cursorPos = 0;
				case Key.END:
					cursorPos = value.length;
				case Key.DELETE:
					value = value.substr(0, cursorPos) + value.substr(cursorPos + 1);
					onChange(value);
					return;
				case Key.BACKSPACE:
					if( cursorPos > 0 ) {
						value = value.substr(0, cursorPos - 1) + value.substr(cursorPos);
						cursorPos--;
						onChange(value);
					}
					return;
				case Key.ENTER:
					input.blur();
					return;
				case Key.CTRL:
					ctrlDown = true;
				}
				if( ctrlDown ) {
					switch( e.keyCode ) {
					case "V".code:
						/*var clip = hxd.System.getClipboard();
						if( clip != "" ) {
							clip = clip.split("\t").join(" ").split("\r\n").join(" ").split("\r").join(" ").split("\n").join(" ");
							value = value.substr(0, cursorPos) + clip + value.substr(cursorPos);
							cursorPos += clip.length;
							onChange(value);
						}*/
					default:
					}
					return;
				}
				if( e.charCode != 0 ) {
					value = value.substr(0, cursorPos) + String.fromCharCode(e.charCode) + value.substr(cursorPos);
					cursorPos++;
					onChange(value);
				}
			}
		};
		input.onKeyUp = function(e:hxd.Event) {
			if( e.keyCode == Key.CTRL ) ctrlDown = false;
		};
		this.value = "";
	}

	function set_cursorPos(v:Int) {
		textAlign(tf);
		cursor.x = tf.x + tf.calcTextWidth(value.substr(0, v)) + extLeft();
		if( cursor.x > width - 4 ) {
			var dx = cursor.x - (width - 4);
			tf.x -= dx;
			cursor.x -= dx;
		}
		return cursorPos = v;
	}

	public function focus() {
		input.focus();
		cursorPos = value.length;
	}

	function get_value() {
		return tf.text;
	}

	function set_value(t) {
		needRebuild = true;
		return value = t;
	}

	override function resize( ctx : Context ) {
		if( ctx.measure ) {
			tf.font = getFont();
			tf.textColor = style.color;
			tf.text = value;
			tf.smooth = smooth;
			textAlign(tf);
			contentWidth = tf.textWidth;
			contentHeight = tf.textHeight;
			if( cursorPos < 0 ) cursorPos = 0;
			if( cursorPos > value.length ) cursorPos = value.length;
			cursorPos = cursorPos;
		}
		super.resize(ctx);
		if( !ctx.measure ) {
			cursor.y = extTop() - 1;
			cursor.tile = h2d.Tile.fromColor(style.cursorColor, 1, Std.int(height - extTop() - extBottom() + 2));
		}
	}

	override function onClick() {
		focus();
	}

	public dynamic function onChange( value : String ) {
	}

	public dynamic function onFocus() {
	}

	public dynamic function onBlur() {
	}

}
