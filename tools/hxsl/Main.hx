import js.html.webgl.GL;

enum Output {
	Input;
	Link;
	Split;
	Dce;
	Flatten;
	GLSL;
	HLSL;
}

class Main {

	var text : js.html.TextAreaElement;
	var vars : js.html.TextAreaElement;
	var out : js.html.InputElement;
	var display : js.html.Element;
	var error : js.html.Element;
	var canvas : js.html.CanvasElement;
	var currentOutput = GLSL;
	var codes : Map<Output,String>;
	var showVars : Bool = false;
	var gl : js.html.webgl.RenderingContext;

	function new() {
		var doc = js.Browser.document;

		text = cast doc.getElementById("hxsl");
		out = cast doc.getElementById("outputs");
		error = doc.getElementById("errorLog");
		vars = cast doc.getElementById("vars");
		display = doc.getElementById("display");
		canvas = cast doc.getElementById("canvas");

		var varids : js.html.InputElement = cast doc.getElementById("varids");
		varids.onchange = function(_) {
			showVars = varids.checked;
			rebuild();
		};

		Reflect.setField(doc, "show", function(e:js.html.Element) {
			currentOutput = Output.createByName(e.textContent);
			syncOutput();
			display.textContent = ""+codes.get(currentOutput);

			var store = js.Browser.getLocalStorage();
			store.setItem("select", currentOutput.getName());
		});

		gl = canvas.getContextWebGL();
		for( ext in ['WEBGL_draw_buffers', 'OES_standard_derivatives', 'OES_texture_float', 'OES_texture_float_linear'] )
			gl.getExtension(ext);

		out.onkeyup = rebuild;
		text.onkeyup = rebuild;
		vars.onkeyup = rebuild;

		var store = js.Browser.getLocalStorage();
		var str = store.getItem("hxsl");
		if( str != null && str != "" ) text.value = str;
		str = store.getItem("output");
		if( str != null && str != "" ) out.value = str;
		str = store.getItem("vars");
		if( str != null && str != "" ) vars.value = str;
		str = store.getItem("select");
		if( str != null && str != "" ) try currentOutput = Output.createByName(str) catch( e : Dynamic ) {};
		syncOutput();

		rebuild();

		for( t in doc.getElementsByTagName('textarea') ) {
			var t : js.html.TextAreaElement = cast t;
			t.onkeydown = function(e) {
				if( e.keyCode == 9 ) {
					e.preventDefault();
					var s = t.selectionStart;
					t.value = t.value.substring(0,t.selectionStart) + "\t" + t.value.substring(t.selectionEnd);
					t.selectionEnd = s+1;
				}
			};
		}
	}

	function formatHxsl( e : hxsl.Ast.ShaderData ) {
		return hxsl.Printer.shaderToString(e, showVars);
	}

	function syncOutput() {
		for( e in js.Browser.document.getElementsByTagName("a") ) {
			e.className = e.className.split(" active").join("");
			if( e.textContent == currentOutput.getName() )
				e.className += " active";
		}
	}

	function rebuild() {
		var code = text.value;
		var output = out.value;
		var vars = vars.value;

		var store = js.Browser.getLocalStorage();
		store.setItem("hxsl", code);
		store.setItem("output", output);
		store.setItem("vars", vars);

		var outputs = [for( o in output.split(",") ) hxsl.Output.Value(StringTools.trim(o))];
		codes = new Map();
		try {

			var parser = new hscript.Parser();
			parser.allowMetadata = true;
			parser.allowTypes = true;
			parser.allowJSON = true;

			var vars : Dynamic = new hscript.Interp().execute(parser.parseString(vars));

			var expr = parser.parseString(code);
			var e = new hscript.Macro({ file : "hxsl", min : 0, max : code.length }).convert(expr);
			var ast = new hxsl.MacroParser().parseExpr(e);

			var checker = new hxsl.Checker();
			var checked = checker.check("HxslShader", ast);
			codes.set(Input, formatHxsl(checked));

			var cache = @:privateAccess new hxsl.Cache();
			var outLink = cache.getLinkShader(outputs);

			var shared = new hxsl.SharedShader("");
			shared.data = checked;
			@:privateAccess shared.initialize();
			var shader = new hxsl.DynamicShader(shared);
			for( i in checker.inits )
				shader.hscriptSet(i.v.name, hxsl.Ast.Tools.evalConst(i.e));
			for( v in Reflect.fields(vars) )
				shader.hscriptSet(v, Reflect.field(vars, v));

			var globals = new hxsl.Globals();
			var shaders = [shader, outLink];
			shader.updateConstants(globals);

			var shaderIndex = 0;
			var shaders = [for( s in shaders ) {
				index : shaderIndex++,
				inst : @:privateAccess s.instance,
			}];

			var linker = new hxsl.Linker();
			var linked = linker.link([for( s in shaders ) s.inst.shader]);

			var paramVars = new Map();
			for( v in linker.allVars )
				if( v.v.kind == Param ) {
					switch( v.v.type ) {
					case TStruct(_): continue;
					default:
					}
					var inf = shaders[v.instanceIndex];
					paramVars.set(v.id, { instance : inf.index, index : inf.inst.params.get(v.merged[0].id) } );
				}

			codes.set(Link, formatHxsl(linked));

			var split = new hxsl.Splitter().split(linked);
			codes.set(Split, formatHxsl(split.vertex)+"\n\n"+formatHxsl(split.fragment));

			var dce = new hxsl.Dce().dce(split.vertex, split.fragment);
			codes.set(Dce, formatHxsl(dce.vertex) + "\n\n" + formatHxsl(dce.fragment));

			var r = @:privateAccess cache.buildRuntimeShader(dce.vertex, dce.fragment, paramVars);
			codes.set(Flatten, formatHxsl(r.vertex.data) + "\n\n" + formatHxsl(r.fragment.data)); // todo : add mapping of constants to buffers


			var glsl = new hxsl.GlslOut();
			var reg = ~/[0-9]+\.[0-9]+/;
			var version : String = gl.getParameter(GL.SHADING_LANGUAGE_VERSION);
			if( reg.match(version) ) {
				glsl.glES = Std.parseFloat(reg.matched(0));
				glsl.version = Math.round( Std.parseFloat(reg.matched(0)) * 100 );
			}

			var vertexSource = glsl.run(r.vertex.data);
			var fragmentSource = glsl.run(r.fragment.data);
			codes.set(GLSL, vertexSource+"\n\n" + fragmentSource);

			function compile(source,type) {
				var s = gl.createShader(type);
				gl.shaderSource(s, source);
				gl.compileShader(s);
				if( gl.getShaderParameter(s, GL.COMPILE_STATUS) != cast 1 ) {
					var log = gl.getShaderInfoLog(s);
					var lid = Std.parseInt(log.substr(9));
					var line = lid == null ? null : code.split("\n")[lid - 1];
					if( line == null ) line = "" else line = "(" + StringTools.trim(line) + ")";
					var codeLines = code.split("\n");
					for( i in 0...codeLines.length )
						codeLines[i] = (i + 1) + "\t" + codeLines[i];
					if( log.indexOf("'GL_EXT_draw_buffers' : extension is not supported") > 0 )
						throw "Multiple output not supported (upgrade driver)";
					throw "An error occurred compiling the shaders: " + log + line+"\n\n"+codeLines.join("\n");
				}
				return s;
			}

			var vgl = compile(vertexSource, GL.VERTEX_SHADER);
			var fgl = compile(fragmentSource, GL.FRAGMENT_SHADER);
			var p = gl.createProgram();
			gl.attachShader(p, vgl);
			gl.attachShader(p, fgl);
			gl.linkProgram(p);
			if( gl.getProgramParameter(p, GL.LINK_STATUS) != cast 1 )
				throw gl.getProgramInfoLog(p);
			gl.deleteShader(vgl);
			gl.deleteShader(fgl);
			gl.deleteProgram(p);

			var hlsl = new hxsl.HlslOut();
			codes.set(HLSL, hlsl.run(r.vertex.data) + "\n\n" + hlsl.run(r.fragment.data));
			setError("OK");

		} catch( e : hscript.Expr.Error ) {

			var str = hscript.Printer.errorToString(e);
			setError(str);
		} catch( e : hxsl.Ast.Error ) {
			if( e.pos == null )
				setError(e.msg);
			else
				setError("Line "+code.substr(0,e.pos.min).split("\n").length+": "+e.msg);
		} catch( e : Dynamic ) {
			setError("" + e);
		}

		if( codes.exists(currentOutput) )
			display.textContent = codes.get(currentOutput);
	}

	function setError( msg : String ) {
		error.textContent = msg;
	}

	static function main() {
		new Main();
	}

}