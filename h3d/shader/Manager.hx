package h3d.shader;

class Manager {

	public var globals : hxsl.Globals;
	var shaderCache : hxsl.Cache;
	var output : Int;

	public function new(output) {
		shaderCache = hxsl.Cache.get();
		globals = new hxsl.Globals();
		this.output = shaderCache.allocOutputVars(output);
	}
	
	function fillRec( v : Dynamic, type : hxsl.Ast.Type, out : haxe.ds.Vector<Float>, pos : Int ) {
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
		case TArray(t, SConst(len)):
			var v : Array<Dynamic> = v;
			var stride = 0;
			for( i in 0...len ) {
				var n = v[i];
				if( n == null ) break;
				stride = fillRec(n, t, out, pos);
				// align
				stride += (4 - (stride & 3)) & 3;
				pos += stride;
			}
			return len * stride;
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
	
	inline function getParamValue( p : hxsl.RuntimeShader.AllocParam, shaders : Array<hxsl.Shader> ) : Dynamic {
		if( p.perObjectGlobal != null ) {
			var v = globals.fastGet(p.perObjectGlobal.gid);
			if( v == null ) throw "Missing global value " + p.perObjectGlobal.path;
			return v;
		}
		var v = shaders[p.instance].getParamValue(p.index);
		if( v == null ) throw "Missing param value " + shaders[p.instance] + "." + p.name;
		return v;
	}
	
	public function fillGlobals( buf : Buffers, s : hxsl.RuntimeShader ) {
		inline function fill(buf:Buffers.ShaderBuffers, s:hxsl.RuntimeShader.RuntimeShaderData) {
			for( g in s.globals ) {
				var v = globals.fastGet(g.gid);
				if( v == null ) throw "Missing global value " + g.path;
				fillRec(v, g.type, buf.globals, g.pos);
			}
		}
		fill(buf.vertex, s.vertex);
		fill(buf.fragment, s.fragment);
	}
	
	public function fillParams( buf : Buffers, s : hxsl.RuntimeShader, shaders : Array<hxsl.Shader> ) {
		inline function fill(buf:Buffers.ShaderBuffers, s:hxsl.RuntimeShader.RuntimeShaderData) {
			for( p in s.params ) {
				var v = getParamValue(p, shaders);
				fillRec(v, p.type, buf.params, p.pos);
			}
			var tid = 0;
			for( p in s.textures ) {
				var t = getParamValue(p, shaders);
				if( t == null ) t = h3d.mat.Texture.fromColor(0xFFFF00FF);
				buf.tex[tid++] = t;
			}
		}
		fill(buf.vertex, s.vertex);
		fill(buf.fragment, s.fragment);
	}
	
	public function compileShaders( shaders : Array<hxsl.Shader> ) {
		var instances = [for( s in shaders ) { s.updateConstants(globals); @:privateAccess s.instance; }];
		return shaderCache.link(instances, output);
	}

}
