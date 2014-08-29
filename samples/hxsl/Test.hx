
class Test {

	@:access(hxsl)
	static function main() {
		var shaders = [
			new h3d.shader.BaseMesh(),
			new h3d.shader.PointLight(),
		];
		var globals = new hxsl.Globals();
		globals.set("global.perPixelLighting", true);
		var instances = [for( s in shaders ) { s.updateConstants(globals); s.instance; } ];
		var cache = hxsl.Cache.get();
		var s = cache.link(instances, cache.allocOutputVars(["output.position", "output.color"]));
		trace("VERTEX=\n" + hxsl.Printer.shaderToString(s.vertex.data,true));
		trace("FRAGMENT=\n" + hxsl.Printer.shaderToString(s.fragment.data,true));

		#if js
		haxe.Log.trace("START");
		try {

		var canvas = js.Browser.document.createCanvasElement();
		var gl = canvas.getContextWebGL();
		var GL = js.html.webgl.GL;
		var glout = new hxsl.GlslOut();

		function compile(kind, shader) {
			var code = glout.run(shader);
			var s = gl.createShader(kind);
			gl.shaderSource(s, code);
			gl.compileShader(s);
			if( gl.getShaderParameter(s, GL.COMPILE_STATUS) != cast 1 ) {
				var log = gl.getShaderInfoLog(s);
				var line = code.split("\n")[Std.parseInt(log.substr(9)) - 1];
				if( line == null ) line = "" else line = "(" + StringTools.trim(line) + ")";
				throw log + line;
			}
			return s;
		}

		var vs = compile(GL.VERTEX_SHADER, s.vertex.data);
		var fs = compile(GL.FRAGMENT_SHADER, s.fragment.data);

		var p = gl.createProgram();
		gl.attachShader(p, vs);
		gl.attachShader(p, fs);
		gl.linkProgram(p);
		if( gl.getProgramParameter(p, GL.LINK_STATUS) != cast 1 ) {
			var log = gl.getProgramInfoLog(p);
			throw "Program linkage failure: "+log;
		}

		trace("LINK SUCCESS");

		} catch( e : Dynamic ) {
			trace(e);
		}

		#end
	}

}