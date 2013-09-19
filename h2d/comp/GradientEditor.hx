package h2d.comp;
import h2d.css.Defs;
import h2d.css.Fill;

private typedef Key = { x:Float, value:Int };

private enum KCursor {
	KAlpha;
	KColor;
}

private enum CompStyle {
	CLabel;
	CInput;
	CInputSmall;
}

private class Style {
	public function new () {
	}
	
	public static function get(kind:CompStyle) {
		var style = new h2d.css.Style();
		switch(kind) {
			case CLabel: 		style.fontSize = 12;
			case CInputSmall: 	style.width = 24;
								style.height = 10;
								style.fontSize = 11;
			case CInput: 		style.width = 50;
								style.height = 10;
								style.fontSize = 11;
		}
		return style;
	}
}

private class CFlag extends h2d.css.Fill {
	var container:h2d.Sprite;
	
	public function new (parent, x:Float, y:Float, ang = 0., color = 0xff000000, border = 0xFFaaaaaa) {
		super(parent);
		container = new h2d.Sprite(parent);
		container.rotation = ang;
		container.x = x;
		container.y = y;
		//bg
		var bgarrow = new Fill(container);
		bgarrow.addPoint(-5, -4, border);
		bgarrow.addPoint(5, -4, border);
		bgarrow.addPoint(0, 0, border);
		bgarrow.addPoint(0, 0, border);
		var bgsquare = new Fill(container);
		bgsquare.addPoint(-5, -9, border);
		bgsquare.addPoint(5, -9, border);
		bgsquare.addPoint(-5, 1, border);
		bgsquare.addPoint(5, 1, border);
		bgsquare.y = - 5;
		//color
		var arrow = new Fill(container);
		arrow.addPoint(-4, -5, color);
		arrow.addPoint(4, -5, color);
		arrow.addPoint(0, 0, color);
		arrow.addPoint(0, 0, color);
		var square = new Fill(container);
		square.addPoint(-4, -8, color);
		square.addPoint(4, -8, color);
		square.addPoint(-4, 0, color);
		square.addPoint(4, 0, color);
		square.y = - 5;
	}
}

private class Cursor extends h2d.Sprite {
	public var value(default, set):Int;
	public var coeff(get, null):Float;
	public var color:Int = 0xFFFFFFFF;
	public var bgcolor:Int = 0xFFFF00FF;
	public var cursor:h2d.Sprite;
	public var kind:KCursor;
	var ang:Float;
	var interact:h2d.Interactive;
	var flag:CFlag;
	
	public function new (ix, iy, kind, value, ang, parent) {
		super(parent);
		x = ix;
		y = iy;
		this.value = value;
		this.ang = ang;
		this.kind = kind;
		init();
	}
	
	function set_value(v) {
		value = v;
		if(flag != null) {
			switch(kind) {
				case KColor: color = value;
				case KAlpha: color = (255 << 24) | (value << 16) | (value << 8) | value;
			}
			flag.remove();
			flag = new CFlag(cursor, 0, 0, ang, color, bgcolor);
		}
		return value;
	}
	
	function get_coeff() {
		return x / GradientEditor.boxWidth;
	}
	
	function init() {
		cursor = new h2d.Sprite(this);
		switch(kind) {
			case KColor: color = value;
			case KAlpha: color = (255 << 24) | (value << 16) | (value << 8) | value;
		}
		flag = new CFlag(cursor, 0, 0, ang, color, bgcolor);
		interact = new h2d.Interactive(10, 14, this);
		interact.x = -5;
		if(kind.equals(KAlpha))
			interact.y = -14;
			
		interact.onPush = function(e) drag();
		interact.onRelease = function(e) stopDrag();
	}
	
	public function drag() {
		interact.startDrag(function(e) {
			if( e.kind == EMove ){
				setCursor(e.relX);
				if(e.relY < - 6 ||  e.relY > 16 + 6)
					GradientEditor.dragOut = true;
				else GradientEditor.dragOut = false;
			}
			GradientEditor.dragTarget = this ;
		});
			
		GradientEditor.updateTarget = this;
		this.parent.addChild(this);
	}
	
	public function stopDrag() {
		interact.stopDrag();
		GradientEditor.dragTarget = null ;
		GradientEditor.dragOut = false;
	}
	
	public function select() {
		bgcolor = 0xFFFF00FF;
		flag.remove();
		flag = new CFlag(cursor, 0, 0, ang, color, bgcolor);
		
		if(GradientEditor.colorPicker.visible)
			GradientEditor.colorPicker.color = color;
	}
	
	public function unselect() {
		bgcolor = 0xFFAAAAAA;
		flag.remove();
		flag = new CFlag(cursor, 0, 0, ang, color, bgcolor);
	}
	
	public function setCursor(px:Float) {
		x = Math.max(0, Math.min(GradientEditor.boxWidth, x-5+px));
	}
}

	
private class AlphaSelector extends h2d.Sprite {
	public var target(default, set):Cursor;
	var title:h2d.comp.Label;
	var slider:h2d.comp.Slider;
	var alphaInput:h2d.comp.Input;
	var locLabel:h2d.comp.Label;
	var locInput:h2d.comp.Input;
	
	public function new (ix, iy, parent) {
		super(parent);
		x = ix;
		y = iy;
		init();
	}
	
	function init() {
		title = new h2d.comp.Label("Alpha", this);
		title.addStyle(Style.get(CLabel));
		
		slider = new h2d.comp.Slider(this);
		slider.x = 55; slider.y = 4;
		slider.onChange = function(v) { updateSlider(v); };
		slider.value = 1;
		
		alphaInput = new h2d.comp.Input(this);
		alphaInput.addStyle(Style.get(CInputSmall));
		alphaInput.x = 170;
		alphaInput.value = "255";
		alphaInput.onChange = function(e) {
			var v = Std.parseFloat(alphaInput.value);
			if (!Math.isNaN(v)) {
				v = Math.min(255, v) / 255;
				updateSlider(v);
				slider.value = v;
			}
		};
		
		locLabel = new h2d.comp.Label("Location             %", this);
		locLabel.setStyle(Style.get(CLabel));
		locLabel.x = 255;
		locInput = new h2d.comp.Input(this);
		locInput.setStyle(Style.get(CInput));
		locInput.x = 320;
		locInput.value = "100.00";
		locInput.onChange = function(e) {
			var v = Std.parseFloat(locInput.value);
			if (!Math.isNaN(v)) {
				v = Math.min(100, v);
				locInput.value = Std.string(Math.floor(v * 100) / 100);
				target.setCursor( v * GradientEditor.boxWidth / 100 );
			}
		};
	}
	
	public function update() {
		if(target == null)
			return;
		locInput.value = Std.string(Math.floor(target.coeff * 100 * 100) / 100);
	}
	
	function set_target(cursor:Cursor) {
		target = cursor;
		var v = target.value / 255;
		slider.value = v;
		locInput.value = Std.string(Math.floor(target.coeff * 100 * 100) / 100);
		updateSlider(v);
		return target;
	}
	
	function updateSlider(v:Float) {
		var alpha = Math.round(255 * v);
		alphaInput.value = Std.string(alpha);
		if(target == null)
			return;
		target.value = alpha;
	}
}

private class ColorSelector extends h2d.Sprite {
	public var target(default, set):Cursor;
	var title:h2d.comp.Label;
	var locLabel:h2d.comp.Label;
	var locInput:h2d.comp.Input;
	var colorInput:h2d.comp.Input;
	var canvas:h2d.css.Fill;
	var color:Int = 0xFFFFFFFF;
	var interact : h2d.Interactive;
	
	public function new (ix, iy, parent) {
		super(parent);
		x = ix;
		y = iy;
		init();
	}
	
	public function update() {
		if(target == null)
			return;
		locInput.value = Std.string(Math.floor(target.coeff * 100 * 100) / 100);
	}
	
	function set_target(cursor:Cursor) {
		target = cursor;
		locInput.value = Std.string(Math.floor(target.coeff * 100 * 100) / 100);
		color = target.value;
		colorInput.value = StringTools.hex(color, 8).substr(2);
		redraw();
		return target;
	}
	
	function init() {
		title = new h2d.comp.Label("Color                         #", this);
		title.setStyle(Style.get(CLabel));
		
		canvas = new Fill(this);
		canvas.x = 45;
		canvas.y = -8;
		interact = new h2d.Interactive(110, 25, this);
		interact.x = 50;
		interact.y = -8;
		interact.onPush = function(e) {
			if(target == null)
				return;
			
			if(!GradientEditor.colorPicker.visible) {
				GradientEditor.colorPicker.visible = true;
				GradientEditor.colorPicker.color = color;
				GradientEditor.colorPicker.y = 220;
				GradientEditor.colorPicker.onChange = function(v) {
					color = target.value = v;
					colorInput.value = StringTools.hex(v, 8).substr(2);
					redraw();
				}
			}
			else {
				GradientEditor.colorPicker.onChange = function(v) { };
				GradientEditor.colorPicker.visible = false;
				GradientEditor.colorPicker.y = -500;
			}
		};
		
		colorInput = new h2d.comp.Input(this);
		colorInput.setStyle(Style.get(CInput));
		colorInput.x = 175;
		colorInput.value = "FFFFFF";
		colorInput.onChange = function (e) {
			colorInput.value = colorInput.value.toUpperCase();
			if(colorInput.value.length > 6) {
				colorInput.value = colorInput.value.substr(0, 6);
				return;
			}
			var v = Std.parseInt("0x" + colorInput.value);
			if (v != null) {
				color = target.value = 255 << 24 | v;
				redraw();
			}
		};
		
		locLabel = new h2d.comp.Label("Location             %", this);
		locLabel.setStyle(Style.get(CLabel));
		locLabel.x = 265;
		
		locInput = new h2d.comp.Input(this);
		locInput.setStyle(Style.get(CInput));
		locInput.x = 330;
		locInput.value = "100.00";
		locInput.onChange = function(e) {
			var v = Std.parseFloat(locInput.value);
			if (!Math.isNaN(v)) {
				v = Math.min(100, v);
				locInput.value = Std.string(Math.floor(v * 100) / 100);
				target.setCursor( v * GradientEditor.boxWidth / 100 );
			}
		};
		
		redraw();
	}
	
	function redraw() {
		canvas.reset();
		canvas.fillRectColor(0, 0, 110, 25, color);
		canvas.lineRect(FillStyle.Color(GradientEditor.borderColor), 0, 0, 110, 25, 1);
	}
}
		
		
//////////////////////////////////////////////////////////

class GradientEditor extends h2d.comp.Component {
	
	public static var borderColor = 0xFF888888;
	public static var dragTarget:Cursor;
	public static var dragOut:Bool;
	public static var updateTarget:Cursor;
	public static var boxWidth = 430;
	var boxHeight = 100;
	
	var keys:Array<Key>;
	var colorsKeys:Array<Cursor>;
	var alphaKeys:Array<Cursor>;
	
	var box:h2d.Sprite;
	var gradient:h2d.Sprite;
	var hudAlpha: AlphaSelector;
	var hudColor: ColorSelector;
	
	public static var colorPicker:ColorPicker;
	
	var interactUp:h2d.Interactive;
	var interactDown:h2d.Interactive;
		
	
	var holdCursor:Cursor;
	
	public function new(?parent) {
		super("gradienteditor", parent);
		init();
	}
	
	inline function init() {
		colorsKeys = [];
		alphaKeys = [];
		
		interactUp = new h2d.Interactive(boxWidth, 16, this);
		interactUp.x = 10;
		interactUp.y = 30 - 16;
		interactUp.onPush =  function(e) createAlphaKey(e.relX, 0);
		interactDown = new h2d.Interactive(boxWidth, 16, this);
		interactDown.x = 10;
		interactDown.y = 30 + boxHeight;
		interactDown.onPush =  function(e) createColorKey(e.relX, boxHeight);
		
		box = new h2d.Sprite(this);
		box.x = 10;
		box.y = 30;
		drawChecker();
		
		hudColor = new ColorSelector(20, box.y + boxHeight + 30, this);
		hudAlpha = new AlphaSelector(20, box.y + boxHeight + 30, this);
		hudAlpha.visible = false;
		hudAlpha.y = 0;
		
		colorPicker = new ColorPicker(this);
		colorPicker.y = -500;
		colorPicker.visible = false;
		
		//
		colorsKeys.push( new Cursor(0, boxHeight, KColor, 0xFFFFFFFF, Math.PI,  box));
		colorsKeys.push( new Cursor(boxWidth, boxHeight, KColor, 0xFFFFFFFF, Math.PI, box));
		alphaKeys.push( new Cursor(0, 0, KAlpha, 255, 0, box));
		alphaKeys.push( new Cursor(boxWidth, 0, KAlpha, 255, 0, box));
		updateTarget = colorsKeys[0];
		updateKeys();
		drawGradient();
	
		#if flash
		flash.Lib.current.stage.addEventListener(flash.events.Event.ENTER_FRAME, doUpdate);
		#end
	}
	
	function doUpdate(_) {
		if(dragTarget != null) {
			if(dragOut) {
				switch(dragTarget.kind) {
					case KColor: if(colorsKeys.length > 1) {
						colorsKeys.remove(dragTarget);
						holdCursor = dragTarget;
						dragTarget.visible = false;
					}
					case KAlpha: if(alphaKeys.length > 1) {
						alphaKeys.remove(dragTarget);
						holdCursor = dragTarget;
						dragTarget.visible = false;
					}
				}
			}
			else if(holdCursor == dragTarget) {
				holdCursor = null;
				dragTarget.visible = true;
				switch(dragTarget.kind) {
					case KColor: colorsKeys.push(dragTarget);
					case KAlpha: alphaKeys.push(dragTarget);
				}
			}
			
			hudAlpha.update();
			hudColor.update();
		}
		else holdCursor = null;
		
		if(updateTarget != null) {
			changeHud(updateTarget);
			updateFlags(updateTarget);
			updateTarget = null;
		}
		
		updateKeys();
		drawGradient();
	}
	
	inline function createAlphaKey(px:Float, py:Float) {
		var cursor = new Cursor(px, py, KAlpha, getAlphaAt(px / boxWidth), 0, box);
		alphaKeys.push(cursor);
		updateTarget = cursor;
		cursor.drag();
	}
	
	inline function createColorKey(px:Float, py:Float) {
		var cursor = new Cursor(px, py, KColor, getColorAt(px / boxWidth), Math.PI, box);
		colorsKeys.push(cursor);
		updateTarget = cursor;
		cursor.drag();
	}
	
	inline function updateKeys() {
		keys = [];
		for (i in 0...colorsKeys.length) {
			var k = colorsKeys[i];
			var alpha = getAlphaAt(k.coeff);
			var rgb = INTtoRGB(k.value);
			keys.push( { x:k.coeff, value:RGBtoINT(rgb[0], rgb[1], rgb[2], alpha) } );
		}
		
		for (i in 0...alphaKeys.length) {
			var k = alphaKeys[i];
			var alpha = k.value;
			var rgb = INTtoRGB(getColorAt(k.coeff));
			keys.push( { x:k.coeff, value:RGBtoINT(rgb[0], rgb[1], rgb[2], alpha) } );
		}
		
		keys.sort(function(a, b) return Reflect.compare(a.x, b.x) );
		if(keys[0].x != 0)
			keys.insert(0, { x:0, value:keys[0].value } );
		if(keys[keys.length - 1].x != 1)
			keys.push( { x:1, value:keys[keys.length - 1].value } );
	}
	
	function getARGBAt(x:Float) {
		var alpha = getAlphaAt(x);
		var rgb = INTtoRGB(getColorAt(x));
		return RGBtoINT(rgb[0], rgb[1], rgb[2], alpha);
	}
	
	function getAlphaAt(x:Float) {
		alphaKeys.sort(function(a, b) return Reflect.compare(a.coeff, b.coeff) );
		var prev = null;
		var next = null;
		for (i in 0...alphaKeys.length) {
			var k = alphaKeys[i];
			if (k.coeff == x)
				return k.value;
			else if (k.coeff < x)
				prev = k;
			else if (k.coeff > x) {
				if(prev == null)
					return k.value;
				else next = k;
				break;
			}
		}
		if(next == null)
			return prev.value;
		var d = (x - prev.coeff) / (next.coeff - prev.coeff);
		return Math.round(prev.value + (next.value - prev.value) * d);
	}
	
	function getColorAt(x:Float) {
		colorsKeys.sort(function(a, b) return Reflect.compare(a.coeff, b.coeff) );
		var prev = null;
		var next = null;
		for (i in 0...colorsKeys.length) {
			var k = colorsKeys[i];
			if (k.coeff == x)
				return k.value;
			else if (k.coeff < x)
				prev = k;
			else if (k.coeff > x) {
				if(prev == null)
					return k.value;
				else next = k;
				break;
			}
		}
		if(next == null)
			return prev.value;
			
		var d = (x - prev.coeff) / (next.coeff - prev.coeff);
		var pRGB = INTtoRGB(prev.value);
		var nRGB = INTtoRGB(next.value);
		var rgb = [];
		for (i in 0...3)
			rgb.push(Math.round(pRGB[i] + (nRGB[i] - pRGB[i]) * d));
		return RGBtoINT(rgb[0], rgb[1], rgb[2]);
	}
	
	inline function drawGradient() {
		box.removeChild(gradient);
		gradient = new h2d.Sprite(box);
		for (i in 0...keys.length - 1) {
			var c1 = keys[i];
			var c2 = keys[i + 1];
			var rect = new Fill(gradient);
			rect.fillRectGradient(boxWidth * c1.x, 0, boxWidth * (c2.x - c1.x), boxHeight, c1.value, c2.value, c1.value, c2.value);
		}
		var borders = new Fill(gradient);
		borders.lineRect(FillStyle.Color(borderColor), 0, 0, boxWidth, boxHeight, 2);
	}
	
	inline function drawChecker() {
		var checker = new h2d.Sprite(box);
		var nb = 90;
		var size = Math.ceil(boxWidth / nb);
		for (i in 0...nb) {
			for (j in 0...nb) {
				if(i * size >= boxWidth) break;
				if(j * size >= boxHeight) break;
				var color = ((i + j) % 2 == 0) ? 0xFFFFFFFF:0xFFAAAAAA;
				var rect = new Fill(checker);
				rect.fillRect(FillStyle.Color(color), i * size, j * size, size, size);
			}
		}
	}
	
	inline function changeHud(cursor:Cursor) {
		switch(cursor.kind) {
			case KAlpha: 	hudAlpha.target = cursor;
							hudAlpha.visible = true;
							hudAlpha.y = box.y + boxHeight + 30;
							hudColor.visible = false;
			case KColor:	hudColor.target = cursor;
							hudColor.visible = true;
							hudAlpha.visible = false;
							hudAlpha.y =  0;
		}
	}
	
	inline function updateFlags(cursor:Cursor) {
		for (c in alphaKeys) {
			if (c == cursor)
				c.select();
			else c.unselect();
		}
		for (c in colorsKeys) {
			if (c == cursor)
				c.select();
			else c.unselect();
		}
	}
	
	
	inline public static function INTtoRGB(color:Int) {
		return [(color >> 16) & 0xFF, (color >> 8) & 0xFF,  color & 0xFF, color >>> 24];
	}
	
	inline public static function RGBtoINT(r:Int, g:Int, b:Int, a:Int = 255) {
		return (a << 24) | (r << 16) | (g << 8) | b;
	}
}