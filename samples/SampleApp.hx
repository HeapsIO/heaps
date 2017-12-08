class SampleApp extends hxd.App {

	var fui : h2d.Flow;

	override function init() {
		fui = new h2d.Flow(s2d);
		fui.isVertical = true;
		fui.verticalSpacing = 5;
		fui.padding = 10;
	}

	#if hxbit
	override function mainLoop() {
		if( hxd.Key.isDown(hxd.Key.CTRL) && hxd.Key.isPressed("S".code) ) {
			var bytes = s3d.serializeScene();
			hxd.File.saveBytes("scene.hsd", bytes);
		}
		super.mainLoop();
	}
	#end

	function getFont() {
		return hxd.res.DefaultFont.get();
	}

	function addButton( label : String, onClick : Void -> Void ) {
		var f = new h2d.Flow(fui);
		f.padding = 5;
		f.paddingBottom = 7;
		f.backgroundTile = h2d.Tile.fromColor(0x404040);
		var tf = new h2d.Text(getFont(), f);
		tf.text = label;
		f.enableInteractive = true;
		f.interactive.cursor = Button;
		f.interactive.onClick = function(_) onClick();
		f.interactive.onOver = function(_) f.backgroundTile = h2d.Tile.fromColor(0x606060);
		f.interactive.onOut = function(_) f.backgroundTile = h2d.Tile.fromColor(0x404040);
		return f;
	}

	function addSlider( label : String, get : Void -> Float, set : Float -> Void, min : Float = 0., max : Float = 1. ) {
		var f = new h2d.Flow(fui);

		f.horizontalSpacing = 5;

		var tf = new h2d.Text(getFont(), f);
		tf.text = label;
		tf.maxWidth = 70;
		tf.textAlign = Right;

		var sli = new h2d.Slider(100, 10, f);
		sli.minValue = min;
		sli.maxValue = max;
		sli.value = get();

		var tf = new h2d.TextInput(getFont(), f);
		tf.text = "" + hxd.Math.fmt(sli.value);
		sli.onChange = function() {
			set(sli.value);
			tf.text = "" + hxd.Math.fmt(sli.value);
			f.needReflow = true;
		};
		tf.onChange = function() {
			var v = Std.parseFloat(tf.text);
			if( Math.isNaN(v) ) return;
			sli.value = v;
			set(v);
		};
		return sli;
	}

	function addCheck( label : String, get : Void -> Bool, set : Bool -> Void ) {
		var f = new h2d.Flow(fui);

		f.horizontalSpacing = 5;

		var tf = new h2d.Text(getFont(), f);
		tf.text = label;
		tf.maxWidth = 70;
		tf.textAlign = Right;

		var size = 10;
		var b = new h2d.Graphics(f);
		function redraw() {
			b.clear();
			b.beginFill(0x808080);
			b.drawRect(0, 0, size, size);
			b.beginFill(0);
			b.drawRect(1, 1, size-2, size-2);
			if( get() ) {
				b.beginFill(0xC0C0C0);
				b.drawRect(2, 2, size-4, size-4);
			}
		}
		var i = new h2d.Interactive(size, size, b);
		i.onClick = function(_) {
			set(!get());
			redraw();
		};
		redraw();
		return i;
	}

	function addText(text="") {
		var tf = new h2d.Text(getFont(), fui);
		tf.text = text;
		return tf;
	}

}
