package h3d.mat;

class MaterialScript extends MaterialSetup {

	var fileName : String;
	var variables : Map<String,Dynamic>;

	public function new() {
		super("Script");
	}

	public dynamic function onError( msg : String ) {
		throw msg;
	}

	function getVar( name : String ) {
		var v = variables.get(name);
		if( v == null ) onError(fileName + " does not define " + name);
		return v;
	}

	function initVars() {
		variables.set("BlendMode", h3d.mat.BlendMode);
		variables.set("Blend", h3d.mat.Data.Blend);
		variables.set("Face", h3d.mat.Data.Face);
		variables.set("Compare", h3d.mat.Data.Compare);
		variables.set("Operation", h3d.mat.Data.Operation);
		variables.set("this", this);
		#if js
		variables.set("Element", js.jquery.JQuery);
		#end
	}

	function call( name : String, args : Array<Dynamic> ) : Dynamic {
		#if hscript
		try {
			return Reflect.callMethod(this, getVar(name), args);
		} catch( e : hscript.Expr.Error ) {
			onError(Std.string(e));
			return null;
		}
		#else
		throw "Can't call " + name;
		#end
	}

	override function getDefaults(?type:String):Any {
		return call("getDefaults", [type]);
	}

	override function applyProps(m:Material) {
		return call("applyProps", [m]);
	}

	override function initModelMaterial(material:Material) {
		return call("initModelMaterial", [material]);
	}

	#if js
	override function editMaterial( props : Any ) {
		return call("editMaterial", [props]);
	}
	#end

	public function load( script : String, ?fileName : String ) {
		#if !hscript
		onError("-lib hscript is required to load script");
		#else
		if( fileName == null ) fileName = "Renderer.hx";
		this.fileName = fileName;
		var parser = new hscript.Parser();
		parser.allowTypes = true;
		var expr = try parser.parseString(script, fileName) catch( e : hscript.Expr.Error ) { onError(Std.string(e)); return; }
		var interp = new hscript.Interp();
		variables = interp.variables;
		initVars();
		try interp.execute(expr) catch( e : hscript.Expr.Error ) { onError(Std.string(e)); return; }
		#end
		name = getVar("name");
	}

}