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
		#if js
		variables.set("Element", js.jquery.JQuery);
		#end
		variables.set("BlendMode", h3d.mat.BlendMode);
		variables.set("Blend", h3d.mat.Data.Blend);
		variables.set("Face", h3d.mat.Data.Face);
		variables.set("Compare", h3d.mat.Data.Compare);
		variables.set("Operation", h3d.mat.Data.Operation);
	}

	#if hscript
	override function getDefaults(?type:String):Any {
		return try getVar("getDefaults")(type) catch( e : hscript.Expr.Error ) { onError(Std.string(e)); {}; }
	}

	override function applyProps(m:Material) {
		try getVar("applyProps")(m) catch( e : hscript.Expr.Error ) onError(Std.string(e));
	}

	#if js
	override function editMaterial( props : Any ) {
		return try getVar("editMaterial")(props) catch( e : hscript.Expr.Error) { onError(Std.string(e)); new js.jquery.JQuery(); }
	}
	#end
	#end

	public function load( script : String, ?fileName : String ) {
		#if !hscript
		onError("-lib hscript is required to load script");
		#else
		if( fileName == null ) fileName = "Renderer.hx";
		this.fileName = fileName;
		var parser = new hscript.Parser();
		var expr = try parser.parseString(script, fileName) catch( e : hscript.Expr.Error ) { onError(Std.string(e)); return; }
		var interp = new hscript.Interp();
		variables = interp.variables;
		initVars();
		try interp.execute(expr) catch( e : hscript.Expr.Error ) { onError(Std.string(e)); return; }
		#end
		name = getVar("name");
	}

}