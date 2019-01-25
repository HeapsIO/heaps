package h2d.uikit;
import h2d.uikit.Property;
import h2d.uikit.CssValue;

class CustomParser extends CssValue.ValueParser {

	function parseScale( value ) {
		switch( value ) {
		case VGroup([x,y]):
			return { x : parseFloat(x), y : parseFloat(y) };
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
		var path = parsePath(value);
		var res = loadResource(path);
		#if macro
		return res;
		#else
		return res.to(hxd.res.BitmapFont).toFont();
		#end
	}

	public function parseTextShadow( value : CssValue ) {
		return switch( value ) {
		case VGroup(vl):
			return { dx : parseFloat(vl[0]), dy : parseFloat(vl[1]), color : vl.length >= 3 ? parseColor(vl[2]) : 0, alpha : vl.length >= 4 ? parseFloat(vl[3]) : 1 };
		default:
			return { dx : 1, dy : 1, color : parseColor(value), alpha : 1 };
		}
	}

	public function parseFlowBackground(value) {
		return switch( value ) {
		case VIdent("transparent"): null;
		case VGroup([tile,VInt(x),VInt(y)]):
			{ tile : parseTile(tile), borderW : x, borderH : y };
		default:
			{ tile : parseTile(value), borderW : 0, borderH : 0 };
		}
	}

	#if !macro
	// force macros to be run in order to init base components
	static var _ = @:privateAccess Macros.init();
	#end

}

#if !macro
@:uiComp("object") @:parser(h2d.uikit.BaseComponents.CustomParser)
class ObjectComp implements h2d.uikit.Component.ComponentDecl<h2d.Object> {

	@:p(ident) var name : String;
	@:p var x : Float;
	@:p var y : Float;
	@:p var alpha : Float = 1;
	@:p var rotation : Float;
	@:p var visible : Bool;
	@:p(scale) var scale : { x : Float, y : Float };
	@:p var blend : h2d.BlendMode = Alpha;

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

	static function set_rotation(o:h2d.Object, v:Float) {
		o.rotation = v * Math.PI / 180;
	}

	static function set_scale(o:h2d.Object,v) {
		o.scaleX = v.x;
		o.scaleY = v.y;
	}

	static function set_blend(o:h2d.Object, b:h2d.BlendMode) {
		o.blendMode = b;
	}

	static function getFlowProps( o : h2d.Object ) {
		var p = Std.instance(o.parent, h2d.Flow);
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
			p.offsetX = v == null ? 0 : Std.int(v.y);
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

}

@:uiComp("drawable")
class DrawableComp extends ObjectComp implements h2d.uikit.Component.ComponentDecl<h2d.Drawable> {

	@:p(colorF) var color : h3d.Vector;
	@:p(auto) var smooth : Null<Bool>;
	@:p var tileWrap : Bool;

	static function set_color( o : h2d.Drawable, v ) {
		o.color.load(v);
	}
}

@:uiComp("bitmap")
class BitmapComp extends DrawableComp implements h2d.uikit.Component.ComponentDecl<h2d.Bitmap> {

	@:p(tile) var src : h2d.Tile;

	static function create( parent : h2d.Object ) {
		return new h2d.Bitmap(h2d.Tile.fromColor(0xFF00FF,32,32,0.9),parent);
	}

	static function set_src( o : h2d.Bitmap, t ) {
		o.tile = t == null ? h2d.Tile.fromColor(0xFF00FF,32,32,0.9) : t;
	}

}

@:uiComp("text")
class TextComp extends DrawableComp implements h2d.uikit.Component.ComponentDecl<h2d.Text> {

	@:p var text : String = "";
	@:p(font) var font : h2d.Font;
	@:p var letterSpacing = 1;
	@:p var lineSpacing = 0;
	@:p(none) var maxWidth : Null<Int>;
	@:p var textAlign : h2d.Text.Align = Left;
	@:p(textShadow) var textShadow : { dx : Float, dy : Float, color : Int, alpha : Float };

	static function create( parent : h2d.Object ) {
		return new h2d.Text(hxd.res.DefaultFont.get(),parent);
	}

	static function set_font( t : h2d.Text, v ) {
		t.font = v == null ? hxd.res.DefaultFont.get() : v;
	}

	static function set_textShadow( t : h2d.Text, v ) {
		t.dropShadow = v;
	}

}


@:uiComp("flow")
class FlowComp extends DrawableComp implements h2d.uikit.Component.ComponentDecl<h2d.Flow> {

	@:p(auto) var width : Null<Int>;
	@:p(auto) var height : Null<Int>;
	@:p var maxWidth : Null<Int>;
	@:p var maxHeight : Null<Int>;
	@:p(flowBackground) var background : { tile : h2d.Tile, borderW : Int, borderH : Int };
	@:p var debug : Bool;
	@:p(box) var padding : { left : Int, right : Int, top : Int, bottom : Int };
	@:p var paddingLeft : Int;
	@:p var paddingRight : Int;
	@:p var paddingTop : Int;
	@:p var paddingBottom : Int;

	@:p(align) var contentAlign : { h : h2d.Flow.FlowAlign, v : h2d.Flow.FlowAlign };
	@:p(vAlign) var contentValign : h2d.Flow.FlowAlign;
	@:p(hAlign) var contentHalign : h2d.Flow.FlowAlign;

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
			o.borderWidth = v.borderW;
			o.borderHeight = v.borderH;
		}
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

}

#end
