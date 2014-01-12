package h3d.impl;
#if macro
import haxe.macro.Context;
#end

#if flash
typedef Shader = hxsl.Shader;
#elseif (js || cpp)

enum ShaderType {
	Float;
	Vec2;
	Vec3;
	Vec4;
	Mat2;
	Mat3;
	Mat4;
	Tex2d;
	TexCube;
	Byte3;
	Byte4;
	Struct( field : String, t : ShaderType );
	Index( index : Int, t : ShaderType );
}

typedef Uniform = { name : String, loc : #if js js.html.webgl.UniformLocation #else openfl.gl.GLUniformLocation #end, type : ShaderType, index : Int }

class ShaderInstance {

	public var program : #if js js.html.webgl.Program #else openfl.gl.GLProgram #end;
	public var attribs : Array<{ name : String, type : ShaderType, etype : Int, offset : Int, index : Int, size : Int }>;
	public var uniforms : Array<Uniform>;
	public var stride : Int;
	public function new() {
	}

}

@:autoBuild(h3d.impl.Shader.ShaderMacros.buildGLShader())
class Shader {
	
	var instance : ShaderInstance;
	
	public function new() {
	}
	
	function customSetup( driver : h3d.impl.GlDriver ) {
	}
	
	function getConstants( vertex : Bool ) {
		return "";
	}

}

#else

class Shader implements Dynamic {
	public function new() {
	}
}

#end

#if macro
class ShaderMacros {
	
	public static function buildGLShader() {
		var pos = Context.getLocalClass().get().pos;
		var fields = Context.getBuildFields();
		var hasVertex = false, hasFragment = false;
		var r_uni = ~/uniform[ \t]+((lowp|mediump|highp)[ \t]+)?([A-Za-z0-9_]+)[ \t]+([A-Za-z0-9_]+)[ \t]*(\/\*([A-Za-z0-9_]+)\*\/)?/;
		function addUniforms( code : String ) {
			while( r_uni.match(code) ) {
				var name = r_uni.matched(4);
				var type = r_uni.matched(3);
				var hint = r_uni.matched(6);
				code = r_uni.matchedRight();
				var t = switch( type ) {
				case "float": macro : Float;
				case "vec4", "vec3" if( hint == "byte4" ): macro : Int;
				case "vec2", "vec3", "vec4": macro : h3d.Vector;
				case "mat3", "mat4": macro : h3d.Matrix;
				case "sampler2D", "samplerCube": macro : h3d.mat.Texture;
				default:
					// most likely a struct, handle it manually
					if( type.charCodeAt(0) >= 'A'.code && type.charCodeAt(0) <= 'Z'.code )
						continue;
					throw "Unsupported type " + type;
				}
				if( code.charCodeAt(0) == '['.code )
					t = macro : Array<$t>;
				fields.push( {
					name : name,
					kind : FVar(t),
					pos : pos,
					access : [APublic],
				});
			}
		}
		for( f in fields )
			switch( [f.name, f.kind] ) {
			case ["VERTEX", FVar(_,{ expr : EConst(CString(code)) }) ]:
				hasVertex = true;
				addUniforms(code);
				f.meta.push( { name : ":keep", params : [], pos : pos } );
			case ["FRAGMENT", FVar(_,{ expr : EConst(CString(code)) })]:
				hasFragment = true;
				addUniforms(code);
				f.meta.push( { name : ":keep", params : [], pos : pos } );
			default:
			}
		if( !hasVertex )
			haxe.macro.Context.error("Missing VERTEX shader", pos);
		if( !hasFragment )
			haxe.macro.Context.error("Missing FRAGMENT shader", pos);
		return fields;
	}
	
}
#end
