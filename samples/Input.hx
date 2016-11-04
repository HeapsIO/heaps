class Input extends hxd.App {

	var input : h2d.TextInput;

	override function init() {

		input = new h2d.TextInput(hxd.res.DefaultFont.get(), s2d);
		input.interactive.backgroundColor = 0x80808080;
		input.inputWidth = 100;

		input.text = "Click to edit";
		input.textColor = 0xAAAAAA;

		input.scale(2);
		input.x = input.y = 50;

		input.interactive.onFocus = function(_) {
			//input.text = "";
			input.textColor = 0xFFFFFF;
			input.interactive.onFocus = function(_) {};
		}

	}

	static function main() {
		new Input();
	}

}