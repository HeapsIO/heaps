package h2d.comp;
import h2d.comp.CssDefs;

class Component extends Sprite {
	
	public var name(default, null) : String;
	public var id(default, set) : String;
	public var parentComponent(default, null) : Component;
	var classes : Array<String>;
	
	var bg : Fill;
	var width : Float;
	var height : Float;
	var contentWidth : Float = 0.;
	var contentHeight : Float = 0.;
	var style : Style;
	var customStyle : Style;
	var styleSheet : CssEngine;
	var needRebuild(default,set) : Bool;
	
	public function new(name,?parent) {
		super(parent);
		this.name = name;
		classes = [];
		bg = new Fill(this);
		needRebuild = true;
	}
	
	function set_needRebuild(v) {
		needRebuild = v;
		if( v && parentComponent != null && !parentComponent.needRebuild )
			parentComponent.needRebuild = true;
		return v;
	}
		
	override function onAlloc() {
		// lookup our parent component
		var p = parent;
		while( p != null ) {
			var c = flash.Lib.as(p, Component);
			if( c != null ) {
				parentComponent = c;
				needRebuild = true;
				super.onAlloc();
				return;
			}
			p = p.parent;
		}
		parentComponent = null;
		super.onAlloc();
	}
	
	public function addCss(cssString) {
		if( styleSheet == null ) evalStyle();
		styleSheet.addRules(cssString);
		needRebuild = true;
	}
	
	public function setStyle(?s) {
		customStyle = s;
		needRebuild = true;
		return this;
	}
	
	public function getClasses() : Iterable<String> {
		return classes;
	}
	
	public function addClass( name : String ) {
		if( !Lambda.has(classes, name) ) {
			classes.push(name);
			needRebuild = true;
		}
		return this;
	}
	
	public function toggleClass( name : String ) {
		if( !classes.remove(name) )
			classes.push(name);
		needRebuild = true;
		return this;
	}
	
	public function removeClass( name : String ) {
		if( classes.remove(name) )
			needRebuild = true;
		return this;
	}
	
	function set_id(id) {
		this.id = id;
		needRebuild = true;
		return id;
	}
	
	function getFont() {
		return Style.getFont(style.fontName, Std.int(style.fontSize));
	}
	
	function evalStyle() {
		if( parentComponent == null ) {
			if( styleSheet == null )
				styleSheet = Style.getDefault();
		} else {
			styleSheet = parentComponent.styleSheet;
			if( styleSheet == null ) {
				parentComponent.evalStyle();
				styleSheet = parentComponent.styleSheet;
			}
		}
		styleSheet.applyClasses(this);
	}
	
	function resize( r : Resize ) {
		if( r.measure ) {
			width = contentWidth + style.paddingLeft + style.paddingRight + style.borderSize * 2;
			height = contentHeight + style.paddingTop + style.paddingBottom + style.borderSize * 2;
			if( style.width != null ) width = style.width;
			if( style.height != null ) height = style.height;
		} else {
			if( r.xPos != null ) x = r.xPos + style.offsetX + style.paddingLeft + style.borderSize;
			if( r.yPos != null ) y = r.yPos + style.offsetY + style.paddingTop + style.borderSize;
			bg.reset();
			bg.x = -(style.paddingLeft + style.borderSize);
			bg.y = -(style.paddingTop + style.borderSize);
			bg.lineRect(style.borderColor, 0, 0, width, height, style.borderSize);
			bg.fillRect(style.backgroundColor, style.borderSize, style.borderSize, width - style.borderSize * 2, height - style.borderSize * 2);
		}
	}
	
	function resizeRec( r : Resize ) {
		resize(r);
		for( c in childs ) {
			var c = flash.Lib.as(c, Component);
			if( c != null ) c.resizeRec(r);
		}
	}
	
	function evalStyleRec() {
		needRebuild = false;
		evalStyle();
		for( c in childs ) {
			var c = flash.Lib.as(c, Component);
			if( c != null ) c.evalStyleRec();
		}
	}
	
	override function sync( ctx : RenderContext ) {
		if( needRebuild ) {
			evalStyleRec();
			var r = new Resize(ctx.engine.width, ctx.engine.height);
			resizeRec(r);
			r.measure = false;
			resizeRec(r);
		}
		super.sync(ctx);
	}
	
}