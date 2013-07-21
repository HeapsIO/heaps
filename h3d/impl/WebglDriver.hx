package h3d.impl;
import h3d.impl.Driver;

#if js

private typedef GL = js.html.webgl.GL;

@:access(h3d.impl.Shader)
class WebglDriver extends Driver {

	var canvas : js.html.CanvasElement;
	var gl : js.html.webgl.RenderingContext;
	
	var curAttribs : Int;
	var curShader : Shader.ShaderInstance;
	
	public function new() {
		canvas = cast js.Browser.document.getElementById("webgl");
		if( canvas == null ) throw "Canvas #webgl not found";
		gl = canvas.getContextWebGL();
		if( gl == null ) throw "Could not acquire GL context";
		// debug if webgl_debug.js is included
		untyped if( __js__('typeof')(WebGLDebugUtils) != "undefined" ) gl = untyped WebGLDebugUtils.makeDebugContext(gl);
		gl.enable(GL.DEPTH_TEST);
	}
	
	override function reset() {
		curShader = null;
		gl.useProgram(null);
	}
	
	override function selectMaterial( mbits : Int ) {
		gl.depthFunc(GL.LESS);
		gl.cullFace(GL.BACK);
	}
	
	override function clear( r : Float, g : Float, b : Float, a : Float ) {
		gl.clearColor(r, g, b, a);
		gl.clearDepth(1);
		gl.clear(GL.COLOR_BUFFER_BIT|GL.DEPTH_BUFFER_BIT);
	}
	
	override function resize(width, height, aa:Int) {
		canvas.width = width;
		canvas.height = height;
		gl.viewport(0, 0, width, height);
	}
	
	override function allocTexture( t : h3d.mat.Texture ) : Texture {
		var tt = gl.createTexture();
		gl.bindTexture(GL.TEXTURE_2D, tt);
		gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, t.width, t.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, null);
		gl.bindTexture(GL.TEXTURE_2D, null);
		return tt;
	}
	
	override function allocVertex( count : Int, stride : Int ) : VertexBuffer {
		var b = gl.createBuffer();
		gl.bindBuffer(GL.ARRAY_BUFFER, b);
		gl.bufferData(GL.ARRAY_BUFFER, count * stride * 4, GL.STATIC_DRAW);
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
		untyped b.stride = stride;
		return b;
	}
	
	override function allocIndexes( count : Int ) : IndexBuffer {
		var b = gl.createBuffer();
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, b);
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, count * 2, GL.STATIC_DRAW);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		return b;
	}

	override function disposeTexture( t : Texture ) {
		gl.deleteTexture(t);
	}

	override function disposeIndexes( i : IndexBuffer ) {
		gl.deleteBuffer(i);
	}
	
	override function disposeVertex( v : VertexBuffer ) {
		gl.deleteBuffer(v);
	}
	
	override function uploadTextureBytes( t : h3d.mat.Texture, bytes : haxe.io.Bytes, mipLevel : Int, side : Int ) {
		gl.bindTexture(GL.TEXTURE_2D, t.t);
		var pixels = new js.html.Uint8Array(bytes.getData());
		gl.texImage2D(GL.TEXTURE_2D, mipLevel, GL.RGBA, t.width, t.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixels);
		gl.bindTexture(GL.TEXTURE_2D, null);
	}
	
	override function uploadVertexBuffer( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : hxd.FloatBuffer, bufPos : Int ) {
		var stride : Int = untyped v.stride;
		var buf = new js.html.Float32Array(buf.getNative());
		gl.bindBuffer(GL.ARRAY_BUFFER, v);
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, new js.html.Float32Array(buf.buffer, bufPos, vertexCount * stride));
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
	}

	override function uploadVertexBytes( v : VertexBuffer, startVertex : Int, vertexCount : Int, buf : haxe.io.Bytes, bufPos : Int ) {
		var stride : Int = untyped v.stride;
		var buf = new js.html.Uint8Array(buf.getData());
		gl.bindBuffer(GL.ARRAY_BUFFER, v);
		gl.bufferSubData(GL.ARRAY_BUFFER, startVertex * stride * 4, new js.html.Uint8Array(buf.buffer, bufPos, vertexCount * stride * 4));
		gl.bindBuffer(GL.ARRAY_BUFFER, null);
	}

	override function uploadIndexesBuffer( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : hxd.IndexBuffer, bufPos : Int ) {
		var buf = new js.html.Uint16Array(buf.getNative());
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, i);
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice * 2, new js.html.Uint16Array(buf.buffer, bufPos, indiceCount));
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}

	override function uploadIndexesBytes( i : IndexBuffer, startIndice : Int, indiceCount : Int, buf : haxe.io.Bytes , bufPos : Int ) {
		var buf = new js.html.Uint8Array(buf.getData());
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, i);
		gl.bufferSubData(GL.ELEMENT_ARRAY_BUFFER, startIndice * 2, new js.html.Uint8Array(buf.buffer, bufPos, indiceCount * 2));
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}
	
	function decodeType( t : String ) : Shader.ShaderType {
		return switch( t ) {
		case "float": Float;
		case "vec2": Vec2;
		case "vec3": Vec3;
		case "vec4": Vec4;
		case "mat4": Mat4;
		default: throw "Unknown type " + t;
		}
	}
	
	function decodeTypeInt( t : Int ) : Shader.ShaderType {
		return switch( t ) {
		case GL.SAMPLER_2D:	Tex2d;
		case GL.SAMPLER_CUBE: TexCube;
		case GL.FLOAT: Float;
		case GL.FLOAT_VEC2: Vec2;
		case GL.FLOAT_VEC3: Vec3;
		case GL.FLOAT_VEC4: Vec4;
		case GL.FLOAT_MAT2: Mat2;
		case GL.FLOAT_MAT3: Mat3;
		case GL.FLOAT_MAT4: Mat4;
		default:
			gl.pixelStorei(t, 0); // get DEBUG value
			throw "Unknown type " + t;
		}
	}
	
	function typeSize( t : Shader.ShaderType ) {
		return switch( t ) {
		case Float: 1;
		case Vec2: 2;
		case Vec3: 3;
		case Vec4: 4;
		case Mat2: 4;
		case Mat3: 9;
		case Mat4: 16;
		case Tex2d, TexCube: throw "Unexpected " + t;
		}
	}
	
	function buildShaderInstance( shader : Shader ) {
		var cl = Type.getClass(shader);
		function compileShader(name, type) {
			var code = Reflect.field(cl, name);
			if( code == null ) throw "Missing " + Type.getClassName(cl) + "." + name + " shader source";
			var s = gl.createShader(type);
			gl.shaderSource(s, code);
			gl.compileShader(s);
			if( !gl.getShaderParameter(s, GL.COMPILE_STATUS) )
				throw "An error occurred compiling the shaders: " + gl.getShaderInfoLog(s);
			return s;
		}
		var vs = compileShader("VERTEX", GL.VERTEX_SHADER);
		var fs = compileShader("FRAGMENT", GL.FRAGMENT_SHADER);
		
		var p = gl.createProgram();
		gl.attachShader(p, vs);
		gl.attachShader(p, fs);
		gl.linkProgram(p);
		if( !gl.getProgramParameter(p, GL.LINK_STATUS) )
			throw "Program linkage failure";
	
		var inst = new Shader.ShaderInstance();
			
		var nattr = gl.getProgramParameter(p, GL.ACTIVE_ATTRIBUTES);
		inst.attribs = [];
		
		var amap = new Map();
		for( k in 0...nattr ) {
			var inf = gl.getActiveAttrib(p, k);
			amap.set(inf.name, { index : k, inf : inf });
		}
		
		var r = ~/attribute[ \t\r\n]+([A-Za-z0-9_]+)[ \t\r\n]+([A-Za-z0-9_]+)/;
		var code : String = Reflect.field(cl, "VERTEX");
		var offset = 0;
		while( r.match(code) ) {
			var aname = r.matched(2);
			var atype = decodeType(r.matched(1));
			var a = amap.get(aname);
			var size = typeSize(atype);
			if( a != null )
				inst.attribs.push( { name : aname, type : atype, etype : GL.FLOAT, size : size, index : a.index, offset : offset } );
			offset += size;
			code = r.matchedRight();
		}
		inst.stride = offset;
		
		var nuni = gl.getProgramParameter(p, GL.ACTIVE_UNIFORMS);
		inst.uniforms = [];
		var texIndex = 0;
		for( k in 0...nuni ) {
			var inf = gl.getActiveUniform(p, k);
			var t = decodeTypeInt(inf.type);
			inst.uniforms.push( {
				name : inf.name,
				type : t,
				loc : gl.getUniformLocation(p, inf.name),
				index : texIndex,
			});
			switch( t ) {
			case Tex2d, TexCube:
				texIndex++;
			default:
			}
		}
			
		inst.program = p;
		return inst;
		
	}

	override function selectShader( shader : Shader ) : Bool {
		var change = false;
		if( shader.instance == null )
			shader.instance = buildShaderInstance(shader);
		if( shader.instance != curShader ) {
			curShader = shader.instance;
			gl.useProgram(curShader.program);
			for( i in curAttribs...curShader.attribs.length ) {
				gl.enableVertexAttribArray(i);
				curAttribs++;
			}
			while( curAttribs > curShader.attribs.length )
				gl.disableVertexAttribArray(--curAttribs);
			change = true;
		}
			
		
		for( u in curShader.uniforms ) {
			var val : Dynamic = Reflect.field(shader, u.name);
			if( val == null ) throw "Missing shader value " + u.name;
			switch( u.type ) {
			case Mat4:
				var m : Matrix = val;
				gl.uniformMatrix4fv(u.loc, false, new js.html.Float32Array(m.getFloats()));
			case Tex2d:
				var t : h3d.mat.Texture = val;
				gl.activeTexture(GL.TEXTURE0 + u.index);
				gl.bindTexture(GL.TEXTURE_2D, t.t);
				var flags = TFILTERS[Type.enumIndex(t.mipMap)][Type.enumIndex(t.filter)];
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, flags[0]);
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, flags[1]);
				gl.uniform1i(u.loc, u.index);
			default:
				throw "Unsupported uniform " + u.type;
			}
		}
		
		return change;
	}
	
	override function selectBuffer( v : VertexBuffer ) {
		var stride : Int = untyped v.stride;
		if( stride < curShader.stride )
			throw "Buffer stride (" + stride + ") and shader stride (" + curShader.stride + ") mismatch";
		gl.bindBuffer(GL.ARRAY_BUFFER, v);
		for( a in curShader.attribs )
			gl.vertexAttribPointer(a.index, a.size, a.etype, false, stride * 4, a.offset * 4);
	}
	
	override function draw( ibuf : IndexBuffer, startIndex : Int, ntriangles : Int ) {
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, ibuf);
		gl.drawElements(GL.TRIANGLES, ntriangles * 3, GL.UNSIGNED_SHORT, startIndex * 2);
		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	}
	
	override function present() {
		gl.finish();
	}

	override function isDisposed() {
		return false;
	}

	override function init( onCreate : Bool -> Void, forceSoftware = false ) {
		haxe.Timer.delay(onCreate.bind(false), 1);
	}
	
	static var TFILTERS = [
		[[GL.NEAREST,GL.NEAREST],[GL.LINEAR,GL.LINEAR]],
		[[GL.NEAREST,GL.NEAREST_MIPMAP_NEAREST],[GL.LINEAR,GL.LINEAR_MIPMAP_NEAREST]],
		[[GL.NEAREST,GL.NEAREST_MIPMAP_LINEAR],[GL.LINEAR,GL.LINEAR_MIPMAP_LINEAR]],
	];
	
}

#end
