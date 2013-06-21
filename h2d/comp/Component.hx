package h2d.comp;
import h2d.css.Defs;

class Component extends Sprite {
	
	public var name(default, null) : String;
	public var id(default, set) : String;
	public var parentComponent(default, null) : Component;
	var classes : Array<String>;
	var components : Array<Component>;
	
	var bg : h2d.css.Fill;
	// the total width and height (includes margin,borders and padding)
	var width : Float;
	var height : Float;
	var contentWidth : Float = 0.;
	var contentHeight : Float = 0.;
	var style : h2d.css.Style;
	var customStyle : h2d.css.Style;
	var styleSheet : h2d.css.Engine;
	var needRebuild(default,set) : Bool;
	
	public function new(name,?parent) {
		super(parent);
		this.name = name;
		classes = [];
		components = [];
		bg = new h2d.css.Fill(this);
		needRebuild = true;
	}
	
	public function getElementById(id:String) {
		if( this.id == id )
			return this;
		if( !allocated )
			return getElementByIdRec(this, id);
		for( c in components ) {
			var c = c.getElementById(id);
			if( c != null )
				return c;
		}
		return null;
	}
	
	function getElementByIdRec( s : h2d.Sprite, id : String ) : Component {
		var c = flash.Lib.as(s, Component);
		if( c != null && c.id == id )
			return c;
		for( s in s.childs ) {
			var c = getElementByIdRec(s, id);
			if( c != null ) return c;
		}
		return null;
	}
	
	function set_needRebuild(v) {
		needRebuild = v;
		if( v && parentComponent != null && !parentComponent.needRebuild )
			parentComponent.needRebuild = true;
		return v;
	}
		
	override function onAlloc() {
		// lookup our parent component
		var old = parentComponent;
		var p = parent;
		while( p != null ) {
			var c = flash.Lib.as(p, Component);
			if( c != null ) {
				parentComponent = c;
				if( old != c ) {
					if( old != null ) old.components.remove(this);
					c.components.push(this);
				}
				needRebuild = true;
				super.onAlloc();
				return;
			}
			p = p.parent;
		}
		if( old != null ) old.components.remove(this);
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
	
	public function addStyle(s) {
		if( customStyle == null )
			customStyle = new h2d.css.Style();
		customStyle.apply(s);
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
	
	public function setClass( name : String, flag : Bool ) {
		if( flag ) addClass(name) else removeClass(name);
		return this;
	}
	
	function set_id(id) {
		this.id = id;
		needRebuild = true;
		return id;
	}
	
	function getFont() {
		return Context.getFont(style.fontName, Std.int(style.fontSize));
	}
	
	function evalStyle() {
		if( parentComponent == null ) {
			if( styleSheet == null )
				styleSheet = Context.getDefaultCss();
		} else {
			styleSheet = parentComponent.styleSheet;
			if( styleSheet == null ) {
				parentComponent.evalStyle();
				styleSheet = parentComponent.styleSheet;
			}
		}
		styleSheet.applyClasses(this);
	}
	
	inline function extLeft() {
		return style.paddingLeft + style.marginLeft + style.borderSize;
	}

	inline function extTop() {
		return style.paddingTop + style.marginTop + style.borderSize;
	}
	
	inline function extRight() {
		return style.paddingRight + style.marginRight + style.borderSize;
	}

	inline function extBottom() {
		return style.paddingBottom + style.marginBottom + style.borderSize;
	}
	
	function resize( c : Context ) {
		if( c.measure ) {
			if( style.width != null ) contentWidth = style.width;
			if( style.height != null ) contentHeight = style.height;
			width = contentWidth + extLeft() + extRight();
			height = contentHeight + extTop() + extBottom();
		} else {
			if( c.xPos != null ) x = c.xPos + style.offsetX + extLeft();
			if( c.yPos != null ) y = c.yPos + style.offsetY + extTop();
			bg.reset();
			bg.x = style.marginLeft - extLeft();
			bg.y = style.marginTop - extTop();
			bg.lineRect(style.borderColor, 0, 0, width - (style.marginLeft + style.marginRight), height - (style.marginTop + style.marginBottom), style.borderSize);
			bg.fillRect(style.backgroundColor, style.borderSize, style.borderSize, contentWidth + style.paddingLeft + style.paddingRight, contentHeight + style.paddingTop + style.paddingBottom);
		}
	}
	
	function resizeRec( ctx : Context ) {
		resize(ctx);
		if( ctx.measure ) {
			for( c in components )
				c.resizeRec(ctx);
		} else {
			var oldx = ctx.xPos;
			var oldy = ctx.yPos;
			ctx.xPos = 0;
			ctx.yPos = 0;
			for( c in components )
				c.resizeRec(ctx);
			ctx.xPos = oldx;
			ctx.yPos = oldy;
		}
	}
	
	function evalStyleRec() {
		needRebuild = false;
		evalStyle();
		for( c in components )
			c.evalStyleRec();
	}
	
	public function refresh() {
		needRebuild = true;
	}
	
	override function sync( ctx : RenderContext ) {
		if( needRebuild ) {
			evalStyleRec();
			var ctx = new Context(ctx.engine.width, ctx.engine.height);
			resizeRec(ctx);
			ctx.measure = false;
			resizeRec(ctx);
		}
		super.sync(ctx);
	}
	
}