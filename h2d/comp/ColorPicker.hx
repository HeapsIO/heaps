package h2d.comp;
import h2d.css.Defs;
import h2d.css.Fill;

private enum RGBA {
	R;
	G;
	B;
	A;
}

private enum ChangeState {
	SNone;
	SColor;
	SPalette;
	SChart;
	SRed;
	SGreen;
	SBlue;
	SAlpha;
}

private enum CompStyle {
	GaugeLabel;
	GaugeInput;
	ColorLabel;
	ColorInput;
}

private class Style {
	public function new () {
	}
	
	public static function get(kind:CompStyle) {
		var style = new h2d.css.Style();
		switch(kind) {
			case GaugeLabel: 	style.fontSize = 11;
			case GaugeInput: 	style.width = 24;
								style.height = 10;
								style.fontSize = 11;
			case ColorLabel: 	style.fontSize = 14;
			case ColorInput: 	style.width = 50;
								style.height = 10;
								style.fontSize = 11;
		}
		return style;
	}
}

private class Arrow extends h2d.css.Fill {
	public function new (parent, x:Float, y:Float, ang = 0., color = 0xff000000) {
		super(parent);
		addPoint(-5, -4, color);
		addPoint(-5, 4, color);
		addPoint(0, 0, color);
		addPoint(0, 0, color);
		rotation = -ang;
		this.x = x;
		this.y = y;
	}
}

private class Cross extends h2d.css.Fill {
	var size:Float;
	
	public function new (parent, size:Float, color = 0xff000000) {
		super(parent);
		this.size = size;
		lineRect(FillStyle.Color(color), 0, 0, size, size, 1);
	}
	
	public function setColor(color:Int) {
		reset();
		lineRect(FillStyle.Color(color), 0, 0, size, size, 1);
	}
}

private class Color extends h2d.Sprite {
	var picker : ColorPicker;
	public var width :Float;
	public var height :Float;
	public var color(default, set):Int = 0xFFFFFFFF;
	public var preview(default, set):Int = 0xFFFFFFFF;
	public var alpha(default, set):Float = 1.;
	
	var canvas:h2d.css.Fill;
	var label : h2d.comp.Label;
	var input : h2d.comp.Input;
	
	
	public function new (picker,ix, iy, iw, ih, parent) {
		super(parent);
		this.picker = picker;
		x = ix;
		y = iy;
		width = iw;
		height = ih;
		init();
	}
	
	function set_color(v:Int) {
		if(v != color) {
			color = v;
			drawAll();
		}
		return color;
	}
	
	function set_preview(v:Int) {
		if(v != preview) {
			preview = v;
			drawAll();
		}
		return color;
	}
	
	function set_alpha(v:Float) {
		alpha = v;
		drawAll();
		return color;
	}
	
	public function updateColor(v:Int) {
		color = v;
		input.value = StringTools.hex(preview, 6).substr(2);
	}
	
	function init() {
		label = new h2d.comp.Label("#", this);
		label.setStyle(Style.get(ColorLabel));
		input = new h2d.comp.Input(this);
		input.setStyle(Style.get(ColorInput));
		input.value = "FFFFFF";
		input.x = 15; input.y = 3;
		input.onChange = function (e) {
			input.value = input.value.toUpperCase();
			if(input.value.length > 6) {
				input.value = input.value.substr(0, 6);
				return;
			}
			var v = Std.parseInt("0x" + input.value);
			if (v != null) {
				color = 255 << 24 | v;
				picker.change = SColor;
			}
		};
		
		canvas = new h2d.css.Fill(this);
		canvas.y = 2 + height * 0.5;
		drawAll();
	}
	
	public function drawAll() {
		canvas.reset();
		canvas.fillRectColor(0, 0, width, height * 0.5, preview);
		canvas.fillRectColor(0, 0, width * 0.5, height * 0.5, color);
		canvas.fillRectColor(0, height * 0.5 - 4, width, 4, 0xFF000000);
		canvas.fillRectColor(0, height * 0.5 - 4, width * alpha, 4, 0xFFFFFFFF);
		canvas.lineRect(FillStyle.Color(ColorPicker.borderColor), 0, 0, width, height * 0.5, 1);
	}
}

private class Palette extends h2d.Sprite {
	public var width :Float;
	public var height :Float;
	public var color(default, set):Int;
	
	var picker : ColorPicker;
	var canvas:h2d.css.Fill;
	var interact:h2d.Interactive;
	var cursor:h2d.Sprite;
	
	public function new (picker, ix, iy, iw, ih, parent) {
		super(parent);
		this.picker = picker;
		x = ix;
		y = iy;
		width = iw;
		height = ih;
		init();
	}
	
	function init() {
		canvas = new h2d.css.Fill(this);
		cursor = new h2d.Sprite(this);
		var larrow = new Arrow(cursor, 0, 0, 0, 0xffcccccc);
		var rarrow = new Arrow(cursor, width, 0, Math.PI, 0xffcccccc);
		interact = new h2d.Interactive(width + 16, height, canvas);
		interact.x = -8;
		interact.onPush = function(e) {
			setCursor(e.relY);
			interact.startDrag(function(e) {
				if( e.kind == EMove )
					setCursor(e.relY);
			});
			picker.change = SPalette;
		}
		interact.onRelease = function(e) {
			interact.stopDrag();
			picker.change = SNone;
		}
		color = getColor(0);
		drawAll();
	}
	
	function set_color(v:Int) {
		color = v;
		if(!picker.change.equals(SPalette))
			updateCursor();
		drawAll();
		return color;
	}
	
	function updateCursor() {
		var hsl = ColorPicker.INTtoHSL(color);
		cursor.y = Math.round(Math.max(0, Math.min(height, (1 - hsl[0]) * height)));
	}
	
	public function drawAll() {
		var s = 1;
		var l = 0.5;
		var seg = height / 6;
		canvas.reset();
		for (i in 0...6) {
			var up = ColorPicker.HSLtoINT(1 - i / 6, s, l);
			var down = ColorPicker.HSLtoINT(1 - (i + 1) / 6, s, l);
			canvas.fillRectGradient(0, i * seg, width, seg, up, up, down, down);
		}
		canvas.lineRect(FillStyle.Color(ColorPicker.borderColor), 0, 0, width, height, 1);
	}
	
	public function setCursor(dy:Float) {
		cursor.y = Math.round(Math.max(0, Math.min(height, dy)));
		color = getColor(cursor.y);
	}
	
	public function getColor(py:Float) {
		var h = 1 - (py / height);
		var s = 1;
		var l = 0.5;
		return(ColorPicker.HSLtoINT(h, s, l));
	}
	
	public function setColorFrom(newColor:Int) {
		var rgb = ColorPicker.INTtoRGB(newColor);
		var hsl = ColorPicker.RGBtoHLS(rgb[0], rgb[1], rgb[2]);
		hsl[1] = 1; hsl[2] = 0.5;
		rgb = ColorPicker.HSLtoRGB(hsl[0], hsl[1], hsl[2]);
		color = ColorPicker.RGBtoINT(rgb[0], rgb[1], rgb[2]);
	}
}

private class Chart extends h2d.Sprite{
	public var width :Int;
	public var height :Int;
	public var refColor(default, set):Int = 0xffffffff;
	public var color:Int = 0xffffffff;
	
	var picker : ColorPicker;
	var ray :Float;
	var canvas:h2d.css.Fill;
	var interact:h2d.Interactive;
	var cursor:h2d.Sprite;
	var lastPos:h3d.Vector;
	var cross:Cross ;
	
	public function new (picker,ix, iy, iw, ih, ray, parent) {
		super(parent);
		this.picker = picker;
		x = ix;
		y = iy;
		width = iw;
		height = ih;
		this.ray = ray;
		init();
	}
	
	function init() {
		canvas = new h2d.css.Fill(this);
		cursor = new h2d.Sprite(this);
		cross = new Cross(cursor, ray * 2);
		cross.x = cross.y = -ray;
		interact = new h2d.Interactive(width, height, canvas);
		interact.onPush = function(e) {
			setCursor(e.relX, e.relY);
			interact.startDrag(function(e) {
				if( e.kind == EMove )
					setCursor(e.relX, e.relY);
			});
			picker.change = SChart;
		}
		interact.onRelease = function(e) {
			interact.stopDrag();
			picker.change = SNone;
		}
		drawAll();
		setCursor(0, 0);
	}
	
	public function setCursor(dx:Float, dy:Float) {
		cursor.x = Math.max(ray + 1, Math.min(width - ray - 1, dx));
		cursor.y = Math.max(ray + 1, Math.min(height - ray - 1, dy));
		lastPos = normalizePos(dx, dy);
		color = getColor(lastPos.x, lastPos.y);
		cross.setColor(ColorPicker.complementaryColor(color));
	}
	
	function set_refColor(v:Int) {
		refColor = v;
		color = getColor(lastPos.x, lastPos.y);
		cross.setColor(ColorPicker.complementaryColor(color));
		drawAll();
		return refColor;
	}
	
	function normalizePos(dx:Float, dy:Float) {
		var px = 1 - Math.min(width, Math.max(0, dx)) / width;
		var py = 1 - Math.min(height, Math.max(0, dy)) / height;
		return new h3d.Vector(px, py);
	}
	
	public function drawAll() {
		canvas.reset();
		var rgb = [(refColor >> 16) & 0xFF, (refColor >> 8) & 0xFF,  refColor & 0xFF];
		for (i in 0...width>>1) {
			for (j in 0...height>>1) {
				var di = Math.max(0, Math.min(width, i * 2));
				var dj = Math.max(0, Math.min(width, j * 2));
				var dw = (1 - di / width);
				var dh = (1 - dj / height);
				var r = Math.round(rgb[0] * dh);
				var g = Math.round(rgb[1] * dh);
				var b = Math.round(rgb[2] * dh);
				var max = Math.max(r, Math.max(g, b));
				r = Math.round(r + (max - r) * dw);
				g = Math.round(g + (max - g) * dw);
				b = Math.round(b + (max - b) * dw);
				var c = (255 << 24) | (r << 16) | (g << 8) | b;
				canvas.fillRectColor(i * 2, j * 2, 2, 2, c);
			}
		}
		canvas.lineRect(FillStyle.Color(ColorPicker.borderColor), 0, 0, width, height, 1);
	}
	
	function getColor(dw:Float, dh:Float) {
		var rgb = [(refColor >> 16) & 0xFF, (refColor >> 8) & 0xFF,  refColor & 0xFF];
		var r = Math.round(rgb[0] * dh);
		var g = Math.round(rgb[1] * dh);
		var b = Math.round(rgb[2] * dh);
		var max = Math.max(r, Math.max(g, b));
		r = Math.round(r + (max - r) * dw);
		g = Math.round(g + (max - g) * dw);
		b = Math.round(b + (max - b) * dw);
		return ColorPicker.RGBtoINT(r, g, b);
	}
	
	public function setColorFrom(newColor:Int) {
		var rgb = ColorPicker.INTtoRGB(newColor);
		var hsl = ColorPicker.RGBtoHLS(rgb[0], rgb[1], rgb[2]);
		hsl[1] = 1; hsl[2] = 0.5;
		rgb = ColorPicker.HSLtoRGB(hsl[0], hsl[1], hsl[2]);
		refColor = ColorPicker.RGBtoINT(rgb[0], rgb[1], rgb[2]);
		
		var rgb = ColorPicker.INTtoRGB(newColor);
		var min = Math.min(rgb[0], Math.min(rgb[1], rgb[2]));
		var max = Math.max(rgb[0], Math.max(rgb[1], rgb[2]));
		var dx = 1 - min / max;
		var dy = 1 - max / 255;
		setCursor(dx * width, dy * height);
	}
}

private class ColorGauge extends h2d.Sprite{
	public var width :Int;
	public var height :Int;
	public var color(default, set):Int = 0xffffffff;
	public var ratio(get, null):Float;
	
	var picker : ColorPicker;
	var canvas:h2d.css.Fill;
	var interact:h2d.Interactive;
	var cursor:h2d.Sprite;
	var bindTo:RGBA;
	var label : h2d.comp.Label;
	var input : h2d.comp.Input;
	var isFinal:Bool;
	public function new (picker,ix, iy, iw, ih, rgba, parent) {
		super(parent);
		this.picker = picker;
		x = ix;
		y = iy;
		width = iw;
		height = ih;
		bindTo = rgba;
		init();
	}
	
	function init() {
		label = new h2d.comp.Label(bindTo.getName(), this);
		label.setStyle(Style.get(GaugeLabel));
		label.x = -45;
		label.y = 2;
		input = new h2d.comp.Input(this);
		input.setStyle(Style.get(GaugeInput));
		input.value = "255";
		input.x = -30; input.y = 3;
		input.onChange = function(e) {
			setCursor(cursor.x);
		};
		
		canvas = new h2d.css.Fill(this);
		cursor = new h2d.Sprite(this);
		cursor.x = width;
		var larrow = new Arrow(cursor, 0, 0, -Math.PI / 2, 0xffcccccc);
		var rarrow = new Arrow(cursor, 0, height, Math.PI / 2, 0xffcccccc);
		interact = new h2d.Interactive(width, height + 8, canvas);
		interact.y = -4;
		interact.onPush = function(e) {
			setCursor(e.relX);
			interact.startDrag(function(e) {
				if( e.kind == EMove )
					setCursor(e.relX);
			});
			setState();
		}
		interact.onRelease = function(e) {
			interact.stopDrag();
			picker.change = SNone;
		}
		drawAll();
	}
	
	function set_color(v:Int) {
		color = v;
		if(!bindTo.equals(RGBA.A))
			updateCursor();
		drawAll();
		return color;
	}
	
	function setState() {
		picker.change = switch(bindTo) {
			case RGBA.R: SRed;
			case RGBA.G: SGreen;
			case RGBA.B: SBlue;
			case RGBA.A: SAlpha;
		}
	}
	
	public function get_ratio() {
		return cursor.x / width;
	}
	
	public function updateCursor() {
		var a = color >>> 24;
		var r = (color >> 16) & 0xFF;
		var g =	(color >> 8) & 0xFF;
		var b = color & 0xFF;
		cursor.x = Math.round(switch(bindTo) {
			case RGBA.R: r * width / 255;
			case RGBA.G: g * width / 255;
			case RGBA.B: b * width / 255;
			case RGBA.A: a * width / 255;
		});
		input.value = Std.string(Std.int(255 * ratio));
	}
	
	public function setCursor(dx:Float) {
		cursor.x = Math.round(Math.max(0, Math.min(width, dx)));
		var r = (color >> 16) & 0xFF;
		var g =	(color >> 8) & 0xFF;
		var b = color & 0xFF;
		color = switch(bindTo) {
			case RGBA.R: ColorPicker.RGBtoINT(Math.round(255 * ratio), g, b);
			case RGBA.G: ColorPicker.RGBtoINT(r, Math.round(255 * ratio), b);
			case RGBA.B: ColorPicker.RGBtoINT(r, g, Math.round(255 * ratio));
			case RGBA.A: color;
		}
		input.value = Std.string(Math.round(255 * ratio));
	}
	
	public function drawAll() {
		var r = (color >> 16) & 0xFF;
		var g =	(color >> 8) & 0xFF;
		var b = color & 0xFF;
		var left:Int;
		var right:Int;
		switch(bindTo) {
			case RGBA.R: left = ColorPicker.RGBtoINT(0, g, b);	right = ColorPicker.RGBtoINT(255, g, b);
			case RGBA.G: left = ColorPicker.RGBtoINT(r, 0, b);	right = ColorPicker.RGBtoINT(r, 255, b);
			case RGBA.B: left = ColorPicker.RGBtoINT(r, g, 0);	right = ColorPicker.RGBtoINT(r, g, 255);
			case RGBA.A: left = 0xFF000000;						right = 0xFFFFFFFF;
		}
		canvas.reset();
		canvas.fillRectGradient(0, 0, width, height, left, right, left, right);
		canvas.lineRect(FillStyle.Color(ColorPicker.borderColor), 0, 0, width, height, 1);
	}
}



/////////////////////////////////////////////////////////////////

@:allow(h2d.comp)
class ColorPicker extends h2d.comp.Component {
	
	public static var borderColor = 0xFFaaaaaa;
	
	var finalColor : Color;
	var palette : Palette;
	var chart : Chart;
	var gaugeRed : ColorGauge;
	var gaugeGreen : ColorGauge;
	var gaugeBlue : ColorGauge;
	var gaugeAlpha : ColorGauge;
	var timer : haxe.Timer;
	var change : ChangeState;
	
	public var color(get, set) : Int;
	
	public function new(?parent) {
		super("colorpicker", parent);
		init();
	}
	
	inline function get_color() {
		return (finalColor.color&0xFFFFFF) | Std.int(finalColor.alpha*255) << 24;
	}
	
	function set_color(v) {
		finalColor.color = v;
		finalColor.alpha = (v >>> 24) / 255;
		palette.setColorFrom(v);
		chart.setColorFrom(v);
		gaugeRed.color = chart.color;
		gaugeGreen.color = chart.color;
		gaugeBlue.color = chart.color;
		gaugeAlpha.setCursor(finalColor.alpha * gaugeAlpha.width);
		return v;
	}
	
	override function onAlloc() {
		super.onAlloc();
		if( timer == null ) {
			timer = new haxe.Timer(10);
			timer.run = doUpdate;
		}
	}
	
	override function onDelete() {
		super.onDelete();
		if( timer != null ) {
			timer.stop();
			timer = null;
		}
	}
	
	function init() {
		finalColor = new Color(this, 15, 8, 175, 45, this);
		palette = new Palette(this, 16, 65, 20, 140, this);
		chart = new Chart(this,50, 65, 140, 140, 3.5, this);
		gaugeRed = new ColorGauge(this, 50, 220, 140, 15, RGBA.R, this);
		gaugeGreen = new ColorGauge(this, 50, 245, 140, 15, RGBA.G, this);
		gaugeBlue = new ColorGauge(this, 50, 270, 140, 15, RGBA.B, this);
		gaugeAlpha = new ColorGauge(this, 50, 295, 140, 15, RGBA.A, this);
		chart.refColor = palette.color;
		change = SNone;
		var close = new Button("", this);
		close.addClass(":close");
//		close.addStyleString("layout:absolute;font-size:12px;height:10px;width:10px;");
		close.x = 175;
		close.y = 10;
		close.onClick = function() {
			onClose();
		};
	}

	function doUpdate() {
		finalColor.preview = chart.color;
		if(change.equals(SNone)) {
			if(finalColor.color != chart.color) {
				finalColor.updateColor(chart.color);
				onChange(color);
			}
			return;
		}
			
		switch(change) {
			case SColor:	palette.setColorFrom(finalColor.color);
							chart.setColorFrom(finalColor.color);
							// require another change event since we have finalColor == chartColor
							onChange(color);
			case SPalette:	chart.refColor = palette.color;
			case SRed:		chart.setColorFrom(gaugeRed.color);
							palette.color = chart.refColor;
			case SGreen:	chart.setColorFrom(gaugeGreen.color);
							palette.color = chart.refColor;
			case SBlue:		chart.setColorFrom(gaugeBlue.color);
							palette.color = chart.refColor;
			case SAlpha:	finalColor.alpha = gaugeAlpha.ratio;
							onChange(color);
			default:
		}
		
		gaugeRed.color = chart.color;
		gaugeGreen.color = chart.color;
		gaugeBlue.color = chart.color;
	}
	
	public dynamic function onClose() {
	}
	
	public dynamic function onChange( value : Int ) {
	}
	
//////////////////
	public static function INTtoRGB(color:Int) {
		return [(color >> 16) & 0xFF, (color >> 8) & 0xFF,  color & 0xFF];
	}
	
	public static function INTtoHSL(color:Int) {
		var rgb = INTtoRGB(color);
		return RGBtoHLS(rgb[0], rgb[1], rgb[2]);
	}
	
	public static function RGBtoINT(r:Int, g:Int, b:Int, a:Int = 255) {
		return (a << 24) | (r << 16) | (g << 8) | b;
	}
	
	public static function RGBtoHLS(r:Float, g:Float, b:Float) {
		r /= 255;
		g /= 255;
		b /= 255;
		var max = Math.max(r, Math.max(g, b));
		var min = Math.min(r, Math.min(g, b));
		var med = (max + min) / 2;
		var h = med;
		var s = med;
		var l = med;
		if(max == min)
			h = s = 0;
		else {
			var d = max - min;
			s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
			if(max == r) 		h = (g - b) / d + (g < b ? 6 : 0);
			else if(max == g) 	h = (b - r) / d + 2;
			else if(max == b) 	h = (r - g) / d + 4;
			h /= 6;
		}
		return [h, s, l];
	}
	
	public static function HSLtoINT(h:Float, s:Float, l:Float) {
		var rgb = HSLtoRGB(h, s, l);
		return RGBtoINT(rgb[0], rgb[1], rgb[2]);
	}
	
	public static function HSLtoRGB(h:Float, s:Float, l:Float) {
		var r, g, b;
		if(s == 0)
			r = g = b = l;
		else {
			function hue2rgb(p:Float, q:Float, t:Float) {
				if(t < 0) t += 1;
				if(t > 1) t -= 1;
				if(t < 1 / 6) return p + (q - p) * 6 * t;
				if(t < 1 / 2) return q;
				if(t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
				return p;
			}
			var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
			var p = 2 * l - q;
			r = hue2rgb(p, q, h + 1 / 3);
			g = hue2rgb(p, q, h);
			b = hue2rgb(p, q, h - 1 / 3);
		}
		return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
	}
	
	public static function complementaryColor (color:Int) {
		var rgb = INTtoRGB(color);
		var r = rgb[0] ^ 0xFF;
		var g = rgb[1] ^ 0xFF;
		var b = rgb[2] ^ 0xFF;
		return (255 << 24) | (r << 16) | (g << 8) | b;
	}
}