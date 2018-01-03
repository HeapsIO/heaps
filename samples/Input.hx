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
	//	input.inputWidth = 100;

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

		input.onChange = function() {
			while( input.text.length > 20 )
				input.text = input.text.substr(0, -1);
		}
	}

	override function update(dt:Float) {
		// check special keys state
		var keys = [
			{ name : "Ctrl", id : hxd.Key.CTRL },
			{ name : "Alt", id : hxd.Key.ALT },
			{ name : "Shift", id : hxd.Key.SHIFT },
			{ name : "LCtrl", id : hxd.Key.LCTRL },
			{ name : "LAlt", id : hxd.Key.LALT },
			{ name : "LShift", id : hxd.Key.LSHIFT },
			{ name : "RCtrl", id : hxd.Key.RCTRL },
			{ name : "RAlt", id : hxd.Key.RALT },
			{ name : "RShift", id : hxd.Key.RSHIFT },
			{ name : "Enter", id : hxd.Key.ENTER },
			{ name : "NumpadEnter", id : hxd.Key.NUMPAD_ENTER },
		];
		debug.text = "Cursor: " + input.cursorIndex + ", Sel: " + input.getSelectedText()+", Down: "+[for( k in keys ) if( hxd.Key.isDown(k.id) ) k.name].join(",");
	}

	static function main() {
		new Input();
	}

}