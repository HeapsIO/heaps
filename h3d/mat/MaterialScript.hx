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

	#if hscript
	override function getDefaults(?type:String):Any {
		return try getVar("getDefaults")(type) catch( e : hscript.Expr.Error ) { onError(Std.string(e)); {}; }
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
		#if js
		interp.variables.set("Element", js.jquery.JQuery);
		#end
		try interp.execute(expr) catch( e : hscript.Expr.Error ) { onError(Std.string(e)); return; }
		variables = interp.variables;
		#end
		name = getVar("name");
	}

}