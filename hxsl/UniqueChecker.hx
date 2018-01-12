package hxsl;
import haxe.crypto.Sha1.encode;
import hxsl.Ast;

class UniqueChecker {

	var signatures = new Map<String,Int>();
	var compile : Ast.ShaderData -> String;

	function new() {
	}

	function duplicate( shader : ShaderData ) : ShaderData {
		var ser = new haxe.Serializer();
		ser.useCache = true;
		ser.useEnumIndex = true;
		ser.serialize(shader);
		return haxe.Unserializer.run(ser.toString());
	}

	function lookForMorph( shader : RuntimeShader.RuntimeShaderData, id : Int ) {

		var sdata = duplicate(shader.data);
		remapVars(sdata);
		var remaped = hxsl.Printer.shaderToString(sdata);
		var sign = encode(remaped);
		if( signatures.exists(sign) )
			return { type : "isomorph", id : signatures.get(sign) };
		signatures.set(sign, id);

		sdata = duplicate(shader.data);
		remapVars(sdata, true);

		var gllines = [for( l in compile(sdata).split("\n") ) StringTools.trim(l)];
		gllines.sort(Reflect.compare);
		var sign = encode(gllines.join("\n"));
		if( signatures.exists(sign) )
			return { type : "quasi-isomorph", id : signatures.get(sign) };
		signatures.set(sign, id);

		return null;
	}

	public function add( shader : RuntimeShader, compile : Ast.ShaderData -> String ) {

		this.compile = compile;

		var vertexCode = compile(shader.vertex.data);
		var fragmentCode = compile(shader.fragment.data);
		var sign = encode(vertexCode + "@" + fragmentCode);

		if( signatures.exists(sign) ) {
			Sys.println("**** Shader " + shader.id + " is a duplicate of " + signatures.get(sign)+" ****");
			return;
		}

		var head = "Shader " + sign;
		var str = head + "\n\n" + vertexCode+"\n\n" + fragmentCode + "\n\n" + hxsl.Printer.shaderToString(shader.vertex.data, true)+ "\n\n" + hxsl.Printer.shaderToString(shader.fragment.data, true);
		sys.io.File.saveContent("shaders/" + shader.id + "_" + sign + ".c", str);
		signatures.set(sign, shader.id);

		var checkV = lookForMorph(shader.vertex, shader.id);
		var checkF = lookForMorph(shader.fragment, shader.id);
		var extra = "";

		if( checkV != null || checkF != null ) {
			var v = checkV == null ? checkF : checkV;
			extra = " (" + (v == checkV ? "vertex" : "fragment") + " " + v.type+" with " + v.id + ")";
		}

		Sys.println("Shader " + shader.id+ " "+sign+extra);

		if( checkV != null && checkF != null && checkV.id == checkF.id ) {
			var v = checkF;
			Sys.println("**** Shader " + shader.id + " is " + v.type+" with shader " + v.id + " **** ");
		}
	}

	static var inst : UniqueChecker;
	public static function get() {
		if( inst == null ) inst = new UniqueChecker();
		return inst;
	}

	function remapVars( s : ShaderData, rawName = false ) {

		var vid = 1;
		var vars = new Map<TVar,Bool>();

		function getRaw( name : String ) {
			while( name.charCodeAt(name.length - 1) >= '0'.code && name.charCodeAt(name.length - 1) <= '9'.code )
				name = name.substr(0, -1);
			return name;
		}

		function remapVar( v : TVar ) {
			if( v.parent != null )
				remapVar(v.parent);
			if( vars.exists(v) )
				return;
			vars.set(v, true);
			v.id = vid++;
			v.name = rawName ? getRaw(v.name) : "@"+v.id;
			switch( v.type ) {
			case TStruct(vl):
				for( v in vl ) remapVar(v);
			default:
			}
		}

		function remapExpr( e : TExpr ) {
			switch( e.e ) {
			case TVarDecl(v, _): remapVar(v);
			case TFor(v, _, _): remapVar(v);
			default:
			}
			Tools.iter(e, remapExpr);
		}

		for( v in s.vars )
			remapVar(v);
		for( f in s.funs ) {
			if( f.ref != null )
				remapVar(f.ref);
			for( v in f.args )
				remapVar(v);
			remapExpr(f.expr);
		}

	}

}