package h2d;

class CheckBox extends h2d.Flow {

	public var enable(default,set) : Bool = true;
	public var selected(default,set) : Bool = false;
	public var text(default,set) : String = "";

	var tf : h2d.Text;
	var select : h2d.Bitmap;

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

	public dynamic function onChange() {
	}
}