package h2d.domkit;
import domkit.Property;
import domkit.CssValue;

typedef FlowBg = { tile : #if macro Bool #else h2d.Tile #end, borderL : Int, borderT : Int, borderR : Int, borderB : Int, ?color : Int }

class CustomParser extends domkit.CssValue.ValueParser {

	public function new() {
		super();
		defaultColor = -1;
	}

	function parseScale( value ) {
		switch( value ) {
		case VGroup([x,y]):
			return { x : parseFloatPercent(x), y : parseFloatPercent(y) };
		default:
			var s = parseFloatPercent(value);
			return { x : s, y : s };
		}
	}

	function parseDimension( value ) {
		switch( value ) {
		case VGroup([x,y]):
			return { x : parseFloat(x), y : parseFloat(y) };
		case VIdent("none"):
			return null;
		default:
			var s = parseFloat(value);
			return { x : s, y : s };
		}
	}

	function parsePosition( value ) {
		switch( value ) {
		case VIdent("auto"):
			return false;
		case VIdent("absolute"):
			return true;
		default:
			return invalidProp();
		}
	}


	function transitionColorF( v1 : h3d.Vector4, v2 : h3d.Vector4, t : Float ) : h3d.Vector4 {
		var v = new h3d.Vector4();
		v.lerp(v1,v2,t);
		return v;
	}

	function parseColorF( v : CssValue ) : h3d.Vector4 {
		var f = new h3d.Vector4();
		switch( v ) {
		case VInt(i):
			f.r = f.g = f.b = i;
		case VFloat(k):
			f.r = f.g = f.b = k;
		default:
			f.setColor(parseColor(v));
		}
		return f;
	}

	function loadResource( path : String ) {
		#if macro
		// TODO : compile-time path check?
		return true;
		#else
		return try hxd.res.Loader.currentInstance.load(path) catch( e : hxd.res.NotFound ) invalidProp("Resource not found "+path);
		#end
	}

	public function parseResource( v : CssValue) {
		var path = parsePath(v);
		return loadResource(path);
	}

	public function parseTile( v : CssValue) {
		try {
			switch( v ) {
			case VIdent("none"):
				return null;
			case VGroup([color,w,h]):
				var c = parseColor(color);
				var w = parseInt(w);
				var h = parseInt(h);
				return #if macro true #else h2d.Tile.fromColor(c,w,h,(c>>>24)/255) #end;
			case VCall("tile",[VString(url),VInt(size)]):
				var p = loadResource(url);
				return #if macro p #else { var t = p.toTile(); t.sub(0,0,size,size); } #end;
			case VCall("tile",[VString(url),VInt(sizex),VInt(sizey)]):
				var p = loadResource(url);
				return #if macro p #else { var t = p.toTile(); t.sub(0,0,sizex,sizey); } #end;
			case VCall("grid",[VString(url),VInt(hsplit),VInt(vsplit)]):
				var p = loadResource(url);
				return #if macro p #else { var t = p.toTile(); t.sub(0,0,Std.int(t.iwidth/hsplit),Std.int(t.iheight/vsplit)); } #end;
			case VCall("hgrid",[VString(url),VInt(hsplit)]):
				var p = loadResource(url);
				return #if macro p #else { var t = p.toTile(); t.sub(0,0,Std.int(t.iwidth/hsplit),t.iheight); } #end;
			case VCall("vgrid",[VString(url),VInt(vsplit)]):
				var p = loadResource(url);
				return #if macro p #else { var t = p.toTile(); t.sub(0,0,t.iwidth,Std.int(t.iheight/vsplit)); } #end;
			default:
				var c = parseColor(v);
				return #if macro true #else h2d.Tile.fromColor(c,1,1,(c>>>24)/255) #end;
			}
		} catch( e : InvalidProperty ) {
			var path = parsePath(v);
			var p = loadResource(path);
			return #if macro p #else p.toTile() #end;
		}
	}

	public function parseTilePos( value ) : { p:Int, ?y:Int } {
		return switch( value ) {
		case VIdent("default"): { p : 0 };
		case VInt(p): { p : p };
		case VGroup([VInt(x),VInt(y)]): { p : x, y : y };
		default: invalidProp();
		}
	}

	public function parseHAlign( value ) : #if macro Bool #else h2d.Flow.FlowAlign #end {
		switch( parseIdent(value) ) {
		case "auto":
			return null;
		case "middle":
			return #if macro true #else Middle #end;
		case "left":
			return #if macro true #else Left #end;
		case "right":
			return #if macro true #else Right #end;
		case x:
			return invalidProp(x+" should be auto|left|middle|right");
		}
	}

	public function parseVAlign( value ) : #if macro Bool #else h2d.Flow.FlowAlign #end {
		switch( parseIdent(value) ) {
		case "auto":
			return null;
		case "middle":
			return #if macro true #else Middle #end;
		case "top":
			return #if macro true #else Top #end;
		case "bottom":
			return #if macro true #else Bottom #end;
		case x:
			return invalidProp(x+" should be auto|top|middle|bottom");
		}
	}

	public function parseAlign( value : CssValue ) {
		switch( value ) {
		case VIdent("auto"):
			return { h : null, v : null };
		case VIdent(_):
			try {
				return { h : parseHAlign(value), v : null };
			} catch( e : InvalidProperty ) {
				return { h : null, v : parseVAlign(value) };
			}
		case VGroup([h,v]):
			try {
				return { h : parseHAlign(h), v : parseVAlign(v) };
			} catch( e : InvalidProperty ) {
				return { h : parseHAlign(v), v : parseVAlign(h) };
			}
		default:
			return invalidProp();
		}
	}

	public function parseFont( value : CssValue ) {
		var path = null;
		var sdf = null;
		var offset: Null<Int> = null, offsetChar = 0;
		var lineHeight : Null<Float> = null, baseLine: Null<Int> = null;
		switch(value) {
			case VGroup(args):
				var args = args.copy();
				path = parsePath(args[0]);
				while (args[1] != null && args[1].match(VCall(_))) {
					switch( args[1] ) {
					case VCall("offset", [VIdent("auto")]):
						offsetChar = -1;
					case VCall("offset", [VString(c)]) if( c.length == 1 ):
						offsetChar = c.charCodeAt(0);
					case VCall("offset", [v]):
						offset = parseInt(v);
					case VCall("line-height", [v]):
						lineHeight = parseFloat(v);
					case VCall("base-line", [v]):
						baseLine = parseInt(v);
					default:
						break;
					}
					args.splice(1,1);
				}
				if( args[1] != null ) {
					sdf = {
						size: parseInt(args[1]),
						channel: args.length >= 3 ? switch(args[2]) {
							case VIdent("red"): h2d.Font.SDFChannel.Red;
							case VIdent("green"): h2d.Font.SDFChannel.Green;
							case VIdent("blue"): h2d.Font.SDFChannel.Blue;
							case VIdent("multi"): h2d.Font.SDFChannel.MultiChannel;
							default: h2d.Font.SDFChannel.Alpha;
						} : h2d.Font.SDFChannel.Alpha,
						cutoff: args.length >= 4 ? parseFloat(args[3]) : 0.5,
						smooth: args.length >= 5 ? parseFloat(args[4]) : 1.0/32.0
					};
					adjustSdfParams(sdf);
				}
			default:
				path = parsePath(value);
		}
		var res = loadResource(path);
		#if macro
		return res;
		#else
		var fnt;
		if(sdf != null)
			fnt = res.to(hxd.res.BitmapFont).toSdfFont(sdf.size, sdf.channel, sdf.cutoff, sdf.smooth);
		else
			fnt = res.to(hxd.res.BitmapFont).toFont();
		var defChar = offsetChar <= 0 ? fnt.getChar("A".code) ?? fnt.getChar("0".code) ?? fnt.getChar("a".code) : fnt.getChar(offsetChar);
		if( offsetChar != 0 && defChar != null )
			offset = -Math.ceil(defChar.t.dy) + Std.int(@:privateAccess fnt.offsetY);
		if( offset != null || baseLine != null) {
			var prev = @:privateAccess fnt.offsetY;
			fnt.setOffset(0,offset);
			@:privateAccess fnt.lineHeight += offset - prev;
			@:privateAccess fnt.baseLine = fnt.calcBaseLine() + baseLine;
		}
		if( lineHeight != null && defChar != null ) {
			@:privateAccess fnt.lineHeight = Math.ceil(defChar.t.height * lineHeight);
		}
		return fnt;
		#end
	}

	public static dynamic function adjustSdfParams( sdf : { size : Int, channel : h2d.Font.SDFChannel, cutoff : Float, smooth : Float }) {

	}

	public function parseTextShadow( value : CssValue ) {
		return switch( value ) {
		case VIdent("none"):
			return null;
		case VGroup(vl):
			return { dx : parseFloat(vl[0]), dy : parseFloat(vl[1]), color : vl.length >= 3 ? parseColor(vl[2]) : 0, alpha : vl.length >= 4 ? parseFloatPercent(vl[3]) : 1 };
		default:
			return { dx : 1, dy : 1, color : parseColor(value), alpha : 1 };
		}
	}

	function transitionFlowBackground( bg1 : FlowBg, bg2 : FlowBg, v : Float ) : FlowBg {
		var color = transitionColor(bg1.color, bg2.color, v);
		return {
			tile : #if macro true #else h2d.Tile.fromColor(color&0xFFFFFF,(color>>>24)/255) #end,
			borderL : Std.int(hxd.Math.lerp(bg1.borderL, bg2.borderL, v)),
			borderR : Std.int(hxd.Math.lerp(bg1.borderR, bg2.borderR, v)),
			borderT : Std.int(hxd.Math.lerp(bg1.borderT, bg2.borderT, v)),
			borderB : Std.int(hxd.Math.lerp(bg1.borderB, bg2.borderB, v)),
			color : color,
		};
	}

	public function parseFlowBackground(value) : FlowBg {
		return switch( value ) {
		case VIdent("transparent"): null;
		case VGroup([tile,VInt(w),VInt(h)]):
			{ tile : parseTile(tile), borderL : w, borderT : h, borderR : w, borderB : h };
		case VGroup([tile,VInt(l),VInt(t),VInt(r),VInt(b)]):
			{ tile : parseTile(tile), borderL : l, borderT : t, borderR : r, borderB : b };
		case VGroup([color,alpha]):
			var c = parseColor(color);
			var a = parseFloat(alpha);
			return { tile : #if macro true #else h2d.Tile.fromColor(c,a) #end, borderL : 0, borderT : 0, borderR : 0, borderB : 0, color : c | (Std.int(hxd.Math.clamp(a)*255)<<24) };
		case VCall("disc",args) if( args.length == 1 || args.length == 2 ):
			var c = parseColor(args[0]);
			var a = args[1] == null ? 1. : parseFloat(args[1]);
			return { tile : #if macro true #else h2d.Tile.fromTexture(h3d.mat.Texture.genDisc(256,c,a)) #end, borderL : 0, borderT : 0, borderR : 0, borderB : 0 };
		default:
			{ tile : parseTile(value), borderL : 0, borderT : 0, borderR : 0, borderB : 0, color : try parseColor(value) catch( e : Dynamic ) null };
		}
	}

	public function parseCursor(value) : hxd.Cursor {
		return switch( value ) {
		case VIdent("default"): Default;
		case VIdent("button"): Button;
		case VIdent("move"): Move;
		case VIdent("textinput") | VIdent("input"): TextInput;
		case VIdent("hide"): Hide;
		default: invalidProp();
		}
	}

	public function parseFilter(value) : #if macro Bool #else h2d.filter.Filter #end {
		return switch( value ) {
		case VIdent("none"): #if macro true #else null #end;
		case VIdent("nothing"): #if macro true #else new h2d.filter.Nothing() #end;
		case VIdent("grayscale"), VCall("grayscale",[]): #if macro true #else h2d.filter.ColorMatrix.grayed() #end;
		case VCall("grayscale",[v]):
			var v = parseFloatPercent(v);
			#if macro
				true;
			#else
				var f = new h2d.filter.ColorMatrix();
				f.matrix.colorSaturate(-v);
				f;
			#end
		case VCall("saturate",[v]):
			var v = parseFloatPercent(v);
			#if macro
				true;
			#else
				var f = new h2d.filter.ColorMatrix();
				f.matrix.colorSaturate(v);
				f;
			#end
		case VCall("outline",[s, c]):
			var s = parseFloat(s);
			var c = parseColor(c);
			#if macro
				true;
			#else
				var f = new h2d.filter.Outline(s, c);
				f.alpha = (c >>> 24) / 255;
				f;
			#end
		case VCall("brightness",[v]):
			var v = parseFloatPercent(v);
			#if macro
				true;
			#else
				var f = new h2d.filter.ColorMatrix();
				f.matrix.colorLightness(v);
				f;
			#end
		case VCall("glow",[c, a, r, g, q, b]):
			var c = parseColor(c);
			var a = parseFloat(a);
			var r = parseFloat(r);
			var g = parseFloat(g);
			var q = parseFloat(q);
			var b = parseBool(b);
			#if macro
				true;
			#else
				new h2d.filter.Glow(c, a, r, g, q, b);
			#end
		case VCall("glow",[VIdent("none"), r, g, q]):
			var r = parseFloat(r);
			var g = parseFloat(g);
			var q = parseFloat(q);
			#if macro
				true;
			#else
				var glow = new h2d.filter.Glow(0xFFFFFF, 0., r, g, q);
				// since 'hasFixedColor' is set to false, alpha will be ignored.
				@:privateAccess glow.pass.shader.hasFixedColor = false;
				glow;
			#end
		case VCall("blur",[r]):
			var r = parseFloat(r);
			#if macro
				true;
			#else
				new h2d.filter.Blur(r);
			#end
		case VGroup(vl):
			var fl = [for( v in vl ) parseFilter(v)];
			#if macro
				true;
			#else
				new h2d.filter.Group(fl);
			#end
		default: invalidProp();
		}
	}

	public function transitionColorAdjust(col1: h3d.Matrix.ColorAdjust, col2: h3d.Matrix.ColorAdjust, t: Float) {
		inline function defaultValues(col: h3d.Matrix.ColorAdjust) {
			var c : h3d.Matrix.ColorAdjust = { saturation: 0, lightness: 0,	hue: 0,	contrast: 0, gain: { color: 0, alpha: 0 } };
			if (col != null) {
				if (col.saturation != null) c.saturation = col.saturation;
				if (col.lightness != null) c.lightness = col.lightness;
				if (col.hue != null) c.hue = col.hue;
				if (col.contrast != null) c.contrast = col.contrast;
				if (col.gain != null) c.gain = col.gain;
			}
			return c;
		}

		var col1 = defaultValues(col1);
		var col2 = defaultValues(col2);
		return {
			saturation: hxd.Math.lerp(col1.saturation, col2.saturation, t),
			lightness: hxd.Math.lerp(col1.lightness, col2.lightness, t),
			hue: hxd.Math.lerp(col1.hue, col2.hue, t),
			contrast: hxd.Math.lerp(col1.contrast, col2.contrast, t),
			gain: {
				color: transitionColor(col1.gain.color, col2.gain.color, t),
				alpha: hxd.Math.lerp(col1.gain.alpha, col2.gain.alpha, t)
			}
		};
	}

	public function parseColorAdjust(value:CssValue) : h3d.Matrix.ColorAdjust {
		if( value.match(VIdent("none")) )
			return null;
		var adj : h3d.Matrix.ColorAdjust = {};

		inline function parseVal(vcall: CssValue) {
			switch(vcall) {
				case VCall("hue-rotate", [v]):
					adj.hue = parseFloat(v) * Math.PI / 180;
				case VCall("contrast", [v]):
					adj.contrast = parseFloat(v);
				case VCall("gain", [c, a]):
					adj.gain = { color : parseColor(c), alpha : parseFloat(a) };
				case VCall("brightness",[v]):
					adj.lightness = parseFloat(v);
				case VCall("saturate",[v]):
					adj.saturation = parseFloat(v);
				default:
					invalidProp();
			}
		}

		switch( value ) {
		case VGroup(vcalls):
			for(vcall in vcalls)
				parseVal(vcall);
		case VCall(_):
			parseVal(value);
		default:
			invalidProp();
		}
		return adj;
	}

	public function parseAngleRad(value:CssValue) : Float {
		return switch(value) {
			case VUnit(v, "rad"):
				v;
			case VUnit(v, "deg"):
				hxd.Math.degToRad(v);
			default:
				parseFloat(value);
		}
		return 0.;
	}

	public function parseAngleDeg(value:CssValue) : Float {
		return switch(value) {
			case VUnit(v, "rad"):
				hxd.Math.radToDeg(v);
			case VUnit(v, "deg"):
				v;
			default:
				parseFloat(value);
		}
		return 0.;
	}

	function parseTagDefinition(value:CssValue) : {name:String,?font:String,?color:Int} {
		return switch( value ) {
		case VCall(id,[VString(font)]):
			{name:id,font:font};
		case VCall(id,[v = VIdent(c)]):
			try {name:id,color:parseColor(v)} catch( e : InvalidProperty ) {name:id,font:c};
		case VCall(id,[v]):
			{name:id,color:parseColor(v)};
		case VCall(id,[VString(font)|VIdent(font),col]):
			{name:id,font:font,color:parseColor(col)};
		default:
			invalidProp();
		}
	}

	public function parseTagDefinitions(value:CssValue) {
		return switch(value) {
		case VGroup(values): [for( v in values ) parseTagDefinition(v)];
		default: [parseTagDefinition(value)];
		}
	}

}

#if !macro
@:uiComp("object") @:domkitDecl
class ObjectComp implements h2d.domkit.Object implements domkit.Component.ComponentDecl<h2d.Object> {

	@:p var x : Float;
	@:p var y : Float;
	@:p var alpha : Float = 1;
	@:p(angleRad) var rotation : Float;
	@:p var visible : Bool = true;
	@:p(scale) var scale : { x : Float, y : Float };
	@:p var scaleX : Float = 1;
	@:p var scaleY : Float = 1;
	@:p var blend : h2d.BlendMode = Alpha;
	@:p(filter) var filter : h2d.filter.Filter;
	@:p var filterSmooth : Bool;

	// flow properties
	@:p(box) var margin : { left : Int, top : Int, right : Int, bottom : Int };
	@:p var marginLeft = 0;
	@:p var marginRight = 0;
	@:p var marginTop = 0;
	@:p var marginBottom = 0;
	@:p(align) var align : { v : h2d.Flow.FlowAlign, h : h2d.Flow.FlowAlign };
	@:p(hAlign) var halign : h2d.Flow.FlowAlign;
	@:p(vAlign) var valign : h2d.Flow.FlowAlign;
	@:p(position) var position : Bool;
	@:p(XY) var offset : { x : Float, y : Float };
	@:p var offsetX : Int;
	@:p var offsetY : Int;
	@:p(none) var minWidth : Null<Int>;
	@:p(none) var minHeight : Null<Int>;
	@:p var forceLineBreak : Bool;
	@:p(none) var autoSize : Null<Float>;
	@:p(none) var autoSizeWidth : Null<Float>;
	@:p(none) var autoSizeHeight : Null<Float>;


	static function set_rotation(o:h2d.Object, v:Float) {
		o.rotation = v * Math.PI / 180;
	}

	static function set_visible(o:h2d.Object, v:Bool) {
		o.visible = v;
	}

	static function set_scale(o:h2d.Object,v) {
		if(v != null) {
			o.scaleX = v.x;
			o.scaleY = v.y;
		}
		else {
			o.setScale(1);
		}
	}

	static function set_filter(o:h2d.Object, f:h2d.filter.Filter) {
		o.filter = f;
	}

	static function set_filterSmooth(o:h2d.Object, b:Bool) {
		if( o.filter != null ) o.filter.smooth = b;
	}

	static function set_blend(o:h2d.Object, b:h2d.BlendMode) {
		o.blendMode = b;
	}

	static function getFlowProps( o : h2d.Object ) {
		var p = Std.downcast(o.parent, h2d.Flow);
		return p == null ? null : p.getProperties(o);
	}

	static function set_margin(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) {
			if( v == null )
				p.paddingLeft = p.paddingRight = p.paddingTop = p.paddingBottom = 0;
			else {
				p.paddingLeft = v.left;
				p.paddingRight = v.right;
				p.paddingTop = v.top;
				p.paddingBottom = v.bottom;
			}
		}
	}

	static function set_marginLeft(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.paddingLeft = v;
	}

	static function set_marginRight(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.paddingRight = v;
	}

	static function set_marginTop(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.paddingTop = v;
	}

	static function set_marginBottom(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.paddingBottom = v;
	}

	static function set_align(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) {
			p.horizontalAlign = v == null ? null : v.h;
			p.verticalAlign = v == null ? null : v.v;
		}
	}

	static function set_halign(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.horizontalAlign = v;
	}

	static function set_valign(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.verticalAlign = v;
	}

	static function set_position(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.isAbsolute = v;
	}

	static function set_offset(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) {
			p.offsetX = v == null ? 0 : Std.int(v.x);
			p.offsetY = v == null ? 0 : Std.int(v.y);
		}
	}

	static function set_offsetX(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.offsetX = v;
	}

	static function set_offsetY(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.offsetY = v;
	}

	static function set_minWidth(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.minWidth = v;
	}

	static function set_minHeight(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.minHeight = v;
	}

	static function set_autoSize(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) {
			p.autoSizeWidth = v;
			p.autoSizeHeight = v;
		}
	}
	static function set_autoSizeWidth(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.autoSizeWidth = v;
	}
	static function set_autoSizeHeight(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.autoSizeHeight = v;
	}

	static function set_forceLineBreak(o:h2d.Object,v) {
		var p = getFlowProps(o);
		if( p != null ) p.lineBreak = v;
	}

	static function updateComponentId(p:domkit.Properties<Dynamic>) {
		cast(p.obj,h2d.Object).name = p.id.toString();
	}

	@:keep static var _ = { @:privateAccess domkit.Properties.updateComponentId = updateComponentId; true; }

}

@:uiComp("drawable") @:domkitDecl
class DrawableComp extends ObjectComp implements domkit.Component.ComponentDecl<h2d.Drawable> {

	@:p(colorF) @:t(colorF) #if domkit_drawable_color var color #else var tint #end : h3d.Vector4;
	@:p(auto) var smooth : Null<Bool>;
	@:p(colorAdjust) @:t(colorAdjust) var colorAdjust : Null<h3d.Matrix.ColorAdjust>;
	@:p var tileWrap : Bool;

	static function #if domkit_drawable_color set_color #else set_tint #end( o : h2d.Drawable, v ) {
		if(v != null)
			o.color.load(v);
		else
			o.color.set(1,1,1);
	}

	static function set_colorAdjust( o : h2d.Drawable, v ) {
		o.adjustColor(v);
	}
}

@:uiComp("mask") @:domkitDecl
class MaskComp extends ObjectComp implements domkit.Component.ComponentDecl<h2d.Mask> {
	@:p var width : Int;
	@:p var height : Int;

	static function create( parent : h2d.Object ) {
		return new h2d.Mask(0,0,parent);
	}
}

@:uiComp("video") @:domkitDecl
class VideoComp extends DrawableComp implements domkit.Component.ComponentDecl<h2d.Video> {
	@:p(resource) var src : hxd.res.Any;
	@:p var loop : Bool;

	static function create( parent : h2d.Object ) {
		return new h2d.Video(parent);
	}

	static function set_src( o : h2d.Video, v ) {
		o.loadResource(v);
	}

	static function set_loop( o : h2d.Video, v ) {
		o.loop = v;
	}
}

@:uiComp("bitmap") @:domkitDecl
class BitmapComp extends DrawableComp implements domkit.Component.ComponentDecl<h2d.Bitmap> {

	@:p(tile) var src : h2d.Tile;
	@:p(tilePos) var srcPos : { p : Int, ?y : Int };
	@:p var srcFlipX : Null<Bool>;
	@:p var srcFlipY : Null<Bool>;
	@:p var srcPosX : Null<Int>;
	@:p var srcPosY : Null<Int>;
	@:p(auto) var width : Null<Float>;
	@:p(auto) var height : Null<Float>;

	static function create( parent : h2d.Object ) {
		return new h2d.Bitmap(h2d.Tile.fromColor(0xFF00FF,32,32,0.9),parent);
	}

	static function set_src( o : h2d.Bitmap, t ) {
		o.tile = t == null ? h2d.Tile.fromColor(0xFF00FF,32,32,0.9) : t;
	}

	static function set_srcPos( o : h2d.Bitmap, pos ) {
		o.tile = setTilePos(o.tile, pos);
	}

	static function set_srcPosX( o : h2d.Bitmap, x : Int ) {
		o.tile = setTilePosX(o.tile, x);
	}

	static function set_srcPosY( o : h2d.Bitmap, y: Int ) {
		o.tile = setTilePosY(o.tile, y);
	}

	static function set_srcFlipX( o : h2d.Bitmap, b: Bool ) {
		o.tile = setTileFlipX(o.tile, b);
	}

	static function set_srcFlipY( o : h2d.Bitmap, b: Bool ) {
		o.tile = setTileFlipY(o.tile, b);
	}

	static function setTilePos( t : h2d.Tile, pos : Null<{ p : Int, ?y : Int }> ) {
		if( t == null ) return null;
		if( pos == null ) pos = {p:0};
		var tex = t.getTexture();
		t = t.clone();
		if( pos.y == null && t.iwidth == tex.width )
			t.setPosition(0, pos.p * t.iheight);
		else
			t.setPosition(pos.p * t.iwidth, pos.y * t.iheight);
		return t;
	}

	static function setTilePosX( t : h2d.Tile, x : Int ) {
		if( t == null ) return null;
		t = t.clone();
		t.setPosition(x * t.iwidth, t.iy);
		return t;
	}

	static function setTilePosY( t : h2d.Tile, y : Int ) {
		if( t == null ) return null;
		t = t.clone();
		t.setPosition(t.ix, y * t.iheight);
		return t;
	}

	static function setTileFlipX(t : h2d.Tile, b : Bool) {
		if (t == null) return null;
		var xFlip = t.u2 < t.u;
		if (xFlip != b) {
			t = t.clone();
			var tmp = t.u;
			t.u = t.u2;
			t.u2 = tmp;
		}
		return t;
	}

	static function setTileFlipY(t : h2d.Tile, b : Bool) {
		if (t == null) return null;
		var yFlip = t.v2 < t.v;
		if (yFlip != b) {
			t = t.clone();
			var tmp = t.v;
			t.v = t.v2;
			t.v2 = tmp;
		}
		return t;
	}

	static function set_width( o : h2d.Bitmap, v : Null<Float> ) {
		o.width = v;
	}

	static function set_height( o : h2d.Bitmap, v : Null<Float> ) {
		o.height = v;
	}

}

@:uiComp("text") @:domkitDecl
class TextComp extends DrawableComp implements domkit.Component.ComponentDecl<h2d.Text> {

	@:p var text : String = "";
	@:p(font) var font : h2d.Font;
	@:p var letterSpacing = 0;
	@:p var lineSpacing = 0;
	@:p var lineBreak : Bool;
	@:p(none) var maxWidth : Null<Int>;
	@:p var textAlign : h2d.Text.Align = Left;
	@:p(textShadow) var textShadow : { dx : Float, dy : Float, color : Int, alpha : Float };
	@:p(color) @:t(color) var #if domkit_drawable_color textColor #else color #end : Null<Int>;

	static function create( parent : h2d.Object ) {
		return new h2d.Text(hxd.res.DefaultFont.get(),parent);
	}

	static function set_font( t : h2d.Text, v ) {
		t.font = v == null ? hxd.res.DefaultFont.get() : v;
	}

	static function set_textShadow( t : h2d.Text, v ) {
		t.dropShadow = v;
	}

	static function set_lineBreak( t : h2d.Text, v ) {
		t.lineBreak = v;
	}

	#if !domkit_drawable_color
	static function set_color( t : h2d.Text, v : Null<Int> ) {
		t.textColor = v == null ? -1 : v;
	}
	#end
}

@:uiComp("html-text") @:domkitDecl
class HtmlTextComp extends TextComp implements domkit.Component.ComponentDecl<h2d.HtmlText> {
	@:p var condenseWhite : Bool;
	@:p var propagateInteractiveNode: Bool;
	@:p(tagDefinitions) var tags : Array<{name:String,font:String,color:Int}>;

	static function create( parent : h2d.Object ) {
		return new h2d.HtmlText(hxd.res.DefaultFont.get(),parent);
	}

	static function set_condenseWhite(o : h2d.HtmlText, v) {
		o.condenseWhite = v;
	}

	static function set_propagateInteractiveNode(o : h2d.HtmlText, v) {
		o.propagateInteractiveNode = v;
	}

	static function set_tags( o : h2d.HtmlText, tags:Array<{name:String,font:String,color:Int}>) {
		o.defineHtmlTags(tags);
	}

}

@:uiComp("scale-grid") @:domkitDecl
class ScaleGridComp extends DrawableComp implements domkit.Component.ComponentDecl<h2d.ScaleGrid> {

	@:p var ignoreScale : Bool;
	@:p var borderScale : Float;
	@:p var tileBorders : Bool;
	@:p var tileCenter : Bool;
	@:p var width : Float;
	@:p var height : Float;

	static function create( parent : h2d.Object ) {
		return new h2d.ScaleGrid(h2d.Tile.fromColor(0xFF00FF,32,32,0.9), 0, 0,parent);
	}

	static function set_ignoreScale(o : h2d.ScaleGrid, v) {
		o.ignoreScale = v;
	}

	static function set_borderScale(o : h2d.ScaleGrid, v) {
		o.borderScale = v;
	}

	static function set_tileBorders(o : h2d.ScaleGrid, v) {
		o.tileBorders = v;
	}

	static function set_tileCenter(o : h2d.ScaleGrid, v) {
		o.tileCenter = v;
	}

	static function set_width( o : h2d.ScaleGrid, v : Float ) {
		o.width = v;
	}

	static function set_height( o : h2d.ScaleGrid, v : Float ) {
		o.height = v;
	}

}

@:uiComp("flow") @:domkitDecl
class FlowComp extends ObjectComp implements domkit.Component.ComponentDecl<h2d.Flow> {

	@:p(auto) var width : Null<Int>;
	@:p(auto) var height : Null<Int>;
	@:p var maxWidth : Null<Int>;
	@:p var maxHeight : Null<Int>;
	@:p var backgroundId : Bool;
	@:p(flowBackground) @:t(flowBackground) var background : FlowBg;
	@:p(tile) var backgroundTile : h2d.Tile;
	@:p(tilePos) var backgroundTilePos : { p : Int, y : Int };
	@:p var backgroundTilePosX : Null<Int>;
	@:p var backgroundTilePosY : Null<Int>;
	@:p var backgroundAlpha : Float = 1;
	@:p(auto) var backgroundSmooth : Null<Bool>;
	@:p var backgroundRepeat : Bool;
	@:p var debug : Bool;
	@:p var layout : h2d.Flow.FlowLayout;
	@:p var vertical : Bool;
	@:p var horizontal : Bool;
	@:p var stack : Bool;
	@:p var multiline : Bool;
	@:p(box) var padding : { left : Int, right : Int, top : Int, bottom : Int };
	@:p var paddingLeft : Int;
	@:p var paddingRight : Int;
	@:p var paddingTop : Int;
	@:p var paddingBottom : Int;
	@:p var hspacing : Int;
	@:p var vspacing : Int;
	@:p(dimension) var spacing : { x: Float, y: Float };
	@:p var fillWidth: Bool;
	@:p var fillHeight: Bool;
	@:p var overflow: h2d.Flow.FlowOverflow;
	@:p var scrollWheelSpeed: Float;
	@:p var reverse : Bool;

	@:p(align) var contentAlign : { h : h2d.Flow.FlowAlign, v : h2d.Flow.FlowAlign };
	@:p(vAlign) var contentValign : h2d.Flow.FlowAlign;
	@:p(hAlign) var contentHalign : h2d.Flow.FlowAlign;
	@:p(cursor) var cursor : hxd.Cursor;
	@:p var propagate : Bool;
	@:p var inlineBlock : Bool;

	static function set_minWidth( o : h2d.Flow, v ) {
		o.minWidth = v;
	}

	static function set_minHeight( o : h2d.Flow, v ) {
		o.minHeight = v;
	}

	static function set_width( o : h2d.Flow, v ) {
		o.minWidth = o.maxWidth = v;
	}

	static function set_height( o : h2d.Flow, v ) {
		o.minHeight = o.maxHeight = v;
	}

	static function set_contentValign( o : h2d.Flow, a ) {
		o.verticalAlign = a;
	}

	static function set_contentHalign( o : h2d.Flow, a ) {
		o.horizontalAlign = a;
	}

	static function set_contentAlign( o : h2d.Flow, v ) {
		if( v == null ) {
			o.horizontalAlign = o.verticalAlign = null;
		} else {
			o.horizontalAlign = v.h;
			o.verticalAlign = v.v;
		}
	}

	static function set_background( o : h2d.Flow, v ) {
		if( v == null ) {
			o.backgroundTile = null;
			o.borderWidth = o.borderHeight = 0;
		} else {
			o.backgroundTile = v.tile;
			o.borderLeft = v.borderL;
			o.borderTop = v.borderT;
			o.borderRight = v.borderR;
			o.borderBottom = v.borderB;
		}
	}

	static function set_backgroundTile( o : h2d.Flow, t ) {
		o.backgroundTile = t;
	}

	static function set_backgroundRepeat( o : h2d.Flow, v ) {
		@:privateAccess if( o.background != null )
			o.background.tileBorders = o.background.tileCenter = v;
	}

	static function set_backgroundTilePos( o : h2d.Flow, pos ) {
		o.backgroundTile = @:privateAccess BitmapComp.setTilePos(o.backgroundTile, pos);
	}

	static function set_backgroundTilePosX( o : h2d.Flow, x ) {
		o.backgroundTile = @:privateAccess BitmapComp.setTilePosX(o.backgroundTile, x);
	}

	static function set_backgroundTilePosY( o : h2d.Flow, y ) {
		o.backgroundTile = @:privateAccess BitmapComp.setTilePosY(o.backgroundTile, y);
	}

	static function set_backgroundId( o : h2d.Flow, id : Bool ) {
		if( o.backgroundTile == null ) {
			if( !id ) return;
			o.backgroundTile = h2d.Tile.fromColor(0xFFFFFF,1,1,0);
		}
		var bg = @:privateAccess o.background;
		if( (bg.dom != null) != id )
			bg.dom = id ? domkit.Properties.create("scale-grid",bg,{ id : "background" }) : null;
	}

	static function set_backgroundAlpha( o : h2d.Flow, v ) {
		var bg = @:privateAccess o.background;
		if(bg == null)
			return;
		bg.alpha = v;
	}

	static function set_backgroundSmooth( o : h2d.Flow, v : Null<Bool> ) {
		var bg = @:privateAccess o.background;
		if(bg == null)
			return;
		bg.smooth = v;
	}

	static function set_cursor( o : h2d.Flow, c ) {
		if( o.interactive == null ) o.enableInteractive = true;
		o.interactive.cursor = c;
	}

	static function set_propagate( o : h2d.Flow, b : Bool ) {
		if( o.interactive == null ) o.enableInteractive = true;
		o.interactive.propagateEvents = b;
		if( b ) o.interactive.cursor = null else if( o.interactive.cursor == null ) o.interactive.cursor = Default;
	}

	static function set_padding( o : h2d.Flow, v ) {
		if( v == null ) {
			o.padding = 0;
		} else {
			o.paddingLeft = v.left;
			o.paddingRight = v.right;
			o.paddingTop = v.top;
			o.paddingBottom = v.bottom;
		}
	}

	static function set_layout( o : h2d.Flow, v ) {
		o.layout = v;
	}

	static function set_inlineBlock( o : h2d.Flow, v ) {
		o.isInline = !v;
	}

	static function set_vertical( o : h2d.Flow, v ) {
		o.layout = v ? Vertical : Horizontal;
	}

	static function set_horizontal( o : h2d.Flow, v ) {
		o.layout = Horizontal;  // setting false resets to default
	}

	static function set_stack( o : h2d.Flow, v ) {
		o.layout = v ? Stack : Horizontal;
	}

	static function set_hspacing( o : h2d.Flow, v ) {
		o.horizontalSpacing = v;
	}

	static function set_vspacing( o : h2d.Flow, v) {
		o.verticalSpacing = v;
	}

	static function set_spacing( o : h2d.Flow, v ) {
		if(v == null) {
			o.horizontalSpacing = o.verticalSpacing = 0;
		}
		else {
			o.horizontalSpacing = Std.int(v.x);
			o.verticalSpacing = Std.int(v.y);
		}
	}

	static function set_fillWidth( o : h2d.Flow, v ) {
		o.fillWidth = v;
	}

	static function set_fillHeight( o : h2d.Flow, v ) {
		o.fillHeight = v;
	}

	static function set_overflow( o : h2d.Flow, v ) {
		o.overflow = v;
		if( v == Scroll ) @:privateAccess {
			if( o.scrollBar.dom == null ) {
				o.scrollBar.dom = domkit.Properties.create("flow", o.scrollBar);
				o.scrollBar.dom.addClass("scrollbar");
			}
			if( o.scrollBarCursor.dom == null ) {
				o.scrollBarCursor.dom = domkit.Properties.create("flow", o.scrollBarCursor);
				o.scrollBarCursor.dom.addClass("cursor");
			}
		}
	}

	static function set_scrollWheelSpeed( o : h2d.Flow, v ) {
		o.scrollWheelSpeed = v;
	}

	static function set_reverse( o : h2d.Flow, v ) {
		o.reverse = v;
	}

}

@:uiComp("input") @:domkitDecl
class InputComp extends TextComp implements domkit.Component.ComponentDecl<h2d.TextInput> {

	@:p(auto) var width : Null<Int>;
	@:p(tile) var cursor : h2d.Tile;
	@:p(tile) var selection : h2d.Tile;
	@:p var edit : Bool;
	@:p(color) @:t(color) var backgroundColor : Null<Int>;
	@:p var multiline : Bool;

	static function create( parent : h2d.Object ) {
		return new h2d.TextInput(hxd.res.DefaultFont.get(),parent);
	}

	static function set_width( o : h2d.TextInput, v ) {
		o.inputWidth = v;
	}

	static function set_cursor( o : h2d.TextInput, t ) {
		o.cursorTile = t;
	}

	static function set_selection( o : h2d.TextInput, t ) {
		o.selectionTile = t;
	}

	static function set_edit( o : h2d.TextInput, b ) {
		o.canEdit = b;
	}

	static function set_backgroundColor( o : h2d.TextInput, col ) {
		o.backgroundColor = col;
	}

	static function set_multiline( o : h2d.TextInput, b ) {
		o.multiline = b;
	}

}

#end
