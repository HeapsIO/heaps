package h2d.uikit;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import h2d.uikit.BaseComponents.CustomParser;
import h2d.uikit.Error;
#end

class Macros {

	#if macro

	@:persistent static var COMPONENTS = new Map<String, h2d.uikit.MetaComponent>();
	@:persistent static var _ = initComponents();
	static var __ = addComponents(); // each compilation

	static function initComponents() {
		registerComponent(macro : h2d.uikit.BaseComponents.ObjectComp);
		registerComponent(macro : h2d.uikit.BaseComponents.DrawableComp);
		registerComponent(macro : h2d.uikit.BaseComponents.FlowComp);
		registerComponent(macro : h2d.uikit.BaseComponents.BitmapComp);
		registerComponent(macro : h2d.uikit.BaseComponents.TextComp);
		return 0;
	}

	public static function registerComponent( type : ComplexType ) {
		var pos = Context.currentPos();
		var t = Context.resolveType(type, pos);
		try {
			var mt = new h2d.uikit.MetaComponent(t);
			var td = mt.buildRuntimeComponent();
			Context.defineType(td);
			COMPONENTS.set(mt.name, mt);
		} catch( e : h2d.uikit.MetaComponent.MetaError ) {
			Context.error(e.message, e.position);
		}
	}

	static function addComponents() {
		haxe.macro.Context.onAfterTyping(function(_) {
			for( mt in COMPONENTS )
				Context.resolveType(mt.getRuntimeComponentType(), Context.currentPos());
		});
	}

	static function buildComponentsInit( m : MarkupParser.Markup, fields : Array<haxe.macro.Expr.Field>, pos : Position, isRoot = false ) : Expr {
		switch (m.kind) {
		case Node(name):
			var comp = COMPONENTS.get(name);
			if( comp == null )
				error("Unknown component "+name, m.pmin, m.pmax);
			for( attr in m.attributes ) {
				var p = Property.get(attr.name, false);
				if( p == null ) {
					error("Unknown property "+attr.name, attr.pmin, attr.pmin + attr.name.length);
					continue;
				}
				var h = comp.getHandler(p);
				if( h == null ) {
					error("Component "+comp.name+" does not handle property "+p.name, attr.pmin, attr.pmin + attr.name.length);
					continue;
				}
				var css = try new CssParser().parseValue(attr.value) catch( e : Error ) error("Invalid CSS ("+e.message+")", attr.vmin + e.pmin, attr.vmin + e.pmax);
				try {
					if( h.parser == null ) throw new Property.InvalidProperty("Null parser");
					h.parser(css);
				} catch( e : Property.InvalidProperty ) {
					error("Invalid "+comp.name+"."+p.name+" value '"+attr.value+"'"+(e.message == null ? "" : " ("+e.message+")"), attr.vmin, attr.pmax);
				}
			}
			var attributes = { expr : EObjectDecl([for( m in m.attributes ) { field : m.name, expr : { expr : EConst(CString(m.value)), pos : pos } }]), pos : pos };
			var ct = comp.baseType;
			var exprs : Array<Expr> = if( isRoot )
				[
					(macro document = new h2d.uikit.Document()),
					(macro var tmp = h2d.uikit.Element.create($v{name},$attributes,null,(this : $ct))),
					(macro document.elements.push(tmp)),
				];
			else
				[macro var tmp = h2d.uikit.Element.create($v{name},$attributes, tmp)];
			for( a in m.attributes ) {
				// check parsing
				var css = try new CssParser().parseValue(a.value) catch( e : Error ) { e.pmin += a.pmin; e.pmax += a.pmax; throw e; }
				// check name
				if( a.name == "name" ) {
					var field = a.value;
					exprs.push(macro this.$field = cast tmp.obj);
					fields.push({
						name : field,
						access : [APublic],
						pos : makePos(pos, a.pmin, a.pmax),
						kind : FVar(ct),
					});
				}
			}
			for( c in m.children ) {
				var e = buildComponentsInit(c, fields, pos);
				if( e != null ) exprs.push(e);
			}
			return macro $b{exprs};
		case Text(text):
			var text = StringTools.trim(text);
			if( text == "" ) return null;
			return macro {
				var tmp = h2d.uikit.Element.create("text",null,tmp);
				tmp.setAttribute("text",VString($v{text}));
			};
		}
	}

	public static function buildObject() {
		var fields = Context.getBuildFields();
		for( f in fields )
			if( f.name == "SRC" ) {
				switch( f.kind ) {
				case FVar(_,{ expr : EMeta(_,{ expr : EConst(CString(str)) }), pos : pos }):
					try {
						var p = new MarkupParser();
						var root = p.parse(str).children[0];

						var expr = buildComponentsInit(root, fields, pos, true);
						fields = fields.concat((macro class {
							public var document : h2d.uikit.Document;
							public function setStyle( style : h2d.uikit.CssStyle ) {
								document.setStyle(style);
							}
						}).fields);
						fields.push({
							name : "initComponent",
							pos : pos,
							kind : FFun({
								args : [],
								ret : null,
								expr : expr,
							}),
						});

					} catch( e : Error ) {
						Context.error(e.message, makePos(pos,e.pmin,e.pmax));
					}
					fields.remove(f);
					break;
				default:
				}
			}
		return fields;
	}


	static function error( msg : String, pmin : Int, pmax : Int = -1 ) : Dynamic {
		throw new Error(msg, pmin, pmax);
	}

	static function makePos( p : Position, pmin : Int, pmax : Int ) {
		var p0 = Context.getPosInfos(p);
		return Context.makePosition({ min : p0.min + pmin, max : p0.min + pmax, file : p0.file });
	}

	#end

}