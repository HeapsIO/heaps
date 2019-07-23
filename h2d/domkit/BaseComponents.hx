package h2d.domkit;
import domkit.Property;
import domkit.CssValue;

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


	function parseColorF( v : CssValue ) : h3d.Vector {
		var c = parseColor(v);
		var v = new h3d.Vector();
		v.setColor(c);
		return v;
	}

	function loadResource( path : String ) {
		#if macro
		// TODO : compile-time path check?
		return true;
		#else
		return try hxd.res.Loader.currentInstance.load(path) catch( e : hxd.res.NotFound ) invalidProp("Resource not found "+path);
		#end
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
			case VCall("tile",[VString(url),VInt(vsplit)]):
				var p = loadResource(url);
				return #if macro p #else { var t = p.toTile(); t.sub(0,0,t.iwidth,Std.int(t.iheight/vsplit)); } #end;
			case VCall("tile",[VString(url),VInt(vsplit),VInt(hsplit)]):
				var p = loadResource(url);
				return #if macro p #else { var t = p.toTile(); t.sub(0,0,Std.int(t.iwidth/hsplit),Std.int(t.iheight/vsplit)); } #end;
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
		switch(value) {
			case VGroup(args):
				path = parsePath(args[0]);
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
			default:
				path = parsePath(value);
		}
		var res = loadResource(path);
		#if macro
		return res;
		#else
		if(sdf != null)
			return res.to(hxd.res.BitmapFont).toSdfFont(sdf.size, sdf.channel, sdf.cutoff, sdf.smooth);
		else
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

	public function parseTilePos(value) : { y : Int, ?x : Int } {
		return switch( value ) {
		case VInt(y): { y : y, x : null };
		case VGroup([VInt(y),VInt(x)]): { y : y, x : x };
		default: invalidProp();
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

}

#if !macro
@:uiComp("object") @:parser(h2d.domkit.BaseComponents.CustomParser)
class ObjectComp implements h2d.domkit.Object implements domkit.Component.ComponentDecl<h2d.Object> {

	@:p var x : Float;
	@:p var y : Float;
	@:p var alpha : Float = 1;
	@:p var rotation : Float;
	@:p var visible : Bool;
	@:p(scale) var scale : { x : Float, y : Float };
	@:p var scaleX : Float;
	@:p var scaleY : Float;
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
		if(v != null) {
			o.scaleX = v.x;
			o.scaleY = v.y;
		}
		else {
			o.setScale(1);
		}
	}

	static function set_blend(o:h2d.Object, b:h2d.BlendMode) {
		o.blendMode = b;
	}

	static function getFlowProps( o : h2d.Object ) {
		var p = hxd.impl.Api.downcast(o.parent, h2d.Flow);
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

	@:keep static var init = {
		domkit.Element.addElement = function(e, parent) {
			(e.obj : h2d.Object).name = e.id;
			(parent.obj : h2d.Object).addChild(e.obj);
		}
		domkit.Element.removeElement = function(e) (e.obj : h2d.Object).remove();
		domkit.Element.getParent = function(e:h2d.Object) return e.parent;
		true;
	}

}

@:uiComp("drawable")
class DrawableComp extends ObjectComp implements domkit.Component.ComponentDecl<h2d.Drawable> {

	@:p(colorF) var color : h3d.Vector;
	@:p(auto) var smooth : Null<Bool>;
	@:p var tileWrap : Bool;

	static function set_color( o : h2d.Drawable, v ) {
		if(v != null)
			o.color.load(v);
		else
			o.color.set(1,1,1);
	}
}

@:uiComp("mask")
class MaskComp extends ObjectComp implements domkit.Component.ComponentDecl<h2d.Mask> {
	@:p var width : Int;
	@:p var height : Int;

	static function create( parent : h2d.Object ) {
		return new h2d.Mask(0,0,parent);
	}
}

@:uiComp("bitmap")
class BitmapComp extends DrawableComp implements domkit.Component.ComponentDecl<h2d.Bitmap> {

	@:p(tile) var src : h2d.Tile;

	static function create( parent : h2d.Object ) {
		return new h2d.Bitmap(h2d.Tile.fromColor(0xFF00FF,32,32,0.9),parent);
	}

	static function set_src( o : h2d.Bitmap, t ) {
		o.tile = t == null ? h2d.Tile.fromColor(0xFF00FF,32,32,0.9) : t;
	}

}

@:uiComp("text")
class TextComp extends DrawableComp implements domkit.Component.ComponentDecl<h2d.Text> {

	@:p var text : String = "";
	@:p(font) var font : h2d.Font;
	@:p var letterSpacing = 1;
	@:p var lineSpacing = 0;
	@:p(none) var maxWidth : Null<Int>;
	@:p var textAlign : h2d.Text.Align = Left;
	@:p(textShadow) var textShadow : { dx : Float, dy : Float, color : Int, alpha : Float };
	@:p(color) var textColor: Int;

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

@:uiComp("html-text")
class HtmlTextComp extends TextComp implements domkit.Component.ComponentDecl<h2d.HtmlText> {
	@:p var condenseWhite : Bool;

	static function create( parent : h2d.Object ) {
		return new h2d.HtmlText(hxd.res.DefaultFont.get(),parent);
	}
}


@:uiComp("flow")
class FlowComp extends ObjectComp implements domkit.Component.ComponentDecl<h2d.Flow> {

	@:p(auto) var width : Null<Int>;
	@:p(auto) var height : Null<Int>;
	@:p var maxWidth : Null<Int>;
	@:p var maxHeight : Null<Int>;
	@:p(flowBackground) var background : { tile : h2d.Tile, borderW : Int, borderH : Int };
	@:p(tile) var backgroundTile : h2d.Tile;
	@:p(tilePos) var backgroundTilePos : { y : Int, ?x : Int };
	@:p var backgroundAlpha : Float;
	@:p var backgroundSmooth : Bool;
	@:p(colorF) var backgroundColor : h3d.Vector;
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
	@:p var overflow: Bool;

	@:p(align) var contentAlign : { h : h2d.Flow.FlowAlign, v : h2d.Flow.FlowAlign };
	@:p(vAlign) var contentValign : h2d.Flow.FlowAlign;
	@:p(hAlign) var contentHalign : h2d.Flow.FlowAlign;
	@:p(cursor) var cursor : hxd.Cursor;

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

	static function set_backgroundTile( o : h2d.Flow, t ) {
		o.backgroundTile = t;
	}

	static function set_backgroundTilePos( o : h2d.Flow, p : { ?x : Int, y : Int } ) {
		var t = o.backgroundTile;
		if( t != null ) {
			t = t.clone();
			if( p == null ) t.setPosition(0,0) else t.setPosition(p.x == null ? t.x : p.x * t.width, p.y * t.height);
			o.backgroundTile = t;
		}
	}

	static function set_backgroundAlpha( o : h2d.Flow, v ) {
		var bg = @:privateAccess o.background;
		if(bg == null)
			return;
		bg.alpha = v;
	}

	static function set_backgroundSmooth( o : h2d.Flow, v ) {
		var bg = @:privateAccess o.background;
		if(bg == null)
			return;
		bg.smooth = v;
	}

	static function set_backgroundColor( o : h2d.Flow, v ) {
		var bg = @:privateAccess o.background;
		if(bg == null)
			return;
		if(v == null)
			bg.color.set(1,1,1,1);
		else
			bg.color.load(v);
	}

	static function set_cursor( o : h2d.Flow, c ) {
		if( o.interactive == null ) o.enableInteractive = true;
		o.interactive.cursor = c;
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
	}
}

@:uiComp("input")
class InputComp extends TextComp implements domkit.Component.ComponentDecl<h2d.TextInput> {

	@:p(auto) var width : Null<Int>;
	@:p(tile) var cursor : h2d.Tile;
	@:p(tile) var selection : h2d.Tile;
	@:p var edit : Bool;
	@:p(color) var backgroundColor : Null<Int>;

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

}

#end
