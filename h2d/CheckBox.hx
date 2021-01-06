package h2d;

/**
	A simple Interactive checkbox button with a label.

	Useful for fast construction of development UI, but lacks on configurability side.
**/
class CheckBox extends h2d.Flow {
	/**
		When disabled, the user would not be able to change the checkbox state by interacting with it.

		It is still possible to change the `selected` state manually through the code even if checkbox is disabled.
	**/
	public var enable(default,set) : Bool = true;
	/**
		Current toggle state of the checkbox.

		Note that changing the state from the code will cause `CheckBox.onChange` to trigger.
	**/
	public var selected(default,set) : Bool = false;
	/**
		Optional text label that will be shown to the right of the checkbox.
	**/
	public var text(default,set) : String = "";

	var tf : h2d.Text;
	var select : h2d.Bitmap;

	/**
		Create a new CheckBox instance.
		@param parent An optional parent `h2d.Object` instance to which CheckBox adds itself if set.
	**/
	public function new(?parent) {
		super(parent);
		padding = 0;
		verticalAlign = Middle;
		horizontalSpacing = 5;
		borderHeight = borderWidth = 1;

		var width = 13;
		var box = new h2d.Flow(this);

		var t = h2d.Tile.fromColor(0x404040, width, width);
		new h2d.Bitmap(t, box);

		var borderWidth = borderLeft + borderRight;
		var borderHeight = borderTop + borderBottom;
		var t = h2d.Tile.fromColor(0, width - borderWidth * 2, width - borderHeight * 2);
		var bg = new h2d.Bitmap(t, box);
		bg.x = borderWidth;
		bg.y = borderHeight;
		box.getProperties(bg).isAbsolute = true;

		var t = h2d.Tile.fromColor(0x404040, width - (borderWidth + 1) * 2, width - (borderHeight + 1) * 2);
		select = new h2d.Bitmap(t, box);
		select.x = borderWidth + 1;
		select.y = borderHeight + 1;
		box.getProperties(select).isAbsolute = true;

		tf = new h2d.Text(hxd.res.DefaultFont.get(), this);
		getProperties(tf).offsetY = -2;

		//
		enableInteractive = true;
		interactive.cursor = Button;
		interactive.onClick = function(e) {
			if( enable )
				selected = !selected;
		}

		enable = true;
		selected = false;
		needReflow = true;
	}

	function set_text(str : String) {
		if(tf != null)
			tf.text = str;
		return text = str;
	}

	function set_enable(b) {
		alpha = b ? 1 : 0.6;
		return enable = b;
	}

	function set_selected(s) {
		needReflow = true;
		selected = s;
		select.visible = s;
		onChange();
		return selected;
	}

	/**
		Sent when the `CheckBox.selected` state is changed.
		Can be triggered both by user interaction (when checkbox is enabled) and from the software side by changing `selected` directly.
	**/
	public dynamic function onChange() {
	}
}
