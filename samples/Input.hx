class Input extends hxd.App {

	var input : h2d.TextInput;
	var debug : h2d.Text;

	override function init() {

		engine.backgroundColor = 0x202020;

		var font = hxd.res.DefaultFont.get();
		var console = new h2d.Console(font, s2d);
		console.addCommand("hello", "Prints the correct answer", [], function() console.log("World", 0xFF00FF));

		debug = new h2d.Text(font, s2d);
		debug.x = debug.y = 5;

		input = new h2d.TextInput(font, s2d);
		input.backgroundColor = 0x80808080;
		input.inputWidth = 100;

		input.text = "Click to édit";
		input.textColor = 0xAAAAAA;

		input.scale(2);
		input.x = input.y = 50;

		input.onFocus = function(_) {
			input.textColor = 0xFFFFFF;
		}
		input.onFocusLost = function(_) {
			input.textColor = 0xAAAAAA;
		}
	}

	override function update(dt:Float) {
		debug.text = "Cursor: " + input.cursorIndex + ", Sel: " + input.getSelectedText();
	}

	static function main() {
		new Input();
	}

}