package h3d.pass;

class ShaderManager {

	public var globals : hxsl.Globals;
	var shaderCache : hxsl.Cache;
	var currentOutput : hxsl.ShaderList;

	public function new(?output:Array<hxsl.Output>) {
		shaderCache = hxsl.Cache.get();
		#if flash
		shaderCache.constsToGlobal = true;
		#end
		globals = new hxsl.Globals();
		currentOutput = new hxsl.ShaderList(null);
		setOutput(output);
	}

	public function setOutput( ?output : Array<hxsl.Output> ) {
		if( output == null ) output = [Value("output.color")];
		currentOutput.s = shaderCache.getLinkShader(output);
	}

	@:noDebug
	function fillRec( v : Dynamic, type : hxsl.Ast.Type, out : h3d.shader.Buffers.ShaderBufferData, pos : Int ) {
		switch( type ) {
		case TFloat:
			out[pos] = v;
			return 1;
		case TVec(n, _):
			var v : h3d.Vector = v;
			out[pos++] = v.x;
			out[pos++] = v.y;
			switch( n ) {
			case 3:
				out[pos++] = v.z;
			case 4:
				out[pos++] = v.z;
				out[pos++] = v.w;
			}
			return n;
		case TMat4:
			var m : h3d.Matrix = v;
			out[pos++] = m._11;
			out[pos++] = m._21;
			out[pos++] = m._31;
			out[pos++] = m._41;
			out[pos++] = m._12;
			out[pos++] = m._22;
			out[pos++] = m._32;
			out[pos++] = m._42;
			out[pos++] = m._13;
			out[pos++] = m._23;
			out[pos++] = m._33;
			out[pos++] = m._43;
			out[pos++] = m._14;
			out[pos++] = m._24;
			out[pos++] = m._34;
			out[pos++] = m._44;
			return 16;
		case TMat3x4:
			var m : h3d.Matrix = v;
			out[pos++] = m._11;
			out[pos++] = m._21;
			out[pos++] = m._31;
			out[pos++] = m._41;
			out[pos++] = m._12;
			out[pos++] = m._22;
			out[pos++] = m._32;
			out[pos++] = m._42;
			out[pos++] = m._13;
			out[pos++] = m._23;
			out[pos++] = m._33;
			out[pos++] = m._43;
			return 12;
		case TMat3:
			var m : h3d.Matrix = v;
			out[pos++] = m._11;
			out[pos++] = m._21;
			out[pos++] = m._31;
			out[pos++] = 0;
			out[pos++] = m._12;
			out[pos++] = m._22;
			out[pos++] = m._32;
			out[pos++] = 0;
			out[pos++] = m._13;
			out[pos++] = m._23;
			out[pos++] = m._33;
			out[pos++] = 0;
			return 12;
		case TArray(TVec(4,VFloat), SConst(len)):
			var v : Array<h3d.Vector> = v;
			for( i in 0...len ) {
				var n = v[i];
				if( n == null ) break;
				out[pos++] = n.x;
				out[pos++] = n.y;
				out[pos++] = n.z;
				out[pos++] = n.w;
			}
			return len * 4;
		case TArray(TMat3x4, SConst(len)):
			var v : Array<h3d.Matrix> = v;
			for( i in 0...len ) {
				var m = v[i];
				if( m == null ) break;
				out[pos++] = m._11;
				out[pos++] = m._21;
				out[pos++] = m._31;
				out[pos++] = m._41;
				out[pos++] = m._12;
				out[pos++] = m._22;
				out[pos++] = m._32;
				out[pos++] = m._42;
				out[pos++] = m._13;
				out[pos++] = m._23;
				out[pos++] = m._33;
				out[pos++] = m._43;
			}
			return len * 12;
		case TArray(TFloat, SConst(len)):
			var v : Array<Float> = v;
			var size = 0;
			var count = v.length < len ? v.length : len;
			for( i in 0...count )
				out[pos++] = v[i];
			return len;
		case TArray(t, SConst(len)):
			var v : Array<Dynamic> = v;
			var size = 0;
			for( i in 0...len ) {
				var n = v[i];
				if( n == null ) break;
				size = fillRec(n, t, out, pos);
				pos += size;
			}
			return len * size;
		case TStruct(vl):
			var tot = 0;
			for( vv in vl )
				tot += fillRec(Reflect.field(v, vv.name), vv.type, out, pos + tot);
			return tot;
		default:
			throw "assert " + type;
		}
		return 0;
	}

	public inline function getParamValue( p : hxsl.RuntimeShader.AllocParam, shaders : hxsl.ShaderList, opt = false ) : Dynamic {
		if( p.perObjectGlobal != null ) {
			var v : Dynamic = globals.fastGet(p.perObjectGlobal.gid);
			if( v == null ) throw "Missing global value " + p.perObjectGlobal.path;
			if( p.type.match(TChannel(_)) )
				return v.texture;
			return v;
		}
		var si = shaders;
		var n = p.instance;
		while( --n > 0 ) si = si.next;
		var v = si.s.getParamValue(p.index);
		if( v == null && !opt ) throw "Missing param value " + si.s + "." + p.name;
		return v;
	}

	public function fillGlobals( buf : h3d.shader.Buffers, s : hxsl.RuntimeShader ) {
		inline function fill(buf:h3d.shader.Buffers.ShaderBuffers, s:hxsl.RuntimeShader.RuntimeShaderData) {
			var g = s.globals;
			while( g != null ) {
				var v = globals.fastGet(g.gid);
				if( v == null ) {
					if( g.path == "__consts__" ) {
						fillRec(s.consts, g.type, buf.globals, g.pos);
						g = g.next;
						continue;
					}
					throw "Missing global value " + g.path;
				}
				fillRec(v, g.type, buf.globals, g.pos);
				g = g.next;
			}
		}
		fill(buf.vertex, s.vertex);
		fill(buf.fragment, s.fragment);
	}

	public function fillParams( buf : h3d.shader.Buffers, s : hxsl.RuntimeShader, shaders : hxsl.ShaderList ) {
		inline function fill(buf:h3d.shader.Buffers.ShaderBuffers, s:hxsl.RuntimeShader.RuntimeShaderData) {
			var p = s.params;
			while( p != null ) {
				if( p.type == TFloat && p.perObjectGlobal == null ) {
					var si = shaders;
					var n = p.instance;
					while( --n > 0 ) si = si.next;
					buf.params[p.pos] = si.s.getParamFloatValue(p.index);
					p = p.next;
					continue;
				}
				var v : Dynamic = getParamValue(p, shaders);
				fillRec(v, p.type, buf.params, p.pos);
				p = p.next;
			}
			var tid = 0;
			var p = s.textures2D;
			while( p != null ) {
				var t = getParamValue(p, shaders);
				if( t == null ) t = h3d.mat.Texture.fromColor(0xFF00FF);
				buf.tex[tid++] = t;
				p = p.next;
			}
			var p = s.texturesCube;
			while( p != null ) {
				var t = getParamValue(p, shaders);
				if( t == null ) t = h3d.mat.Texture.fromColor(0xFF00FF);
				buf.tex[tid++] = t;
				p = p.next;
			}
		}
		fill(buf.vertex, s.vertex);
		fill(buf.fragment, s.fragment);
	}

	public function compileShaders( shaders : hxsl.ShaderList ) {
		globals.resetChannels();
		for( s in shaders ) s.updateConstants(globals);
		currentOutput.next = shaders;
		var s = shaderCache.link(currentOutput);
		currentOutput.next = null;
		return s;
	}

}
