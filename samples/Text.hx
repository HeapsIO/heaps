import h2d.Drawable;
import h2d.Flow;
import h2d.Font;
import h2d.Graphics;
import h2d.Object;
import h2d.Text.Align;

// Use both text_res and res folders.
//PARAM=-D resourcesPath=../../text_res;../../res
class TextWidget extends Object
{
	public var align: Align;
	public var textField: h2d.Text;
	public var back: Graphics;

	public function new(parent:h2d.Scene, font: Font, str:String, align:h2d.Text.Align){
		super(parent);
		this.align = align;
		back = new Graphics(this);

		var tf = new h2d.Text(font, this);
		tf.textColor = 0xffffff;
		tf.textAlign = align;
		tf.text = str;
		textField = tf;

		refreshBounds();
	}

	public function refreshBounds() {
		back.clear();

		var bounds = textField.getBounds(this);
		var size = textField.getSize();

		back.beginFill(0x5050ff,  0.5);
		back.drawRect(bounds.x, 0, size.width, size.height);
		back.endFill();

		back.lineStyle(1, 0x50ff50);
		back.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);

		back.lineStyle(1, 0xff5050);
		back.moveTo(bounds.x, 0);
		back.lineTo(bounds.x + textField.textWidth, 0);
		back.moveTo(bounds.x, 0);
		back.lineTo(bounds.x, textField.textHeight);
	}

	public function setMaxWidth(w:Int) {
		textField.maxWidth = w;
		refreshBounds();
	}
}

class Text extends hxd.App {

	var textWidgets:Array<TextWidget> = [];
	var resizeWidgets: Array<TextWidget> = [];
	var sdfText:h2d.Text;

	override function init() {

		// Enable global scaling
		// s2d.scale(1.25);

		var font = hxd.res.DefaultFont.get();
		// var font = hxd.Res.customFont.toFont();

		var multilineText = "This is a multiline text.\nLorem ipsum dolor";
		var singleText = "Hello simple text";

		var xpos = 0;
		var yoffset = 10.0;

		function createWidget(str:String, align:h2d.Text.Align) {
			var w = new TextWidget(s2d, font, str, align);
			w.x = xpos;
			w.y = yoffset;
			textWidgets.push(w);
			return w;
		}

		// Static single and multiline widgets
		xpos += 450;
		for (a in [Align.Left, Align.Center, Align.Right, Align.MultilineCenter, Align.MultilineRight]) {
			var w = createWidget("", a);
			var label = new h2d.Text(font, w);
			label.text = Std.string(a);
			label.x = 5;
			label.alpha = 0.5;
			yoffset += w.textField.textHeight + 10;
			var w = createWidget(singleText, a);
			yoffset += w.textField.textHeight + 10;
			var w = createWidget(multilineText, a);
			yoffset += w.textField.textHeight + 10;
		}

		// Resized widgets
		xpos += 200;
		yoffset = 10;
		var longText = "Lorem ipsum dolor sit amet, fabulas repudiare accommodare nec ut. Ut nec facete maiestatis, partem debitis eos id, perfecto ocurreret repudiandae cum no.";
		for (a in [Align.Left, Align.Center, Align.Right, Align.MultilineCenter, Align.MultilineRight]) {
			var w = createWidget(longText, a);
			w.setMaxWidth(200);
			resizeWidgets.push(w);
			yoffset += 100;
		}

		// Flows
		function createText(parent:Object, str : String, align:Align, ?forceFont:h2d.Font) {
			var tf = new h2d.Text(forceFont != null ? forceFont : font, parent);
			tf.textColor = 0xffffff;
			tf.textAlign = align;
			tf.text = str;
			tf.maxWidth = 150;
			return tf;
		}

		function createFlow(parent:Object) {
			var flow = new Flow(parent);
			flow.debug = true;
			flow.horizontalSpacing = 5;
			flow.verticalSpacing = 5;
			flow.padding = 5;
			return flow;
		}


		yoffset = 0;
		var flow = createFlow(s2d);
		flow.verticalAlign = FlowAlign.Middle;
		createText(flow, singleText, Align.Left);
		createText(flow, multilineText, Align.Left);

		yoffset += flow.getBounds().height + 10;

		var flow = createFlow(s2d);
		flow.y = yoffset;
		flow.multiline = false;
		flow.verticalAlign = FlowAlign.Middle;
		createText(flow, multilineText, Align.Center);
		createText(flow, multilineText, Align.Right);

		yoffset += flow.getBounds().height + 10;

		var flow = createFlow(s2d);
		flow.y = yoffset;
		flow.verticalAlign = FlowAlign.Middle;
		flow.maxWidth = 150;
		createText(flow, singleText, Align.Left);
		createText(flow, multilineText, Align.Center);

		yoffset += flow.getBounds().height + 10;

		var flow = createFlow(s2d);
		flow.y = yoffset;
		flow.horizontalAlign = FlowAlign.Middle;
		flow.maxWidth = 150;
		flow.layout = Vertical;
		createText(flow, singleText, Align.Left);
		createText(flow, multilineText, Align.Right);

		yoffset += flow.getBounds().height + 10;

		{
			var flow = createFlow(s2d);
			flow.y = yoffset;
			flow.horizontalAlign = FlowAlign.Left;
			flow.maxWidth = 360;
			flow.horizontalSpacing = 8;
			var f = createText(flow, "short text", Align.Right);
			createText(flow, singleText, Align.Left);
			yoffset += flow.getBounds().height + 10;
		}


		var flow = createFlow(s2d);
		flow.y = yoffset;
		flow.x = 100;
		flow.horizontalAlign = FlowAlign.Middle;
		flow.layout = Vertical;
		{
			var f1 = createFlow(flow);
			createText(f1, multilineText, Align.Left);
			var f2 = createFlow(flow);
			createText(f2, multilineText, Align.Left);
		}

		yoffset += flow.getBounds().height + 10;

		// Showcases all supported font formats.
		var flow = createFlow(s2d);
		flow.debug = false;
		flow.y = yoffset;
		flow.x = 10;
		flow.horizontalAlign = FlowAlign.Left;
		flow.layout = Vertical;
		{
			var tf = createText(flow, "BMFont XML format (Littera export)", Align.Left, hxd.Res.littera_xml.toFont());
			tf.maxWidth = 400;
			tf = createText(flow, "BMFont XML format (BMFont export)", Align.Left, hxd.Res.bmfont_xml.toFont());
			tf.maxWidth = 400;
			tf = createText(flow, "BMFont text format (Littera export)", Align.Left, hxd.Res.littera_text.toFont());
			tf.maxWidth = 400;
			tf = createText(flow, "BMFont text format (BMFont export)", Align.Left, hxd.Res.bmfont_text.toFont());
			tf.maxWidth = 400;
			tf = createText(flow, "BMFont Binary format", Align.Left, hxd.Res.bmfont_binary.toFont());
			tf.maxWidth = 400;
			tf = createText(flow, "FontBuilder Divo format", Align.Left, hxd.Res.customFont.toFont());
			tf.maxWidth = 400;

			// Signed Distance Field textures can be another way to do scalable fonts apart from rasterizing every single size used.
			// They also look nice when rotated.
			// See here for details: https://github.com/libgdx/libgdx/wiki/Distance-field-fonts
			sdfText = createText(flow, "Signed Distance Field texture", Align.Left, hxd.Res.sdf_font.toSdfFont(null, 3));
			sdfText.smooth = true; // Smoothing is mandatory when scaling SDF textures.
			sdfText.maxWidth = 400;
		}

		yoffset += flow.getBounds().height + 35;

		{
			var flow = createFlow(s2d);
			flow.y = yoffset;
			flow.horizontalAlign = FlowAlign.Left;
			flow.horizontalSpacing = 15;
			flow.layout = Horizontal;
			createText(flow, "LEFT: It is a text with a new line added after THAT\nto test the alignment", Align.Left);
			createText(flow, "CENTER: It is a text with a new line added after THAT\nto test the alignment", Align.Center);
			createText(flow, "RIGHT: It is a text with a new line added after THAT\nto test the alignment", Align.Right);
			createText(flow, "MULTICENTER: It is a text with a new line added after THAT\nto test the alignment", Align.MultilineCenter);
			createText(flow, "MULTIRIGHT: It is a text with a new line added after THAT\nto test the alignment", Align.MultilineRight);
		}

		onResize();
	}


	override function update(dt:Float) {
		for (w in resizeWidgets) {
			w.setMaxWidth(Std.int(300 + Math.sin(haxe.Timer.stamp() * 0.5) * 100.0));
		}
		sdfText.setScale(0.5 + (Math.cos(haxe.Timer.stamp() * 0.5) + 1) * .5);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Text();
	}

}