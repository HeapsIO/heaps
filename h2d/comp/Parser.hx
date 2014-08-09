package h2d.comp;

#if hscript
private class CustomInterp extends hscript.Interp {
	override function fcall(o:Dynamic, f:String, args:Array<Dynamic>):Dynamic {
		if( Std.is(o, h2d.comp.JQuery) && Reflect.field(o,f) == null ) {
			var rf = args.length == 0 ? "_get_" + f : "_set_" + f;
			if( Reflect.field(o, rf) == null ) throw "JQuery don't have " + f + " implemented";
			f = rf;
		}
		if( Reflect.field(o, f) == null )
			throw o + " does not have method " + f;
		return super.fcall(o, f, args);
	}
}
#end

class Parser {

	var comps : Map < String, haxe.xml.Fast -> Component -> Component > ;
	#if hscript
	var interp : hscript.Interp;
	#end
	var root : Component;

	public function new(?api:{}) {
		comps = new Map();
		#if hscript
		interp = new CustomInterp();
		interp.variables.set("$", function(rq) return new h2d.comp.JQuery(root, rq));
		interp.variables.set("api", api);
		if( api != null )
			for( f in Reflect.fields(api) )
				interp.variables.set(f, Reflect.field(api, f));
		#end
	}

	public function build( x : haxe.xml.Fast, ?parent : Component ) {
		var c : Component;
		switch( x.name.toLowerCase() ) {
		case "body":
			c = new Box(Absolute, parent);
		case "style":
			parent.addCss(x.innerData);
			return null;
		case "script":
			makeScript(null, x.innerData)();
			return null;
		case "div", "box":
			c = new Box(parent);
		case "button":
			c = new Button(x.has.value ? x.att.value : "", parent);
		case "slider":
			c = new Slider(parent);
		case "label", "span":
			c = new Label(x.x.firstChild() == null ? "" : x.innerData, parent);
		case "h1", "h2", "h3", "h4":
			c = new Label(x.x.firstChild() == null ? "" : x.innerData, parent);
			c.addClass(":" + x.name.toLowerCase());
		case "checkbox":
			c = new Checkbox(parent);
		case "itemlist":
			c = new ItemList(parent);
		case "input":
			c = new Input(parent);
		case "color":
			c = new Color(parent);
		case "colorpicker":
			c = new ColorPicker(parent);
		case "gradienteditor":
			c = new GradientEditor(parent);
		case "select":
			c = new Select(parent);
		case "option":
			if( parent == null || parent.name != "select" )
				throw "<option/> needs 'select' parent";
			var select = Std.instance(parent, Select);
			var label = x.innerData;
			var value = x.has.value ? x.att.value : null;
			select.addOption(label, value);
			if( x.has.selected && x.att.selected != "false" )
				select.selectedIndex = select.getOptions().length - 1;
			return null;
		case "value":
			c = new Value(parent);
		case n:
			var make = comps.get(n);
			if( make != null )
				c = make(x, parent);
			else
				throw "Unknown node " + n;
		}
		if( root == null ) root = c;
		for( n in x.x.attributes() ) {
			var v = x.x.get(n);
			switch( n.toLowerCase() ) {
			case "class":
				for( cl in v.split(" ") ) {
					var cl = StringTools.trim(cl);
					if( cl.length > 0 ) c.addClass(cl);
				}
			case "id":
				c.id = v;
			case "value":
				switch( c.name ) {
				case "slider":
					var c : Slider = cast c;
					c.value = Std.parseFloat(v);
				case "input":
					var c : Input = cast c;
					c.value = v;
				case "color":
					var c : Color = cast c;
					c.value = Std.parseInt(v);
				case "value":
					var c : Value = cast c;
					c.value = Std.parseFloat(v);
				default:
				}
			case "onchange":
				switch( c.name ) {
				case "slider":
					var c : Slider = cast c;
					var s = makeScript(c,v);
					c.onChange = function(_) s();
				case "checkbox":
					var c : Checkbox = cast c;
					var s = makeScript(c,v);
					c.onChange = function(_) s();
				case "itemlist":
					var c : ItemList = cast c;
					var s = makeScript(c,v);
					c.onChange = function(_) s();
				case "input":
					var c : Input = cast c;
					var s = makeScript(c,v);
					c.onChange = function(_) s();
				case "color":
					var c : Color = cast c;
					var s = makeScript(c,v);
					c.onChange = function(_) s();
				case "select":
					var c : Select = cast c;
					var s = makeScript(c,v);
					c.onChange = function(_) s();
				case "value":
					var c : Value = cast c;
					var s = makeScript(c,v);
					c.onChange = function(_) s();
				default:
				}
			case "onblur":
				switch( c.name ) {
				case "input":
					var c : Input = cast c;
					c.onBlur = makeScript(c,v);
				default:
				}
			case "onfocus":
				switch( c.name ) {
				case "input":
					var c : Input = cast c;
					c.onFocus = makeScript(c,v);
				default:
				}
			case "style":
				var s = new h2d.css.Style();
				new h2d.css.Parser().parse(v, s);
				c.setStyle(s);
			case "selected":
				switch( c.name ) {
				case "itemlist":
					var c : ItemList = cast c;
					c.selected = Std.parseInt(v);
				default:
				}
			case "checked":
				switch( c.name ) {
				case "checkbox":
					var c : Checkbox = cast c;
					c.checked = v != "false";
				default:
				}
			case "x":
				c.x = Std.parseFloat(v);
			case "y":
				c.y = Std.parseFloat(v);
			case "min":
				switch( c.name ) {
				case "slider":
					var c : Slider = cast c;
					c.minValue = Std.parseFloat(v);
				case "value":
					var c : Value = cast c;
					c.minValue = Std.parseFloat(v);
				default:
				}
			case "max":
				switch( c.name ) {
				case "slider":
					var c : Slider = cast c;
					c.maxValue = Std.parseFloat(v);
				case "value":
					var c : Value = cast c;
					c.maxValue = Std.parseFloat(v);
				default:
				}
			case "increment":
				switch( c.name ) {
				case "value":
					Std.instance(c, Value).increment = Std.parseFloat(v);
				default:
				}
			case "onmouseover":
				var int = Std.instance(c, Interactive);
				if( int != null )
					int.onMouseOver = makeScript(c, v);
			case "onmouseout":
				var int = Std.instance(c, Interactive);
				if( int != null )
					int.onMouseOut = makeScript(c, v);
			case "onmousedown":
				var int = Std.instance(c, Interactive);
				if( int != null )
					int.onMouseDown = makeScript(c, v);
			case "onmouseup":
				var int = Std.instance(c, Interactive);
				if( int != null )
					int.onMouseUp = makeScript(c, v);
			case "onclick":
				var int = Std.instance(c, Interactive);
				if( int != null )
					int.onClick = makeScript(c, v);
			case "onrclick":
				var int = Std.instance(c, Interactive);
				if( int != null )
					int.onRightClick = makeScript(c, v);
			case "disabled":
				if( v != "false" )
					c.addClass(":disabled");
			case n:
				throw "Unknown attrib " + n;
			}
		}
		for( e in x.elements )
			build(e, c);
		return c;
	}

	public function register(name, make) {
		this.comps.set(name, make);
	}

	function makeScript( c : Component, script : String ) {
		#if hscript
		var p = new hscript.Parser();
		p.identChars += "$";
		var e = null;
		try {
			e = p.parseString(script);
		} catch( e : hscript.Expr.Error ) {
			throw "Invalid Script line " + p.line + " (" + e+ ")";
		}
		return function() {
			interp.variables.set("this", c);
			try interp.execute(e) catch( e : String ) throw "Error while running script " + script + " (" + e + ")" catch( e : hscript.Expr.Error ) throw "Error while running script " + script + " (" + e + ")" ;
		};
		#else
		return function() throw "Please compile with -lib hscript to get script access";
		#end
	}

	public static function fromHtml( html : String, ?api ) : Component {
		function lookupBody(x:Xml) {
			if( x.nodeType == Xml.Element && x.nodeName.toLowerCase() == "body" )
				return x;
			if( x.nodeType == Xml.PCData )
				return null;
			for( e in x ) {
				var v = lookupBody(e);
				if( v != null ) return v;
			}
			return null;
		}
		var x = Xml.parse(html);
		var body = lookupBody(x);
		if( body == null ) {
			body = Xml.createElement("body");
			for( e in x )
				body.addChild(e);
		}
		return new Parser(api).build(new haxe.xml.Fast(body),null);
	}

}