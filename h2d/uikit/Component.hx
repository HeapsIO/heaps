package h2d.uikit;
import h2d.uikit.Property;

typedef BaseObject = #if macro Dynamic #else h2d.Object #end;

class PropertyHandler<O,P> {

	public var parser(default,null) : CssValue -> P;
	#if macro
	public var defaultValue(default,null) : haxe.macro.Expr;
	public var type(default,null) : haxe.macro.Expr.ComplexType;
	#else
	public var defaultValue(default,null) : P;
	public var apply(default,null) : O -> P -> Void;
	#end

	public function new(parser,def,applyType) {
		this.parser = parser;
		this.defaultValue = def;
		#if macro
		this.type = applyType;
		#else
		this.apply = applyType;
		#end
	}
}

interface ComponentDecl<T:BaseObject> {
}

class Component<T:BaseObject> {

	public var name : String;
	public var make : BaseObject -> T;
	public var parent : Component<Dynamic>;
	var propsHandler : Array<PropertyHandler<T,Dynamic>>;

	public function new(name, make, parent) {
		this.name = name;
		this.make = make;
		this.parent = parent;
		propsHandler = parent == null ? [] : cast parent.propsHandler.copy();
		COMPONENTS.set(name, this);
	}

	public inline function getHandler<P>( p : Property ) : PropertyHandler<T,P> {
		return cast propsHandler[p.id];
	}

	function addHandler<P>( p : String, parser : CssValue -> P, def : #if macro haxe.macro.Expr #else P #end, applyType : #if macro haxe.macro.Expr.ComplexType #else T -> P -> Void #end ) {
		propsHandler[Property.get(p).id] = new PropertyHandler(parser,def,applyType);
	}

	public static function get( name : String ) {
		return COMPONENTS.get(name);
	}

	static var COMPONENTS = new Map<String,Component<Dynamic>>();

}
